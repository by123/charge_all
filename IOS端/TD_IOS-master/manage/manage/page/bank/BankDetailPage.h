//
//  BankDetailPage.h
//  by
//
//  Created by by.huang on block.
//  Copyright © 2018 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BankModel.h"
@interface BankDetailPage : BaseViewController

+(void)show:(BaseViewController *)controller model:(BankModel *)bankModel;

@end

