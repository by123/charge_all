//
//  OrderDetailPage.h
//  by
//
//  Created by by.huang on block.
//  Copyright © 2018 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface OrderDetailPage : BaseViewController

+(void)show:(BaseViewController *)controller orderId:(NSString *)orderId;

@end

