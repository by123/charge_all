//
//  SubPerformanceMerchantPage.h
//  by
//
//  Created by by.huang on block.
//  Copyright © 2018 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SubPerformanceMerchantPage : BaseViewController

+(void)show:(BaseViewController *)controller mchId:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay;

@end

