//
//  AddMerchantModel.h
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddMerchantModel : NSObject


//商户名称
@property(copy, nonatomic)NSString *mchName;
//所属行业
@property(copy, nonatomic)NSString *industry;
//联系人
@property(copy, nonatomic)NSString *contactUser;
//联系电话
@property(copy, nonatomic)NSString *contactPhone;
//押金
@property(copy, nonatomic)NSString *pledge;
//档位
@property(copy, nonatomic)NSString *service;
@property(assign, nonatomic)int serviceType;
//商户id
@property(copy, nonatomic)NSString *mchId;

//连锁门店id
@property(copy, nonatomic)NSString *parentAgencyId;
//冻结金额
@property(copy, nonatomic)NSString *blockedAmount;

@property(copy, nonatomic)NSString *blockedAmountYuan;

@property(copy, nonatomic)NSString *province;
@property(copy, nonatomic)NSString *city;
@property(copy, nonatomic)NSString *area;
@property(copy, nonatomic)NSString *detailAddr;


//绝对分润比例
@property(copy, nonatomic)NSString *profitSubAgent;

//相对分润比例

//(分润池比例)
@property(copy, nonatomic)NSString *profitPool;
//(商户相对分润比例)
@property(copy, nonatomic)NSString *percentInPool;

@property(assign, nonatomic)Boolean isRelative;

@end

NS_ASSUME_NONNULL_END
