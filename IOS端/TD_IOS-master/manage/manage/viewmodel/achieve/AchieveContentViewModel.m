//
//  AchieveContentViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AchieveContentViewModel.h"
#import "STNetUtil.h"
#import "STTimeUtil.h"

@interface AchieveContentViewModel()

@property(assign, nonatomic)int merchant_PID;
@property(assign, nonatomic)int device_PID;
@property(assign, nonatomic)int profit_PID;

@end


@implementation AchieveContentViewModel


-(instancetype)init{
    if(self == [super init]){
        _merchant_PID = 1;
        _device_PID = 1;
        _profit_PID = 1;
        _merchantDatas = [[NSMutableArray alloc]init];
        _deviceDatas = [[NSMutableArray alloc]init];
        _profitDatas = [[NSMutableArray alloc]init];
        _year = [[STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy"] intValue];
        _month = [[STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"MM"] intValue];
    }
    return self;
}

-(void)requestMerchantList:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _merchant_PID = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *startDate = [NSString stringWithFormat:@"%d-%02d-01",_year,_month];
    dic[@"startDate"] = startDate;
    dic[@"endDate"] = [STTimeUtil generateCourseDate:startDate];
    dic[@"type"] = @(1);
    dic[@"pageId"] = @(_merchant_PID);
    dic[@"pageSize"] = @(PAGESIZE);

    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_HOME_DETAIL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id page = [data objectForKey:@"page"];
            NSString *totalCount = [[page objectForKey:@"totalCount"] stringValue];
            NSString *extraCount = [[data objectForKey:@"indirectTotal"] stringValue];

            NSMutableArray *rows = [MerchantModel mj_objectArrayWithKeyValuesArray:[page objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.merchantDatas = rows;
            }else{
                [weakSelf.merchantDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[page objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.merchant_PID += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:@(Achieve_Merchant)];
            }else{
                [weakSelf.delegate onRequestNoData:Achieve_Merchant];
            }
            [weakSelf.delegate onRequestTotalCount:totalCount extra:extraCount];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


-(void)requestDeviceList:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _device_PID = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *startDate = [NSString stringWithFormat:@"%d-%02d-01",_year,_month];
    dic[@"startDate"] = startDate;
    dic[@"endDate"] = [STTimeUtil generateCourseDate:startDate];
    dic[@"type"] = @(2);
    dic[@"pageId"] = @(_device_PID);
    dic[@"pageSize"] = @(PAGESIZE);
    
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_HOME_DETAIL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id page = [data objectForKey:@"page"];
            NSString *totalCount = [[data objectForKey:@"total"] stringValue];
            NSMutableArray *rows = [DeviceModel mj_objectArrayWithKeyValuesArray:[page objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.deviceDatas = rows;
            }else{
                [weakSelf.deviceDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[page objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.device_PID += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:@(Achieve_Device)];
            }else{
                [weakSelf.delegate onRequestNoData:Achieve_Device];
            }
            [weakSelf.delegate onRequestTotalCount:totalCount extra:0];

        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


-(void)reqeustProfitList:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _profit_PID = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *startDate = [NSString stringWithFormat:@"%d-%02d-01",_year,_month];
    dic[@"startDate"] = startDate;
    dic[@"endDate"] = [STTimeUtil generateCourseDate:startDate];
    dic[@"pageId"] = @(_profit_PID);
    dic[@"pageSize"] = @(PAGESIZE);
//    dic[@"addZeroData"] = @(1);

    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_PROFIT_LIST parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id page = [data objectForKey:@"pages"];
            if(page == [NSNull null]){
                [weakSelf.profitDatas removeAllObjects];
                [weakSelf.delegate onRequestNoData:Achieve_Profit];
                [weakSelf.delegate onRequestTotalCount:@"0" extra:@"0"];
                return;
            }
            NSString *tradeTotal = [[data objectForKey:@"tradeTotal"] stringValue];
            NSString *profitTotal = [[data objectForKey:@"profitTotal"] stringValue];
            NSMutableArray *rows = [ProfitModel mj_objectArrayWithKeyValuesArray:[page objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.profitDatas = rows;
            }else{
                [weakSelf.profitDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[page objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.profit_PID += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:@(Achieve_Profit)];
            }else{
                [weakSelf.delegate onRequestNoData:Achieve_Profit];
            }
            [weakSelf.delegate onRequestTotalCount:tradeTotal extra:profitTotal];
            
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}



@end


