//
//  CitySelectModel.h
//  manage
//
//  Created by by.huang on 2018/12/3.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CitySelectModel : NSObject

@property(copy, nonatomic)NSString *city_name;

@property(copy, nonatomic)NSString *city_code;

@property(strong, nonatomic)NSMutableArray *children;

@property(copy, nonatomic)NSString *label;

@end

