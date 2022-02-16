//
//  ForgetPswViewModel.m
//  manage
//
//  Created by by.huang on 2018/12/18.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ForgetPswViewModel.h"
#import "STNetUtil.h"

@implementation ForgetPswViewModel

-(void)closePage{
    if(_delegate){
        [_delegate onClosePage];
    }
}


-(void)getVerifyCode:(NSString *)accountStr{
    if(!_delegate)  return;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"userName"] = accountStr;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_GET_VERIFYCODE parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.accountStr = accountStr;
            weakSelf.phoneNum = respondModel.data;
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)checkVerifyCode:(NSString *)verifyCode{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"smsCode"] = verifyCode;
    dic[@"userName"] = _accountStr;
    WS(weakSelf)
    [STNetUtil post:URL_CHECK_VERIFYCODE content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            weakSelf.token = data;
            [weakSelf.delegate onRequestSuccess:respondModel data:data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
        
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)resetPsw:(NSString *)password{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"confirmPassword"] = password;
    dic[@"password"] = password;
    dic[@"token"] = _token;
    dic[@"userName"] = _accountStr;
    WS(weakSelf)
    [STNetUtil post:URL_RESET_PASSWORD content:dic.mj_JSONString success:^(RespondModel *respondModel) {
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

@end
