//
//  SalemanViewModel.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "SalemanViewModel.h"
#import "STNetUtil.h"
#import "AccountManager.h"

@implementation SalemanViewModel

-(instancetype)init{
    if(self == [super init]){
        _model = [[AddSalemanModel alloc]init];
    }
    return self;
}


-(void)addSaleman{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"name"] = _model.name;
    dic[@"mobile"] = _model.mobile;

    WS(weakSelf)
    [STNetUtil post:URL_ADD_SALEMAN content:dic.mj_JSONString success:^(RespondModel *respondModel) {
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
