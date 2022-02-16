//
//  BankViewModel.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BankViewModel.h"
#import "STNetUtil.h"
#import "AccountManager.h"

@implementation BankViewModel


-(instancetype)init{
    if(self == [super init]){
        _banks = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)getBankInfo{
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
                    for(BankModel *model in weakSelf.banks){
                        if(model.isPublic == 2){
                            model.headUrl = headUrl;
                        }
                    }
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


-(void)goAddBankHomePage{
    if(_delegate){
        [_delegate onGoAddBankHomePage:_banks];
    }
}

-(void)goBankDetailPage:(BankModel *)model{
    if(_delegate){
        [_delegate onGoBankDetailPage:model];
    }
}
@end
