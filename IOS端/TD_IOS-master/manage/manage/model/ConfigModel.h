//
//  ConfigModel.h
//  manage
//
//  Created by by.huang on 2019/4/29.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel : NSObject

@property(copy, nonatomic)NSString *key;
@property(strong, nonatomic)id value;

@end

NS_ASSUME_NONNULL_END
