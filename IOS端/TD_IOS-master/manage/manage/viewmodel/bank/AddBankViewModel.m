//
//  AddBankViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/30.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AddBankViewModel.h"
#import "STNetUtil.h"

@implementation AddBankViewModel


-(instancetype)init{
    if(self == [super init]){
        _model = [[BankCommitModel alloc]init];
    }
    return self;
}
-(void)doSaveCorporateBank{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"accountName"] = _model.accountName;
    dic[@"bankBranch"] = _model.bankBranch;
    dic[@"bankCode"] = _model.bankCode;
    dic[@"bankId"] = _model.bankId;
    dic[@"bankName"] = _model.bankName;
    dic[@"cityCode"] = _model.cityCode;
    dic[@"cityName"] = _model.cityName;
    dic[@"isPublic"] = @"1";
    [STNetUtil post:URL_SAVEBANK content:dic.mj_JSONString success:^(RespondModel *respondModel) {
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

-(void)doSavePersonBank{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"cardNo"] = _model.bankId;
    WS(weakSelf)
    [STNetUtil get:URL_CARDNUM_CHECK parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic[@"accountName"] = weakSelf.model.accountName;
            dic[@"bankCode"] = weakSelf.model.bankCode;
            dic[@"bankId"] = weakSelf.model.bankId;
            dic[@"bankName"] = weakSelf.model.bankName;
            dic[@"isPublic"] = @"0";
            [STNetUtil post:URL_SAVEBANK content:dic.mj_JSONString success:^(RespondModel *respondModel) {
                if([respondModel.status isEqualToString:STATU_SUCCESS]){
                    id data = respondModel.data;
                    [weakSelf.delegate onRequestSuccess:respondModel data:data];
                }else{
                    [weakSelf.delegate onRequestFail:respondModel.msg];
                }
            } failure:^(int errorCode) {
                [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
            }];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}
    
    
-(void)checkCardNum:(NSString *)cardNum{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"cardNo"] = cardNum;
    WS(weakSelf)
    [STNetUtil get:URL_CARDNUM_CHECK parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            BankSelectModel *bankModel = [BankSelectModel mj_objectWithKeyValues:respondModel.data];
            [weakSelf.delegate onRequestSuccess:respondModel data:bankModel];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


@end
