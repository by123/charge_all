//
//  MerchantModel.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MerchantModel : NSObject

@property(copy, nonatomic)NSString *mchId;
//0 代理商 1 商户  2 平台 (自增mchType = -1 出租车)
@property(assign, nonatomic)int mchType;
@property(copy, nonatomic)NSString *mchName;
@property(assign, nonatomic)int level;
@property(copy, nonatomic)NSString *superUser;
@property(copy, nonatomic)NSString *contactUser;

//剩余分润比例
@property(assign,nonatomic)float totalPercent;
//我的分润比例
@property(assign,nonatomic)float profitPercent;

//商户列表用
@property(copy, nonatomic)NSString *salesName;
@property(assign, nonatomic)long createTime;

//连锁门店id
@property(copy, nonatomic)NSString *parentAgencyId;
@property(copy, nonatomic)NSString *industry;

@property(assign, nonatomic)Boolean isSelected;
    


@end

NS_ASSUME_NONNULL_END
