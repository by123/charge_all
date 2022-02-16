//
//  MsgViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/17.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MsgViewModel.h"
#import "STNetUtil.h"


@interface MsgViewModel()

@property(assign, nonatomic)int pid;

@end

@implementation MsgViewModel


-(instancetype)init{
    if(self == [super init]){
        _datas = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)requestMsgList:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _pid = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"pageId"] = @(_pid);
    dic[@"pageSize"] = @(PAGESIZE);
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_MSG_LIST parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            NSMutableArray *rows = [MsgModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.datas = rows;
            }else{
                [weakSelf.datas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.pid += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
            }else{
                [weakSelf.delegate onRequestNoData:IS_NS_COLLECTION_EMPTY(weakSelf.datas)];
            }
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)goMsgDetailPage:(NSString *)msgId{
    if(_delegate){
        [_delegate onGoMsgDetailPage:msgId];
    }
}
@end
