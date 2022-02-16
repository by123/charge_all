//
//  ChainViewModel.m
//  manage
//
//  Created by by.huang on 2019/2/25.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "ChainViewModel.h"
#import "STNetUtil.h"
#import "AccountManager.h"

@implementation ChainViewModel
    
-(instancetype)init{
    if(self == [super init]){
        _model = [[AddChainModel alloc]init];
    }
    return self;
}


-(void)addChain{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    
    UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"contactPhone"] = _model.contactPhone;
    dic[@"contactUser"] = _model.contactUser;
    dic[@"mchName"] = _model.chainName;
    dic[@"profitSubAgent"] = _model.profitSubAgent;
    dic[@"salesId"] = userModel.userId;
    dic[@"industry"] = _model.industry;
    int blockedAmountYuan = [_model.blockedAmount doubleValue]* 100;
    dic[@"blockedAmount"] = IntStr(blockedAmountYuan);
    dic[@"province"] = _model.province;
    dic[@"city"] = _model.city;
    dic[@"area"] = _model.area;
    dic[@"detailAddr"] = _model.detailAddr;
    WS(weakSelf)
    [STNetUtil post:URL_ADD_CHAIN content:dic.mj_JSONString success:^(RespondModel *respondModel) {
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

-(void)goLocationPage{
    if(_delegate){
        [_delegate onGoLocationPage];
    }
}


@end

