//
//  PayRuleModel.h
//  manage
//
//  Created by by.huang on 2018/12/12.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayRuleModel : NSObject

@property(assign, nonatomic)long price;
@property(assign, nonatomic)long time;
@property(assign, nonatomic)int scale;

@end

NS_ASSUME_NONNULL_END
