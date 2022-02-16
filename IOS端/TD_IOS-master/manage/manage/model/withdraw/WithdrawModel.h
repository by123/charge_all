//
//  WithdrawModel.h
//  manage
//
//  Created by by.huang on 2018/12/4.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface WithdrawModel : NSObject

@property(assign, nonatomic)int mchType;
@property(assign, nonatomic)double withdrawStartNumYuan;
@property(assign, nonatomic)double withdrawMaxNumYuan;
@property(assign, nonatomic)double auxiliaryExpensesYuan;
@property(assign, nonatomic)double payExpensesYuan;
@property(assign, nonatomic)double taxYuan;
@property(assign, nonatomic)double withdrawRealYuan;



//channel 0 银行卡  1 微信
@property(assign, nonatomic)int channel;

@property(assign, nonatomic)WithDrawType type;

@end


NS_ASSUME_NONNULL_END
