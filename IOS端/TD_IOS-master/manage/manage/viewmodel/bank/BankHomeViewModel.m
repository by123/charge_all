//
//  BankHomeViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/30.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BankHomeViewModel.h"
#import "STNetUtil.h"
#import "AccountManager.h"

@implementation BankHomeViewModel

-(instancetype)init{
    if(self == [super init]){
        _withdrawRules = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)goAddBankPage:(NSInteger)type{
    if(_delegate){
        [_delegate onGoAddBankPage:type];
    }
}

-(void)requestRule{
//    if(!_delegate)  return;
//    [_delegate onRequestBegin];
//    WS(weakSelf)
//    [STNetUtil get:URL_WITHDRAW_RULE parameters:nil success:^(RespondModel *respondModel) {
//        if([respondModel.status isEqualToString:STATU_SUCCESS]){
//            weakSelf.withdrawRules = [WithdrawModel mj_objectArrayWithKeyValuesArray:respondModel.data];
//            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
//        }else{
//            [weakSelf.delegate onRequestFail:respondModel.msg];
//        }
//    } failure:^(int errorCode) {
//        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
//    }];
}

@end
