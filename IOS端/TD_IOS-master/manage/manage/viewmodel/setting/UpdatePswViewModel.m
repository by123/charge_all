//
//  UpdatePswViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "UpdatePswViewModel.h"
#import "STNetUtil.h"

@implementation UpdatePswViewModel


-(void)updatePsw:(NSString *)oldPsw newPsw:(NSString *)newPsw reNewPsw:(NSString *)reNewPsw{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"conformPwd"] = reNewPsw;
    dic[@"needCheck"] = @"0";
    dic[@"oldPwd"] = oldPsw;
    dic[@"submitPwd"] = newPsw;

    [STNetUtil post:URL_UPDATE_PSW content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
        
}
@end
