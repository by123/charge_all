//
//  AddChainModel.h
//  manage
//
//  Created by by.huang on 2019/3/12.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddChainModel : NSObject

@property(copy, nonatomic)NSString *profitSubAgent;
//连锁门店名称
@property(copy, nonatomic)NSString *chainName;
//联系人
@property(copy, nonatomic)NSString *contactUser;
//联系电话
@property(copy, nonatomic)NSString *contactPhone;
//所属行业
@property(copy, nonatomic)NSString *industry;
//
@property(copy, nonatomic)NSString *salesId;

@property(copy, nonatomic)NSString *mchId;
//冻结金额
@property(copy, nonatomic)NSString *blockedAmount;

@property(copy, nonatomic)NSString *blockedAmountYuan;

@property(copy, nonatomic)NSString *province;
@property(copy, nonatomic)NSString *city;
@property(copy, nonatomic)NSString *area;
@property(copy, nonatomic)NSString *detailAddr;
@end

NS_ASSUME_NONNULL_END
