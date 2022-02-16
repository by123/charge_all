//
//  BankDetailViewModel.m
//  manage
//
//  Created by by.huang on 2018/12/3.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BankDetailViewModel.h"
#import "TitleContentModel.h"

@implementation BankDetailViewModel

-(instancetype)initWithModel:(BankModel *)bankModel{
    if(self == [super init]){
        _datas = [[NSMutableArray alloc]init];
        _bankModel = bankModel;
        [self initDatas];
    }
    return self;
}

-(void)initDatas{
    if(_bankModel == nil)return;
    
    if(_bankModel.isPublic == 0){
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_TYPE content:MSG_BK_GEREN_TYPE]];
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_KAIKAREN_NAME content:_bankModel.accountName]];
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_CARDNUM content:_bankModel.bankId]];
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_KAIHU content:_bankModel.bankName]];
    }else if(_bankModel.isPublic == 1){
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_TYPE content:MSG_BK_DUIGONG_TYPE]];
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_ACCOUNT_NAME content:_bankModel.accountName]];
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_DUIGONG content:_bankModel.bankId]];
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_KAIHU content:_bankModel.bankName]];
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_ZHIHANG content:_bankModel.bankBranch]];
    }else if(_bankModel.isPublic == 2){
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_TYPE content:MSG_BK_WECHAT_TYPE]];
        [_datas addObject:[TitleContentModel buildModel:MSG_BK_NICK_NAME content:_bankModel.accountName]];
//        [_datas addObject:[TitleContentModel buildModel:MSG_BK_WECHATID content:_bankModel.bankId]];
    }
}

@end
