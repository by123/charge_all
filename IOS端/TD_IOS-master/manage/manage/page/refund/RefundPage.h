//
//  RefundPage.h
//  by
//
//  Created by by.huang on block.
//  Copyright © 2018 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OrderModel.h"
@interface RefundPage : BaseViewController

+(void)show:(BaseViewController *)controller orderModel:(OrderModel *)orderModel;

@end

