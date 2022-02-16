//
//  WithdrawViewModel.m
//  manage
//
//  Created by by.huang on 2018/12/4.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawViewModel.h"
#import "STNetUtil.h"
#import "AccountManager.h"

@implementation WithdrawViewModel

-(instancetype)init{
    if(self == [super init]){
        _banks = [[NSMutableArray alloc]init];
        _withDrawModel = [[WithdrawModel alloc]init];
    }
    return self;
}

-(void)requestRule:(double)withdrawMoneyYuan{

    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"withdrawMoney"] = @(withdrawMoneyYuan);
    dic[@"mchType"] = @(model.mchType);
    WS(weakSelf)
    [STNetUtil get:URL_WITHDRAW_RULE parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.withDrawModel= [WithdrawModel mj_objectWithKeyValues:respondModel.data];
//            [weakSelf.withdrawModels sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                WithdrawModel *model1 = obj1;
//                WithdrawModel *model2 = obj2;
//                return model1.withdrawStartNumYuan > model2.withdrawStartNumYuan;
//            }];
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)reqeustBankInfo{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_BANKINFO parameters:nil success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id banks = [respondModel.data objectForKey:@"banks"];
            id tblUserUnionid = [respondModel.data objectForKey:@"tblUserUnionid"];
            NSString *headUrl;
            if(tblUserUnionid && tblUserUnionid != [NSNull null]){
                headUrl = [tblUserUnionid objectForKey:@"headUrl"];
            }
            if(banks){
                weakSelf.banks = [BankModel mj_objectArrayWithKeyValuesArray:banks];
                if(!IS_NS_COLLECTION_EMPTY(weakSelf.banks)){
                    //默认银行取第一个
                    weakSelf.defaultModel = weakSelf.banks[0];
                    for(BankModel *model in weakSelf.banks){
                        if(model.isPublic == 2){
                            model.headUrl = headUrl;
                            //如果绑定了微信，则默认选择微信
                            weakSelf.defaultModel = model;
                        }
                    }
                    weakSelf.defaultModel.isSelect = YES;
                }
            }
            [weakSelf.delegate onRequestSuccess:respondModel data:weakSelf.banks];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


-(void)backLastPage{
    if(_delegate){
        [_delegate onBackLastPage];
    }
}

-(void)doWithdraw:(NSString *)money{
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"bankId"] = _defaultModel.bankId;
    dic[@"withdrawMoney"] = money;
    [STLog print:@"传递的提现金额" content:money];
    WS(weakSelf)
    [STNetUtil post:URL_WITHDRAW content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            NSString *withdrawId = [respondModel.data objectForKey:@"withdrawId"];
            [weakSelf.delegate onRequestSuccess:respondModel data:withdrawId];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


-(void)goSelectBank{
    if(_delegate){
        [_delegate onGoSelectBank:_banks];
    }
}

-(void)goBindWeChat{
    if(_delegate){
        [_delegate onGoBindWeChat];
    }
}
@end
