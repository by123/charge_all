//
//  CapitalViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/17.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "CapitalViewModel.h"
#import "STNetUtil.h"
#import "STTimeUtil.h"

@interface CapitalViewModel()

@property(assign, nonatomic)int withdraw_PID;
@property(assign, nonatomic)int profit_PID;

@end

@implementation CapitalViewModel

-(instancetype)init{
    if(self == [super init]){
        _year = [[STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy"] intValue];
        _month = [[STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"MM"] intValue];
        _withdraw_PID = 1;
        _profit_PID = 1;
        _withdrawDatas = [[NSMutableArray alloc]init];
        _profitDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)requestCapitalData{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_CAPITAL_LIST parameters:nil success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            weakSelf.model = [CapitalModel mj_objectWithKeyValues:data];
            [weakSelf.delegate onRequestSuccess:respondModel data:data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}



-(void)reqeustCapitalList:(Boolean)refreshNew{
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
    dic[@"addZeroData"] = @(1);
    
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_PROFIT_LIST parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id page = [data objectForKey:@"pages"];
            if(page == [NSNull null]){
                [weakSelf.profitDatas removeAllObjects];
                [weakSelf.delegate onRequestNoData:CapitalType_Profit];
                return;
            }
            
            NSMutableArray *rows = [ProfitModel mj_objectArrayWithKeyValuesArray:[page objectForKey:@"rows"]];
            if(refreshNew){
//                [rows removeObjectAtIndex:0];
                weakSelf.profitDatas = rows;
            }else{
                [weakSelf.profitDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[page objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.profit_PID += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:@(CapitalType_Profit)];
            }else{
                [weakSelf.delegate onRequestNoData:CapitalType_Profit];
            }
            
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


-(void)reqeustWithdrawList:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _withdraw_PID = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *startDate = [NSString stringWithFormat:@"%d-%02d-01",_year,_month];
    dic[@"startDate"] = startDate;
    dic[@"endDate"] = [STTimeUtil generateCourseDate:startDate];
    dic[@"pageId"] = @(_withdraw_PID);
    dic[@"pageSize"] = @(PAGESIZE);
    
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_WITHDRAW_LIST parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            NSMutableArray *rows = [WithdrawDetailModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.withdrawDatas = rows;
            }else{
                [weakSelf.withdrawDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.withdraw_PID += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:@(CapitalType_Withdraw)];
            }else{
                [weakSelf.delegate onRequestNoData:CapitalType_Withdraw];
            }
            
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
    
}

-(void)updateUI:(int)type count:(NSInteger)count{
    if(_delegate){
        [_delegate onUpdateUI:type count:count];
    }
}

-(void)goWithdrawSuccessPage:(NSString *)withdrawId{
    if(_mainViewModel){
        [_mainViewModel goWithdrawSuccessPage:withdrawId];
    }
}

-(void)goWithdrawFailPage:(NSString *)withdrawId{
    if(_mainViewModel){
        [_mainViewModel goWithdrawFailPage:withdrawId];
    }
}

-(void)goCapitalDetailPage:(NSString *)capitalId{
    if(_mainViewModel){
        [_mainViewModel goCapitalDetailPage:capitalId];
    }
}

@end
