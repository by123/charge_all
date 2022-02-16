//
//  LoginViewModel.m
//  manage
//
//  Created by by.huang on 2018/10/25.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "LoginViewModel.h"
#import "STNetUtil.h"
#import "AccountManager.h"
#import "STUserDefaults.h"

@implementation LoginViewModel


-(void)doLogin:(NSString *)userName psw:(NSString *)password{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    
    [STUserDefaults saveKeyValue:UD_USERNAME value:userName];
    
    if([[STConvertUtil base64Decode:MSG_TEST_ID] isEqualToString:userName]){
        [STUserDefaults saveKeyValue:UD_SETTING value:LIMIT_CLOSE];
    }else{
        [STUserDefaults saveKeyValue:UD_SETTING value:LIMIT_OPEN];
    }

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"userName"] = userName;
    dic[@"password"] = password;
    WS(weakSelf)
    [STNetUtil post:URL_LOGIN content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id user = [data objectForKey:@"user"];
            id tblMch = [data objectForKey:@"tblMch"];
            NSString *token = NOT_NULL([data objectForKey:@"token"]);
            UserModel *model = [UserModel mj_objectWithKeyValues:user];
            model.token = token;
            
            model.level = [[tblMch objectForKey:@"level"] intValue];
            model.mchName = NOT_NULL([tblMch objectForKey:@"mchName"]);
            model.contactUser = NOT_NULL([tblMch objectForKey:@"contactUser"]);
            model.contactPhone = NOT_NULL([tblMch objectForKey:@"contactPhone"]);
            model.province = NOT_NULL([tblMch objectForKey:@"province"]);
            model.city = NOT_NULL([tblMch objectForKey:@"city"]);
            model.area = NOT_NULL([tblMch objectForKey:@"area"]);
            model.detailAddr = NOT_NULL([tblMch objectForKey:@"detailAddr"]);
//            model.createTime = [[tblMch objectForKey:@"createTime"] longValue];
            model.settementPeriod = [[tblMch objectForKey:@"settementPeriod"] intValue];
            model.totalPercent = [[tblMch objectForKey:@"totalPercent"] doubleValue];
            model.salesId = NOT_NULL([tblMch objectForKey:@"salesId"]);
            model.superUser = NOT_NULL([tblMch objectForKey:@"superUser"]);
            model.industry = NOT_NULL([tblMch objectForKey:@"industry"]);
            model.supportSevice = ([tblMch objectForKey:@"supportSevice"] == [NSNull null] ? 0 : 1);
            [[AccountManager sharedAccountManager]saveUserModel:model];
            [weakSelf.delegate onRequestSuccess:respondModel data:data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
 
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}



//类型，0：超级管理员（admin），1:普通管理员 2：代理商业务员，3：商户业务员

-(void)goForgetPswPage{
    if(_delegate){
        [_delegate goNextPage];
    }
}


-(void)goAgreementPage{
    if(_delegate){
        [_delegate onGoAgreementPage];
    }
}
@end
