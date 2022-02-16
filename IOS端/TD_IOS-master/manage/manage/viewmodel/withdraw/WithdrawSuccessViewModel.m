//
//  WithdrawSuccessViewModel.m
//  manage
//
//  Created by by.huang on 2018/12/5.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawSuccessViewModel.h"
#import "STNetUtil.h"

@implementation WithdrawSuccessViewModel


-(void)requestWithdrawDetail:(NSString *)withdrawId{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"withDrawId"] = withdrawId;
    WS(weakSelf)
    [STNetUtil get:URL_WITHDRAW_DETAIL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.model = [WithdrawDetailModel mj_objectWithKeyValues:respondModel.data];
            [weakSelf.delegate onRequestSuccess:respondModel data:nil];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


-(void)backHomePage{
    if(_delegate){
        [_delegate onBackHomePage];
    }
}
@end
