//
//  DeviceModel.h
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceModel : NSObject

//激活数量
@property(assign, nonatomic)int count;
//激活时间
@property(copy, nonatomic)NSString *activeDate;
//商户名称
@property(copy, nonatomic)NSString *mchName;

@end

NS_ASSUME_NONNULL_END
