//
//  STNumUtil.h
//  manage
//
//  Created by by.huang on 2018/11/8.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STNumUtil : NSObject

//整型，超过10000，显示w
+(NSString *)formatNum:(int)number;

//浮点型保留两位小数，超过1000，显示k,超过10000，显示w
+(NSString *)formatNumWith2P:(double)number;

    
//整型，小于10000，直接显示。大于10000显示w和两位小时
+(NSString *)formatNumWithInt2P:(int)number;
    
@end

NS_ASSUME_NONNULL_END
