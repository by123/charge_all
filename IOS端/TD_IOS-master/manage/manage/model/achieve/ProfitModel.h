//
//  ProfitModel.h
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfitModel : NSObject

@property(copy, nonatomic)NSString *mchId;
//收益时间
@property(assign, nonatomic)long profitDate;
//tx状态
@property(copy, nonatomic)NSString *statu;
//收益金额
@property(assign, nonatomic)double profit;
//设备分润收入
@property(assign, nonatomic)double profitOrderYuan;
//扣款分润扣除
@property(assign, nonatomic)double profitRefundYuan;
//预计收益计提时间
@property(copy, nonatomic)NSString *profitTime;
//可tx时间
@property(assign, nonatomic)long canWithDrawDate;

@end

NS_ASSUME_NONNULL_END
