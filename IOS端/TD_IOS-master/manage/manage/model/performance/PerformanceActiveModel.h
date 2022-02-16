//
//  PerformanceActiveModel.h
//  manage
//
//  Created by by.huang on 2019/6/19.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceActiveModel : NSObject

@property(copy, nonatomic)NSString *mchId;
@property(copy, nonatomic)NSString *mchName;
@property(assign, nonatomic)int mchType;
@property(assign, nonatomic)int level;
@property(copy, nonatomic)NSString *salesId;
@property(copy, nonatomic)NSString *salesName;
@property(copy, nonatomic)NSString *contactUser;
@property(assign, nonatomic)int activeDeviceTotalNum;
@property(assign, nonatomic)int deviceTotalNum;
@property(assign, nonatomic)double activeRatio;
@property(assign, nonatomic)int activeNum;

@end

NS_ASSUME_NONNULL_END
