//
//  CapitalDetailViewModel.m
//  manage
//
//  Created by by.huang on 2019/1/16.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "CapitalDetailViewModel.h"
#import "STNetUtil.h"
#import "STTimeUtil.h"
#import "AccountModel.h"

@interface CapitalDetailViewModel()

@property(assign, nonatomic)int device_PID;
@property(assign, nonatomic)int profit_PID;

@end

@implementation CapitalDetailViewModel


-(instancetype)init{
    if(self == [super init]){
        _profit_PID = 1;
        _device_PID = 1;
        _profitDatas = [[NSMutableArray alloc]init];
        _deviceDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)getDeviceUsing{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"queryDate"] = _date;
    WS(weakSelf)
    [STNetUtil get:URL_DEVICEUSING parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            weakSelf.detailModel = [CapitalDetailModel mj_objectWithKeyValues:data];
            weakSelf.detailModel.actualYuan = weakSelf.detailModel.profitOrderYuan - weakSelf.detailModel.profitRefundYuan;
            [weakSelf.delegate onRequestSuccess:respondModel data:data];
        }else{
            [weakSelf.delegate onRequestNoData:CapitalDetailType_All];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)getChildProfit:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _profit_PID = 1;
    }
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"queryDate"] = _date;
    dic[@"pageId"] = @(_profit_PID);
    dic[@"pageSize"] = @(PAGESIZE);

    WS(weakSelf)
    [STNetUtil get:URL_CHILD_DEVICEUSING parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id row = [data objectForKey:@"rows"];
            NSMutableArray *rows = [CapitalDetailModel mj_objectArrayWithKeyValuesArray:row];
            if(refreshNew){
                weakSelf.profitDatas = rows;
            }else{
                [weakSelf.profitDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.profit_PID += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:@(CapitalDetailType_Profit)];
            }else{
                [weakSelf.delegate onRequestNoData:CapitalDetailType_Profit];
            }
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)getChildDeviceUsing:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _device_PID = 1;
    }
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"queryDate"] = _date;
    dic[@"pageId"] = @(_device_PID);
    dic[@"pageSize"] = @(PAGESIZE);
    
    WS(weakSelf)
    [STNetUtil get:URL_CHILD_DEVICEUSING parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id row = [data objectForKey:@"rows"];
            NSMutableArray *rows = [CapitalDetailModel mj_objectArrayWithKeyValuesArray:row];
            if(refreshNew){
                weakSelf.deviceDatas = rows;
            }else{
                [weakSelf.deviceDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.device_PID += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:@(CapitalDetailType_Device)];
            }else{
                [weakSelf.delegate onRequestNoData:CapitalDetailType_Device];
            }
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

////获取提现时间
//-(void)getWithdrawTime{
//    WS(weakSelf)
//    [STNetUtil get:URL_MYDETAIL parameters:nil success:^(RespondModel *respondModel) {
//        if([respondModel.status isEqualToString:STATU_SUCCESS]){
//            id user = [respondModel.data objectForKey:@"user"];
//            AccountModel *model = [AccountModel mj_objectWithKeyValues:user];
//            [weakSelf.delegate onRequestSuccess:respondModel data:@(model.settementPeriod)];
//        }
//    } failure:^(int errorCode) {}];
//}

@end
