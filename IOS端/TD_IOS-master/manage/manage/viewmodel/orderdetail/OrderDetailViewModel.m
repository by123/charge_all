//
//  OrderDetailViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderDetailViewModel.h"
#import "STNetUtil.h"
#import "STTimeUtil.h"

@implementation OrderDetailViewModel

-(instancetype)init{
    if(self == [super init]){
        _model = [[OrderDetailModel alloc]init];
    }
    return self;
}

-(void)requestOrderDetail{
    if(!_delegate)  return;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"orderId"]= _orderId;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_ORDER_DETAIL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id tblOrder = [data objectForKey:@"tblOrder"];
            
            weakSelf.model.orderId = [tblOrder objectForKey:@"orderId"];
            weakSelf.model.userName = [tblOrder objectForKey:@"userName"];
            weakSelf.model.orderStateWeb = [[data objectForKey:@"orderStateWeb"] intValue];
            weakSelf.model.myProfilt = [[data objectForKey:@"myProfilt"] doubleValue];
            weakSelf.model.descendantsTotalProfit = [[data objectForKey:@"descendantsTotalProfit"] doubleValue];
            weakSelf.model.orderPriceYuan = [[data objectForKey:@"orderPriceYuan"] doubleValue];
            weakSelf.model.deviceSn = [tblOrder objectForKey:@"deviceSn"];
            weakSelf.model.mchName = [tblOrder objectForKey:@"mchName"];
            weakSelf.model.deviceLocation = [data objectForKey:@"deviceLocation"];
            weakSelf.model.location = [tblOrder objectForKey:@"location"];
            weakSelf.model.canRefund = [[data objectForKey:@"canRefund"] boolValue];
            weakSelf.model.pwd = [tblOrder objectForKey:@"pwd"];
            if([tblOrder objectForKey:@"pwdCount"] != [NSNull null]){
                weakSelf.model.pwdCount = [[tblOrder objectForKey:@"pwdCount"] intValue];
            }
            //
            id refundOperatorId = [data objectForKey:@"refundOperatorId"];
            if((NSNull *)refundOperatorId == [NSNull null] || refundOperatorId == nil){
                refundOperatorId = MSG_EMPTY;
            }
            weakSelf.model.refundOperatorId = refundOperatorId;
            
            //
            id refundOperatorName = [data objectForKey:@"refundOperatorName"];
            if((NSNull *)refundOperatorName == [NSNull null] || refundOperatorName == nil){
                refundOperatorName = MSG_EMPTY;
            }
            weakSelf.model.refundOperatorName = refundOperatorName;
            
            //
            id refundReason = [data objectForKey:@"refundReason"];
            if((NSNull *)refundReason == [NSNull null] || refundReason == nil){
                refundReason = MSG_EMPTY;
            }
            weakSelf.model.refundReason = refundReason;

            //开始时间
            id startTime = [tblOrder objectForKey:@"startTime"];
            if((NSNull *)startTime == [NSNull null]){
                startTime = @"无";
            }else{
                startTime = [STTimeUtil generateDate:startTime format:MSG_TIME_FORMAT];
            }
            weakSelf.model.startTime = startTime;
            
            //结束时间
            id actualEndTime = [tblOrder objectForKey:@"actualEndTime"];
            if((NSNull *)actualEndTime == [NSNull null]){
                actualEndTime = @"无";
            }else{
                actualEndTime = [STTimeUtil generateDate:actualEndTime format:MSG_TIME_FORMAT];
            }
            weakSelf.model.actualEndTime = actualEndTime;
            
            //创建时间
            id createTime = [tblOrder objectForKey:@"createTime"];
            if((NSNull *)createTime == [NSNull null]){
                createTime = @"无";
            }else{
                createTime = [STTimeUtil generateDate:createTime format:MSG_TIME_FORMAT];
            }
            weakSelf.model.createTime = createTime;
            
            
            //支付时间
            id platformPayTime = [tblOrder objectForKey:@"platformPayTime"];
            if((NSNull *)platformPayTime == [NSNull null]){
                platformPayTime = @"无";
            }else{
                platformPayTime = [STTimeUtil generateDate:platformPayTime format:MSG_TIME_FORMAT];
            }
            weakSelf.model.platformPayTime = platformPayTime;
            
            weakSelf.model.transactionId = [tblOrder objectForKey:@"transactionId"];
            weakSelf.model.payType = [[tblOrder objectForKey:@"payType"] intValue];
            
            weakSelf.model.refundMoneyYuan = [[data objectForKey:@"refundMoneyYuan"] doubleValue];
            
            //
            id refundTime = [data objectForKey:@"refundTime"];
            if((NSNull *)refundTime == [NSNull null]){
                refundTime = @"无";
            }else{
                refundTime = [STTimeUtil generateDate:refundTime format:MSG_TIME_FORMAT];
            }
            weakSelf.model.refundTime = refundTime;
            
            //
            NSString *refundId = [data objectForKey:@"refundId"];
            if((NSNull *)refundId == [NSNull null]){
                refundId = @"无";
            }
            weakSelf.model.refundId = refundId;
            
            //
            weakSelf.model.depositPriceYuan = [[data objectForKey:@"depositPriceYuan"] doubleValue];
            
            //
            id refundDepositState = [data objectForKey:@"refundDepositState"];
            if((NSNull *)refundDepositState == [NSNull null]){
                refundDepositState = @"无";
            }else{
                refundDepositState = [OrderDetailModel getRefundStatu:[refundDepositState intValue]];
            }
            weakSelf.model.refundDepositState =  refundDepositState;
            
            //
            id refundDepositTime = [data objectForKey:@"refundDepositTime"];
            if((NSNull *)refundDepositTime == [NSNull null]){
                refundDepositTime = @"无";
            }else{
                refundDepositTime = [STTimeUtil generateDate:refundDepositTime format:MSG_TIME_FORMAT];
            }
            weakSelf.model.refundDepositTime = refundDepositTime;
            
            //
            NSString *refundDepositId = [data objectForKey:@"refundDepositId"];
            if((NSNull *)refundDepositId == [NSNull null]){
                refundDepositId = @"无";
            }
            weakSelf.model.refundDepositId = refundDepositId;
            //出租车字段
            weakSelf.model.groupName = [self getKeyValue:data key:@"groupName"];
            weakSelf.model.taxiDriverName = [self getKeyValue:data key:@"taxiDriverName"];
            weakSelf.model.taxiDriverPhone = [self getKeyValue:data key:@"taxiDriverPhone"];
//            weakSelf.model.profitToTaxi = [[data objectForKey:@"profitToTaxi"] doubleValue];

            [weakSelf.delegate onRequestSuccess:respondModel data:data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(NSString *)getKeyValue:(id)data key:(NSString *)key{
    NSString *value = [data objectForKey:key];
    if((NSNull *)value == [NSNull null]){
        value = MSG_EMPTY;
    }
    return value;
}


-(void)goRefundPage:(OrderDetailModel *)model{
    if(_delegate){
        OrderModel *orderModel = [[OrderModel alloc]init];
        orderModel.orderId = model.orderId;
        orderModel.orderPriceYuan = model.orderPriceYuan;
        orderModel.depositPriceYuan = model.depositPriceYuan;
        [_delegate onGoRefundPage:orderModel];
    }
}
@end
