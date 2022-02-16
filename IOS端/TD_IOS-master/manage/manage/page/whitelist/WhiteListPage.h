//
//  NamePage.h
//  by
//
//  Created by by.huang on block.
//  Copyright © 2018 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface WhiteListPage : BaseViewController

@property(strong, nonatomic)NSMutableArray *selectDatas;
//是否从复制页面返回
@property(assign, nonatomic)Boolean fromCopy;
@property(copy, nonatomic)NSString *orderWhiteListId;
@property(copy, nonatomic)NSString *userName;

+(void)show:(BaseViewController *)controller;

@end

