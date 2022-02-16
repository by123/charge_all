//
//  TaxiViewModel.m
//  manage
//
//  Created by by.huang on 2019/4/2.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "TaxiViewModel.h"
#import "STNetUtil.h"
#import "GroupModel.h"
#import "STUserDefaults.h"

@interface TaxiViewModel()

@property(assign, nonatomic)int pageId;

@end

@implementation TaxiViewModel

-(instancetype)init{
    if(self == [super init]){
        _datas = [[NSMutableArray alloc]init];
        _pageId = 1;
        [self getTaxiConfig];
    }
    return self;
}

//保存出租车配置数据
-(void)getTaxiConfig{
    id result = [STUserDefaults getKeyValue:CONFIG_TAXI];
    if(result){
        NSDictionary *dic = [NSDictionary mj_objectWithKeyValues:result];
        NSString *time = [dic objectForKey:@"time"];
        NSString *scale = [dic objectForKey:@"scale"];
        [STUserDefaults saveKeyValue:UD_TAXI_TIME value:time];
        [STUserDefaults saveKeyValue:UD_TAXI_SCALE value:scale];
    }
}

- (void)requestGroupList:(Boolean)refreshNew{
    if(!_delegate) return;
    if(refreshNew){
        _pageId = 1;
    }
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"pageSize"] = @(PAGESIZE);
    dic[@"pageId"] = @(_pageId);
    WS(weakSelf)
    [STNetUtil post:URL_GROUP_LIST content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id row = [data objectForKey:@"rows"];
            if(row == [NSNull null]){
                [weakSelf.datas removeAllObjects];
                [weakSelf.delegate onRequestNoData:YES];
                return;
            }
            NSMutableArray *rows = [GroupModel mj_objectArrayWithKeyValuesArray:row];
            if(refreshNew){
                weakSelf.datas = rows;
            }else{
                [weakSelf.datas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.pageId += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
            }else{
                [weakSelf.delegate onRequestNoData:NO];
            }
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
        
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)createGroup{
    if(_delegate){
        [_delegate onCreateGroup];
    }
}

-(void)goScanPage:(NSString *)groupId groupName:(NSString *)groupName{
    if(_delegate){
       [_delegate onGoScanPage:groupId groupName:groupName];
    }
}

-(void)goGroupDetailPage:(GroupModel *)model{
    if(_delegate){
        [_delegate onGoGroupDetailPage:model];
    }
}
@end
