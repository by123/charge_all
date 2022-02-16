//
//  WhiteListScopePage.h
//  by
//
//  Created by by.huang on block.
//  Copyright © 2018 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WhiteListPage.h"

@interface WhiteListScopePage : BaseViewController

+(void)show:(BaseViewController *)controller;
+(void)show:(BaseViewController *)controller whiteListId:(NSString *)whiteListId;

@end

