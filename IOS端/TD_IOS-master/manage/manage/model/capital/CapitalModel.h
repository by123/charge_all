//
//  CapitalModel.h
//  manage
//
//  Created by by.huang on 2018/11/17.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CapitalModel : NSObject

@property(assign, nonatomic)double freezeNum;
@property(assign, nonatomic)double total;
@property(assign, nonatomic)double canWithdrawNum;
@property(assign, nonatomic)double waitSettlement;
@property(assign, nonatomic)double todayIncome;
@property(assign, nonatomic)double balanceAmount;
@property(assign, nonatomic)double frozenMoney;

@end

NS_ASSUME_NONNULL_END
