//
//  OrderDetailModel.h
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailModel : NSObject

//订单ID
@property(copy, nonatomic)NSString *orderId;

//订单类型
@property(assign, nonatomic)int orderStateWeb;

//用户ID
@property(copy, nonatomic)NSString *userName;

//我的收益
@property(assign, nonatomic)double myProfilt;

//下级收益
@property(assign, nonatomic)double descendantsTotalProfit;

//订单金额
@property(assign, nonatomic)double orderPriceYuan;

//订单密码
@property(nonatomic, nonatomic)NSString *pwd;

//订单count
@property(assign, nonatomic)int pwdCount;

//设备编号
@property(copy, nonatomic)NSString *deviceSn;

//商户名称
@property(copy, nonatomic)NSString *mchName;

//所属x区域
@property(copy, nonatomic)NSString *deviceLocation;

//使用位置
@property(copy, nonatomic)NSString *location;

//支付流水号
@property(copy, nonatomic)NSString *transactionId;

//支付方式
@property(assign, nonatomic)int payType;


#pragma mark 退款相关

//退款金额
@property(assign, nonatomic)double refundMoneyYuan;

//退款时间
@property(copy, nonatomic)NSString *refundTime;

//退款流水号
@property(copy, nonatomic)NSString *refundId;



#pragma mark 押金相关
//押金
@property(assign, nonatomic)double depositPriceYuan;

//退押金状态
@property(copy, nonatomic)NSString *refundDepositState;

//退押金时间
@property(copy, nonatomic)NSString *refundDepositTime;

//押金退款流水
@property(copy, nonatomic)NSString *refundDepositId;



//各种时间

//下单时间
@property(copy, nonatomic)NSString *createTime;

//支付时间
@property(copy, nonatomic)NSString *platformPayTime;

//充电开始时间
@property(copy, nonatomic)NSString *startTime;

//充电结束时间
@property(copy, nonatomic)NSString *actualEndTime;

//
@property(assign, nonatomic)BOOL canRefund;

//
@property(copy, nonatomic)NSString *refundOperatorId;
@property(copy, nonatomic)NSString *refundOperatorName;
@property(copy, nonatomic)NSString *refundReason;

#pragma mark 出租车相关
@property(copy, nonatomic)NSString *taxiDriverName;
@property(copy, nonatomic)NSString *taxiDriverPhone;
@property(assign, nonatomic)double profitToTaxi;
@property(copy, nonatomic)NSString *groupName;

+(NSString *)getOrderStatu:(int)orderStatu;
+(NSString *)getRefundStatu:(int)refundStatu;

@end


NS_ASSUME_NONNULL_END
