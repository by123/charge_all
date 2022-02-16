//
//  MerchantEditViewModel.m
//  manage
//
//  Created by by.huang on 2019/1/11.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "MerchantEditViewModel.h"
#import "STNetUtil.h"

@implementation MerchantEditViewModel

-(instancetype)initWithModel:(AgentDetailModel *)detailModel{
    if(self == [super init]){
        _detailModel = detailModel;
        _model = [[AddMerchantModel alloc]init];
        _model.mchId = _detailModel.mchId;
        _model.contactPhone = _detailModel.contactPhone;
        _model.contactUser = _detailModel.contactUser;
        _model.mchName = _detailModel.mchName;
        _model.industry = _detailModel.industry;
        _model.pledge = _detailModel.pledgeYuan;
        _model.profitSubAgent = [NSString stringWithFormat:@"%.2f",_detailModel.totalPercent];

    }
    return self;
}

-(void)requestEditMerchant{
    
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"contactPhone"] = _model.contactPhone;
    dic[@"contactUser"] = _model.contactUser;
    dic[@"mchName"] = _model.mchName;
    dic[@"industry"] = _model.industry;
    dic[@"mchId"] = _model.mchId;
    int blockedAmountYuan = [_model.blockedAmount doubleValue]* 100;
    dic[@"blockedAmount"] = IntStr(blockedAmountYuan);
    dic[@"province"] = _model.province;
    dic[@"city"] = _model.city;
    dic[@"area"] = _model.area;
    dic[@"detailAddr"] = _model.detailAddr;
    
    //绝对分润比例
    dic[@"profitSubAgent"] = _model.profitSubAgent;
    if(_model.isRelative){
        //相对比例
        dic[@"profitPool"] = _model.profitPool;
        dic[@"percentInPool"] = _model.percentInPool;
    }
    
    NSLog(@"%@",dic.mj_JSONString);
    WS(weakSelf)
    [STNetUtil post:URL_EDIT_MERCHANT content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [self requestRule];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
        
    }];
}


-(void)requestRule{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"pledgeYuan"] = _model.pledge;
    dic[@"service"] = _model.service;
    dic[@"tenantId"] = _model.mchId;
    dic[@"serviceType"] = @(_model.serviceType);
    
    WS(weakSelf)
    [STNetUtil post:URL_UPDATE_RULE content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.delegate onRequestSuccess:respondModel data:nil];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
        
    }];
}

-(void)getDefaultPayRule{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_DEFALT_PAY_RULE parameters:nil success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id rule = [respondModel.data objectForKey:@"defaultPriceRule"];
            weakSelf.rules = [PayRuleModel mj_objectArrayWithKeyValuesArray:rule];
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
    
}

-(void)goBack{
    if(_delegate){
        [_delegate onGoBack];
    }
}


-(void)goLocationPage{
    if(_delegate){
        [_delegate onGoLocationPage];
    }
}


@end
