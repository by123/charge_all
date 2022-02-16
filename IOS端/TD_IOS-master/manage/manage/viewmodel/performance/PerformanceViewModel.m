//
//  PerformanceViewModel.m
//  manage
//
//  Created by by.huang on 2019/6/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "PerformanceViewModel.h"
#import "PerformanceActiveModel.h"
#import "PerformanceMerchantModel.h"
#import "PerformanceArchiveModel.h"
#import "STNetUtil.h"

@interface PerformanceViewModel()

@property(assign, nonatomic)int activePageId;
@property(assign, nonatomic)int merchantPageId;
@property(assign, nonatomic)int archivePageId;

@end

@implementation PerformanceViewModel

-(instancetype)init{
    if(self == [super init]){
        _activePageId = 1;
        _merchantPageId = 1;
        _archivePageId = 1;
        
        _merchantDatas = [[NSMutableArray alloc]init];
        _activeDatas = [[NSMutableArray alloc]init];
        _archiveDatas = [[NSMutableArray alloc]init];
        
    }
    return self;
}

-(void)requestActive:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _activePageId = 1;
    }
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = _mchId;
    dic[@"startDay"] = _startDay;
    dic[@"endDay"] = _endDay;
    dic[@"pageId"] = @(_activePageId);
    dic[@"pageSize"] = @(PAGESIZE);
    if(!IS_NS_STRING_EMPTY(_qryInfo)){
        dic[@"qryInfo"] = _qryInfo;
    }
    WS(weakSelf)
    [STNetUtil get:URL_PERFORMANCE_ACTIVE_LIST parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id row = [data objectForKey:@"rows"];
            if(row == [NSNull null]){
                //无数据
                [weakSelf.activeDatas removeAllObjects];
                [weakSelf.delegate onRequestNoData:YES requestUrl:URL_PERFORMANCE_ACTIVE_LIST];
                return;
            }
            NSMutableArray *rows = [PerformanceActiveModel mj_objectArrayWithKeyValuesArray:row];
            if(refreshNew){
                weakSelf.activeDatas = rows;
            }else{
                [weakSelf.activeDatas addObjectsFromArray:rows];
            }
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.activePageId += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
            }else{
                [weakSelf.delegate onRequestNoData:NO requestUrl:URL_PERFORMANCE_ACTIVE_LIST];
            }
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
    [self requestActiveTotal];
}

-(void)requestActiveTotal{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = _mchId;
    dic[@"startDay"] = _startDay;
    dic[@"endDay"] = _endDay;
//    if(!IS_NS_STRING_EMPTY(_qryInfo)){
//        dic[@"qryInfo"] = _qryInfo;
//    }
    WS(weakSelf)
    [STNetUtil get:URL_PERFORMANCE_ACTIVE_TOTAL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.count = [[respondModel.data objectForKey:@"sum"] intValue];
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
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



-(void)requestArchiveList:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _archivePageId = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"startDate"] = [NSString stringWithFormat:@"%@ 00:00:00",_startDay];
    dic[@"endDate"] = [NSString stringWithFormat:@"%@ 23:59:59",_endDay];
    dic[@"pageId"] = @(_archivePageId);
    dic[@"pageSize"] = @(PAGESIZE);
    
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_PROFIT_LIST parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id page = [data objectForKey:@"pages"];
            weakSelf.orderCount = [[data objectForKey:@"tradeTotal"] intValue];
            weakSelf.amountCount = [[data objectForKey:@"profitTotal"] doubleValue];
            if(page == [NSNull null]){
                [weakSelf.archiveDatas removeAllObjects];
                [weakSelf.delegate onRequestNoData:YES requestUrl:URL_PROFIT_LIST];
                return;
            }
            id row = [page objectForKey:@"rows"];
            if(row == [NSNull null]){
                [weakSelf.archiveDatas removeAllObjects];
                [weakSelf.delegate onRequestNoData:YES requestUrl:URL_PROFIT_LIST];
                return;
            }
            NSMutableArray *rows = [PerformanceArchiveModel mj_objectArrayWithKeyValuesArray:row];
            if(refreshNew){
                weakSelf.archiveDatas = rows;
            }else{
                [weakSelf.archiveDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[page objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.archivePageId += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
            }else{
                [weakSelf.delegate onRequestNoData:NO requestUrl:URL_PROFIT_LIST];
            }
            
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}



-(void)goSubPerformanceActivePage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay{
    if(_delegate){
        [_delegate onGoSubPerformanceActivePage:mchId mchName:mchName startDay:startDay endDay:endDay];
    }
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
