//
//  WithdrawDetailModel.h
//  manage
//
//  Created by by.huang on 2018/12/6.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawDetailModel : NSObject

@property(copy, nonatomic)NSString *withdrawId;
@property(copy, nonatomic)NSString *bankId;
@property(copy, nonatomic)NSString *accountName;
@property(assign, nonatomic)double withdrawMoneyTotalYuan;
@property(assign, nonatomic)double auxiliaryExpensesYuan;
@property(assign, nonatomic)double withdrawMoneyYuan;
@property(assign, nonatomic)double payExpensesYuan;
@property(assign, nonatomic)double taxYuan;

@property(assign, nonatomic)long createTime;
@property(copy, nonatomic)NSString *bankOrderid;
@property(assign, nonatomic)int withdrawState;
@property(copy, nonatomic)NSString *failedMsg;
@property(copy, nonatomic)NSString *alarmCheckMessage;
@property(assign, nonatomic)int isPublic;

+(NSString *)getStatuStr:(int)withdrawState;

@end

NS_ASSUME_NONNULL_END
