//
//  BindMerchantViewModel.m
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BindMerchantViewModel.h"
#import "STNetUtil.h"

@interface BindMerchantViewModel()

@property(assign, nonatomic)int pid;

@end

@implementation BindMerchantViewModel

-(instancetype)init{
    if(self == [super init]){
        _pid = 1;
        _merchantDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)getMechantDatas:(NSString *)queryName refreshNew:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _pid = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchName"] = queryName;
    dic[@"pageId"] = @(_pid);
    dic[@"pageSize"] = @(PAGESIZE);
    dic[@"mchForm"] = @"1";
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil post:URL_QUERY_All_AGENT_AND_MERCHANT content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            NSMutableArray *rows = [MerchantModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.merchantDatas = rows;
            }else{
                [weakSelf.merchantDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.pid += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
            }else{
                [weakSelf.delegate onRequestNoData:IS_NS_COLLECTION_EMPTY(weakSelf.merchantDatas)];
            }
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


//绑定商户
-(void)doBindMerchant:(MerchantModel *)model{
    if(_delegate){
        [_delegate onBindMerchant:model];
    }
}

-(void)bindMerchant:(MerchantModel *)model{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"openid"] = _openid;
    dic[@"unionid"] = _unionid;
    dic[@"userId"] = model.superUser;
    dic[@"type"] = _type;
    WS(weakSelf)
    [STNetUtil post:URL_BIND_MERCHANT content:dic.mj_JSONString success:^(RespondModel *respondModel) {
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

//激活商户
-(void)goStartActiveDevice:(NSString *)mchId mchName:(NSString *)mchName{
    if(_delegate){
        [_delegate onScanDevice:mchId mchName:mchName];
    }
}


//解绑设备
-(void)goMerchantUnBindPage:(MerchantModel *)model{
    if(_delegate){
        [_delegate onGoMerchantUnBindPage:model];
    }
}

@end
