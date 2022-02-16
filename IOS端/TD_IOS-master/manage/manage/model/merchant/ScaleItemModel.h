//
//  ScaleItemModel.h
//  manage
//
//  Created by by.huang on 2018/11/5.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScaleItemModel : NSObject

@property(copy, nonatomic)NSString *time;
@property(assign, nonatomic)int scale;
@property(assign, nonatomic)int price;



@end

@interface ServiceItemModel : NSObject

//预付费
@property(assign, nonatomic)int prepaid;
//前minMinutes小时,minMoney元
@property(assign, nonatomic)int minMinutes;
@property(assign, nonatomic)int minMoney;
//超过后，每stepMinutes小时price元
@property(assign, nonatomic)int stepMinutes;
@property(assign, nonatomic)int price;
//封顶
@property(assign, nonatomic)int maxMoney;


@end

NS_ASSUME_NONNULL_END
