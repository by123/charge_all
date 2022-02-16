//
//  MerchantUnBindViewModel.m
//  manage
//
//  Created by by.huang on 2019/5/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "MerchantUnBindViewModel.h"
#import "STNetUtil.h"

@implementation MerchantUnBindViewModel


-(instancetype)init{
    if(self == [super init]){
        _model = [[UnBindModel alloc]init];
    }
    return self;
}


-(void)queryMerchantDetail{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = _mchModel.mchId;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_MERCHANT_DEVICE_TOTAL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.model = [UnBindModel mj_objectWithKeyValues:respondModel.data];
            [weakSelf.delegate onRequestSuccess:respondModel data:weakSelf.model];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)doUnbindMerchant{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = _mchModel.mchId;
    WS(weakSelf)
    [STNetUtil get:URL_UNBIND_MERCHANT_DEVICE parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:@"unbind"];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:@"unbind"];
    }];
}

-(void)openDialog{
    if(_delegate){
        [_delegate onOpenDialog];
    }
}


@end
