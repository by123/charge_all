//
//  AgentDetailViewModel.m
//  manage
//
//  Created by by.huang on 2019/1/10.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "AgentDetailViewModel.h"
#import "STNetUtil.h"
#import "PayRuleModel.h"

@implementation AgentDetailViewModel

-(instancetype)init{
    if(self == [super init]){
        _model = [[AgentDetailModel alloc]init];
        _infoDatas = [[NSMutableArray alloc]init];
        _agentDatas = [[NSMutableArray alloc]init];
        _ruleDatas = [[NSMutableArray alloc]init];
        _deviceDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)reqeustAgentDetail:(NSString *)mchId{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = mchId;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_AGENT_DETAIL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.model = [AgentDetailModel mj_objectWithKeyValues:respondModel.data];
            NSMutableArray *priceRules = weakSelf.model.mchPriceRule;
            if(!IS_NS_COLLECTION_EMPTY(priceRules)){
                id priceRule = [priceRules objectAtIndex:0];
                double pledgeYuan = [[priceRule objectForKey:@"pledgeYuan"] doubleValue];
                weakSelf.model.pledgeYuan = [NSString stringWithFormat:@"%.2f",pledgeYuan];
                id ruleStr = [priceRule objectForKey:@"service"];
                weakSelf.model.service = [PayRuleModel mj_objectArrayWithKeyValuesArray:ruleStr];
            }
            [weakSelf.delegate onRequestSuccess:respondModel data:weakSelf.model];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)goAgentEditPage{
    if(_delegate){
        [_delegate onGoAgentEditPage:_model];
    }
}

-(void)goMerchantEditPage{
    if(_delegate){
        [_delegate onGoMerchantEditPage:_model];
    }
}

-(void)goNavigation:(double)myLatitude myLongitude:(double)myLongitude latitude:(double)latitude longitude:(double)longitude name:(NSString *)name{
    if(_delegate){
        [_delegate onGoNavigation:myLatitude myLongitude:myLongitude latitude:latitude longitude:longitude name:name];
    }
}

@end
