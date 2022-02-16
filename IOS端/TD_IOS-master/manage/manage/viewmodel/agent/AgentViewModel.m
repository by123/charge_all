//
//  AgentViewModel.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AgentViewModel.h"
#import "STNetUtil.h"
#import "AccountManager.h"

@implementation AgentViewModel


-(instancetype)init{
    if(self == [super init]){
        _model = [[AddAgentModel alloc]init];
    }
    return self;
}


-(void)addAgent{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    
    UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"contactPhone"] = _model.contactPhone;
    dic[@"contactUser"] = _model.contactUser;
    dic[@"mchName"] = _model.mchName;
    dic[@"profitSubAgent"] = _model.profitSubAgent;
    dic[@"level"] = _model.level;
    dic[@"salesId"] = userModel.userId;
    int blockedAmountYuan = [_model.blockedAmount doubleValue]* 100;
    dic[@"blockedAmount"] = IntStr(blockedAmountYuan);
    dic[@"province"] = _model.province;
    dic[@"city"] = _model.city;
    dic[@"area"] = _model.area;
    dic[@"detailAddr"] = _model.detailAddr;

    WS(weakSelf)
    [STNetUtil post:URL_ADD_AGENT content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            [weakSelf.delegate onRequestSuccess:respondModel data:data];
        }else{
             [weakSelf.delegate onRequestFail:respondModel.msg];
        }

    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


-(void)goLocationPage{
    if(_delegate){
        [_delegate onGoLocationPage];
    }
}


@end
