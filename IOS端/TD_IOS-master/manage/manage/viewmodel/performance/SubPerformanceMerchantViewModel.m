//
//  SubPerformanceMerchantViewModel.m
//  manage
//
//  Created by by.huang on 2019/6/19.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "SubPerformanceMerchantViewModel.h"
#import "PerformanceMerchantModel.h"
#import "STNetUtil.h"

@interface SubPerformanceMerchantViewModel()

@property(assign, nonatomic)int merchantPageId;

@end

@implementation SubPerformanceMerchantViewModel


-(instancetype)init{
    if(self == [super init]){
        _merchantPageId = 1;
        _merchantDatas = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)reqeustMerchant:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _merchantPageId = 1;
    }
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = _mchId;
    dic[@"bgnDate"] = _startDay;
    dic[@"endDate"] = _endDay;
    dic[@"pageId"] = @(_merchantPageId);
    dic[@"pageSize"] = @(PAGESIZE);
    if(!IS_NS_STRING_EMPTY(_qryInfo)){
        dic[@"keyWord"] = _qryInfo;
    }
    WS(weakSelf)
    NSString *requestUrl = _isChild ? URL_PERFORMANCE_MERCHANT_SUBLIST : URL_PERFORMANCE_MERCHANT_LIST;
    [STNetUtil get:requestUrl parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id row = [data objectForKey:@"rows"];
            if(row == [NSNull null]){
                //无数据
                [weakSelf.merchantDatas removeAllObjects];
                [weakSelf.delegate onRequestNoData:YES requestUrl:requestUrl];
                return;
            }
            NSMutableArray *rows = [PerformanceMerchantModel mj_objectArrayWithKeyValuesArray:row];
            if(refreshNew){
                weakSelf.merchantDatas = rows;
            }else{
                [weakSelf.merchantDatas addObjectsFromArray:rows];
            }
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.merchantPageId += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
            }else{
                if(IS_NS_COLLECTION_EMPTY(weakSelf.merchantDatas)){
                    [weakSelf.delegate onRequestNoData:YES requestUrl:requestUrl];
                }else{
                    [weakSelf.delegate onRequestNoData:NO requestUrl:requestUrl];
                }
            }
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
    [self requestMerchantTotal];
}

-(void)requestMerchantTotal{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = _mchId;
    dic[@"bgnDate"] = _startDay;
    dic[@"endDate"] = _endDay;
    WS(weakSelf)
    [STNetUtil get:URL_PERFORMANCE_MERCHANT_TOTAL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            weakSelf.directAgent = [[data objectForKey:@"directAgent"] intValue];
            weakSelf.directTenant = [[data objectForKey:@"directTenant"] intValue];
            weakSelf.subordinateAgent = [[data objectForKey:@"subordinateAgent"] intValue];
            weakSelf.subordinateTenant = [[data objectForKey:@"subordinateTenant"] intValue];
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}




-(void)goSubPerformanceMerchantPage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay{
    if(_delegate){
        [_delegate onGoSubPerformanceMerchantPage:mchId mchName:mchName startDay:startDay endDay:endDay];
    }
}

-(void)goDetailPage:(NSString *)mchId mchType:(int)mchType{
    if(_delegate){
        [_delegate onGoDetailPage:mchId mchType:mchType];
    }
}


@end
