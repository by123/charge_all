//
//  WithdrawFailViewModel.m
//  manage
//
//  Created by by.huang on 2018/12/5.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawFailViewModel.h"
#import "STNetUtil.h"

@implementation WithdrawFailViewModel

-(void)requestWithdrawDetail:(NSString *)withdrawId{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"withDrawId"] = withdrawId;
    WS(weakSelf)
    [STNetUtil get:URL_WITHDRAW_DETAIL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            WithdrawDetailModel *model = [WithdrawDetailModel mj_objectWithKeyValues:respondModel.data];
            if(model.withdrawState == -3){
                weakSelf.errorMsg = model.alarmCheckMessage;
            }
            else if(model.withdrawState == 3){
                weakSelf.errorMsg = model.failedMsg;
            }
            [weakSelf.delegate onRequestSuccess:respondModel data:nil];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

@end
