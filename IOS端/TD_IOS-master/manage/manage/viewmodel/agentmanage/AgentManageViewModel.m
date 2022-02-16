//
//  AgentManageViewModel.m
//  manage
//
//  Created by by.huang on 2019/1/10.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "AgentManageViewModel.h"
#import "STNetUtil.h"

@interface AgentManageViewModel()

@property(assign, nonatomic)int pid;

@end

@implementation AgentManageViewModel

-(instancetype)init{
    if(self == [super init]){
        _pid = 1;
        _merchantDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)requestAgentList:(NSString *)key refreshNew:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _pid = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchName"] = key;
    dic[@"pageId"] = @(_pid);
    dic[@"pageSize"] = @(PAGESIZE);
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil post:URL_QUERY_All_AGENT_AND_MERCHANT content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            NSMutableArray *rows = [MerchantModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.merchantDatas = rows;
            }else{
                [weakSelf.merchantDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.pid += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
            }else{
                [weakSelf.delegate onRequestNoData:IS_NS_COLLECTION_EMPTY(weakSelf.merchantDatas)];
            }
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)goAgentDetailPage:(MerchantModel *)model{
    if(_delegate){
        [_delegate onGoAgentDetailPage:model];
    }
}


@end
