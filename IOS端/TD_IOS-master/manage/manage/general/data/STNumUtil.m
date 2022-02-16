//
//  STNumUtil.m
//  manage
//
//  Created by by.huang on 2018/11/8.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "STNumUtil.h"

@implementation STNumUtil


+(NSString *)formatNumWith2P:(double)number{
    if(number >= 10000){
        return [NSString stringWithFormat:@"%.2f万",(number/10000)];
    }
    return [NSString stringWithFormat:@"%.2f",number];;
}


+(NSString *)formatNum:(int)number{
    if(number >= 10000){
        return [NSString stringWithFormat:@"%d万",(number/10000)];
    }
    return [NSString stringWithFormat:@"%d",number];;
}
    
+(NSString *)formatNumWithInt2P:(int)number{
    if(number >= 10000){
        return [NSString stringWithFormat:@"%.2f万",((double)number/10000)];
    }
    return [NSString stringWithFormat:@"%d",number];;
}

@end
