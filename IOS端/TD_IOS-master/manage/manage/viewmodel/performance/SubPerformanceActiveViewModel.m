//
//  SubPerformanceActiveViewModel.m
//  manage
//
//  Created by by.huang on 2019/6/19.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "SubPerformanceActiveViewModel.h"
#import "PerformanceActiveModel.h"
#import "STNetUtil.h"

@interface SubPerformanceActiveViewModel()

@property(assign, nonatomic)int activePageId;
@property(assign, nonatomic)int merchantPageId;
@end

@implementation SubPerformanceActiveViewModel

-(instancetype)init{
    if(self == [super init]){
        _activePageId = 1;
        _activeDatas = [[NSMutableArray alloc]init];
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
    if(!IS_NS_STRING_EMPTY(_qryInfo)){
        dic[@"qryInfo"] = _qryInfo;
    }
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

-(void)goSubPerformanceActivePage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay{
    if(_delegate){
        [_delegate onGoSubPerformanceActivePage:mchId mchName:mchName startDay:startDay endDay:endDay];
    }
}

-(void)goDetailPage:(NSString *)mchId mchType:(int)mchType{
    if(_delegate){
        [_delegate onGoDetailPage:mchId mchType:mchType];
    }
}

@end
