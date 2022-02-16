//
//  AddAgentModel.h
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddAgentModel : NSObject

//分润比例
@property(copy, nonatomic)NSString *profitSubAgent;
//代理商名称
@property(copy, nonatomic)NSString *mchName;
//代理商级别
@property(copy, nonatomic)NSString *level;
//联系人
@property(copy, nonatomic)NSString *contactUser;
//联系电话
@property(copy, nonatomic)NSString *contactPhone;
//
@property(copy, nonatomic)NSString *salesId;

@property(copy, nonatomic)NSString *mchId;

//
@property(copy, nonatomic)NSString *industry;

//冻结金额
@property(copy, nonatomic)NSString *blockedAmount;

@property(copy, nonatomic)NSString *blockedAmountYuan;

@property(copy, nonatomic)NSString *province;
@property(copy, nonatomic)NSString *city;
@property(copy, nonatomic)NSString *area;
@property(copy, nonatomic)NSString *detailAddr;


@end

NS_ASSUME_NONNULL_END
