//
//  MainModel.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainModel : NSObject


@property(assign, nonatomic)int allDeviceCount;
@property(assign, nonatomic)int todayMchCount;
@property(assign, nonatomic)int todayDeviceCount;
@property(assign, nonatomic)int allMchCount;
@property(assign, nonatomic)double allAmount;
@property(assign, nonatomic)double todayAmount;


@end

NS_ASSUME_NONNULL_END
