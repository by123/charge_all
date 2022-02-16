//
//  PerformanceMerchantModel.h
//  manage
//
//  Created by by.huang on 2019/6/19.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceMerchantModel : NSObject

//直属字段
@property(copy, nonatomic)NSString *mchId;
@property(copy, nonatomic)NSString *mchName;
@property(assign, nonatomic)int mchType;
@property(assign, nonatomic)int level;
@property(copy, nonatomic)NSString *contactUser;
@property(assign, nonatomic)long createTime;
@property(copy, nonatomic)NSString *salesName;
//下级字段
@property(assign, nonatomic)int agentCount;
@property(assign, nonatomic)int tenantCount;
@property(assign, nonatomic)int deviceCount;



@end

NS_ASSUME_NONNULL_END
