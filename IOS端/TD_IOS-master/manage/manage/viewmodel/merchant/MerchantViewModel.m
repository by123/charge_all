//
//  MerchantViewModel.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "MerchantViewModel.h"
#import "STNetUtil.h"
#import "AccountManager.h"
#import "MerchantModel.h"

@implementation MerchantViewModel

-(instancetype)init{
    if(self == [super init]){
        _model = [[AddMerchantModel alloc]init];
        _chains = [[NSMutableArray alloc]init];
    }
    return self;
}
    
//添加连锁门店分店
-(void)addChildChain{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    
    UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"contactPhone"] = _model.contactPhone;
    dic[@"contactUser"] = _model.contactUser;
    dic[@"industry"] = _model.industry;
    dic[@"mchName"] = _model.mchName;
    dic[@"profitSubAgent"] = _model.profitSubAgent;
    dic[@"level"] = @"0";
    dic[@"salesId"] = userModel.userId;
    dic[@"superUser"] = _model.contactPhone;
    dic[@"service"] = _model.service;
    dic[@"pledge"] = _model.pledge;
    dic[@"mchParentChainAgentId"] = _model.parentAgencyId;
    int blockedAmountYuan = [_model.blockedAmount doubleValue]* 100;
    dic[@"blockedAmount"] = IntStr(blockedAmountYuan);
    dic[@"province"] = _model.province;
    dic[@"city"] = _model.city;
    dic[@"area"] = _model.area;
    dic[@"detailAddr"] = _model.detailAddr;
    WS(weakSelf)
    [STNetUtil post:URL_ADD_CHILD_CHAIN content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            //            id data = respondModel.data;
            [weakSelf.delegate onRequestSuccess:respondModel data:weakSelf.model.mchName];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

//添加普通商户
-(void)addMerchant{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    
    UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"contactPhone"] = _model.contactPhone;
    dic[@"contactUser"] = _model.contactUser;
    dic[@"industry"] = _model.industry;
    dic[@"mchName"] = _model.mchName;
    dic[@"level"] = @"0";
    dic[@"salesId"] = userModel.userId;
    dic[@"superUser"] = _model.contactPhone;
    dic[@"service"] = _model.service;
    dic[@"serviceType"] = @(_model.serviceType);
    dic[@"pledge"] = _model.pledge;
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

    
    WS(weakSelf)
    [STNetUtil post:URL_ADD_MCH content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
//            id data = respondModel.data;
            [weakSelf.delegate onRequestSuccess:respondModel data:weakSelf.model.mchName];
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

    
-(void)queryChildChain{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = [[AccountManager sharedAccountManager] getUserModel].mchId;
    WS(weakSelf)
    [STNetUtil get:URL_QUERY_AGENT_AND_MERCHANT parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            NSMutableArray *queryDatas = [MerchantModel mj_objectArrayWithKeyValuesArray:data];
            //清空数组，添加一条空数据
            [weakSelf.chains removeAllObjects];
            MerchantModel *firstModel = [MerchantModel new];
            UserModel *userModel = [[AccountManager sharedAccountManager]getUserModel];
            //如果是连锁门店，第一条数据只可选择自己
            if(userModel.level == 4){
                firstModel.mchName = userModel.mchName;
                firstModel.mchId = userModel.mchId;
                firstModel.totalPercent = userModel.totalPercent;
            }
            [weakSelf.chains addObject:firstModel];
            if(!IS_NS_COLLECTION_EMPTY(queryDatas)){
                for(MerchantModel *model in queryDatas){
                    if(model.mchType == 0 && model.level == 4){
                        [weakSelf.chains addObject:model];
                    }
                }
            }
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
