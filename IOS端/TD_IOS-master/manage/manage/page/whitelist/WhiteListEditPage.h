//
//  WhiteListEditPage.h
//  by
//
//  Created by by.huang on block.
//  Copyright © 2018 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WTRecordModel.h"

@interface WhiteListEditPage : BaseViewController

+(void)show:(BaseViewController *)controller model:(WTRecordModel *)model;
@property(strong, nonatomic)NSMutableArray *selectDatas;

@end

