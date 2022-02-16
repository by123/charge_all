//
//  OrderModel.h
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : NSObject


//支付时间
@property(assign, nonatomic)long payTime;
//支付状态(订单状态，1 未支付，2 已支付 3 已完成, 4已取消, 5 退款中, 6已退款
@property(assign, nonatomic)int orderStateWeb;
//订单编号
@property(copy, nonatomic)NSString *orderId;
//设备编号
@property(copy, nonatomic)NSString *deviceSn;
//商户名称
@property(copy, nonatomic)NSString *mchName;
//下级收益
@property(assign, nonatomic)double descendantsTotalProfit;
//我的收益
@property(assign, nonatomic)double myProfit;
//未支付金额
@property(assign, nonatomic)double orderPriceYuan;
//订单金额
@property(assign, nonatomic)double servicePriceYuan;
//已退款金额
@property(assign, nonatomic)double refundMoneyYuan;
//退款中金额
@property(assign, nonatomic)double refundingMoneyYuan;
//押金
@property(assign, nonatomic)double depositPriceYuan;
//
@property(assign, nonatomic)BOOL canRefund;

//
#pragma mark 出租车相关
@property(copy, nonatomic)NSString *taxiDriverName;
@property(copy, nonatomic)NSString *taxiDriverPhone;
//@property(assign, nonatomic)double profitToTaxi;
@property(copy, nonatomic)NSString *groupName;






@end

NS_ASSUME_NONNULL_END
