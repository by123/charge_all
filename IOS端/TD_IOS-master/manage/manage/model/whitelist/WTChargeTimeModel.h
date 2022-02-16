//
//  WTChargeTimeModel.h
//  manage
//
//  Created by by.huang on 2019/6/19.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTChargeTimeModel : NSObject

@property(copy, nonatomic)NSString *time;
@property(assign, nonatomic)double price;
@property(assign, nonatomic)int scale;
@property(assign, nonatomic)Boolean isSelect;

@end

NS_ASSUME_NONNULL_END
