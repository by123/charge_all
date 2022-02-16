//
//  OrderContentViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderContentViewModel.h"
#import "STTimeUtil.h"
#import "STNetUtil.h"

@interface OrderContentViewModel()
//@property(assign, nonatomic)int pageID;
@property(copy, nonatomic)NSString *lastOrderId;

@end

@implementation OrderContentViewModel

-(instancetype)init{
    if(self == [super init]){
//        _pageID = 1;
        _datas = [[NSMutableArray alloc]init];
        _model = [[MerchantModel alloc]init];
    }
    return self;
}


-(void)requestOrderList:(OrderType)type refreshNew:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
//        _pageID = 1;
        _lastOrderId = MSG_EMPTY;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if(type != OrderType_All){
        dic[@"orderState"]= @(type);
    }
    dic[@"payTimeStart"] = [NSString stringWithFormat:@"%@ 00:00:00",_startDate];
    dic[@"payTimeEnd"] = [NSString stringWithFormat:@"%@ 23:59:59",_endDate];
//    dic[@"pageId"] = @(_pageID);
    dic[@"pageSize"] = @(PAGESIZE);
    if(!IS_NS_STRING_EMPTY(_model.mchId)){
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:_model.mchId];
        dic[@"lstMchId"] = array;
    }
    dic[@"orderType"] = (_model.mchType == -1) ? @"1" : @"-1";
    dic[@"lastOrderId"] = _lastOrderId;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil post:URL_ORDER_LIST content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            NSString *totalCount = [data objectForKey:@"finishedOrderNum"];
            NSString *sum = [NSString stringWithFormat:@"%.2f",[[data objectForKey:@"finishedOrderServiceSumYuan"] doubleValue]];
            NSMutableArray *rows = [OrderModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.datas = rows;
            }else{
                [weakSelf.datas addObjectsFromArray:rows];
            }

            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
//                weakSelf.pageID += 1;
                OrderModel *model =  [weakSelf.datas objectAtIndex:weakSelf.datas.count -1];
                weakSelf.lastOrderId = model.orderId;
                [weakSelf.delegate onRequestSuccess:respondModel data:@(type)];
            }else{
                [weakSelf.delegate onRequestNoData:type];
            }
            [weakSelf.delegate onRequestTotalCount:totalCount sum:sum];
            
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}



@end
