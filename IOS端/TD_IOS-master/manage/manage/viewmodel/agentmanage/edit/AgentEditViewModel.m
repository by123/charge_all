//
//  AgentEditViewModel.m
//  manage
//
//  Created by by.huang on 2019/1/11.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "AgentEditViewModel.h"
#import "STNetUtil.h"
#import "AccountManager.h"

@implementation AgentEditViewModel

-(instancetype)init{
    if(self == [super init]){
        _model = [[AddAgentModel alloc]init];
    }
    return self;
}


-(void)requestEditAgent{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"contactPhone"] = _model.contactPhone;
    dic[@"contactUser"] = _model.contactUser;
    dic[@"mchName"] = _model.mchName;
    dic[@"profitSubAgent"] = _model.profitSubAgent;
    dic[@"level"] = @([_model.level intValue]);
    dic[@"mchId"] = _model.mchId;
    dic[@"industry"] = _model.industry;
    int blockedAmountYuan = [_model.blockedAmount doubleValue]* 100;
    dic[@"blockedAmount"] = IntStr(blockedAmountYuan);
    dic[@"province"] = _model.province;
    dic[@"city"] = _model.city;
    dic[@"area"] = _model.area;
    dic[@"detailAddr"] = _model.detailAddr;
    
    WS(weakSelf)
    [STNetUtil post:URL_EDIT_AGENT content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.delegate onRequestSuccess:respondModel data:nil];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];

    }];
}

-(void)goBack{
    if(_delegate){
        [_delegate onGoBack];
    }
}


-(void)goLocationPage{
    if(_delegate){
        [_delegate onGoLocationPage];
    }
}
@end
