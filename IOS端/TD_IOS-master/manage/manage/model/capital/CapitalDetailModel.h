//
//  CapitalDetailModel.h
//  manage
//
//  Created by by.huang on 2019/1/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CapitalDetailModel : NSObject

//设备订单率
@property(assign, nonatomic)double orderPercent;
//设备订单数
@property(assign, nonatomic)int orderNum;
//设备激活数
@property(assign, nonatomic)int activeDeviceTotalNum;
//设备使用率
@property(assign, nonatomic)double deviceUsingPercent;
//分润收入
@property(assign, nonatomic)double profitOrderYuan;
//退款扣除
@property(assign, nonatomic)double profitRefundYuan;
//订单金额
@property(assign, nonatomic)double orderServiceNumYuan;
//实际收益金额
@property(assign, nonatomic)double actualYuan;


@property(copy, nonatomic)NSString *mchId;
@property(copy, nonatomic)NSString *mchName;


#pragma mark 退款扣除
//我的收益
@property(assign, nonatomic)double profitForParentYuan;
//退款扣除
@property(assign, nonatomic)double refundProfitForParentYuan;
////订单金额
//@property(assign, nonatomic)double orderServiceNumYuan;

@end

NS_ASSUME_NONNULL_END
