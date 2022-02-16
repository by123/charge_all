//
//  LoginPage.h
//  manage
//
//  Created by by.huang on 2018/10/25.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginPage : BaseViewController


+(void)show:(BaseViewController *)controller;
+(void)back:(BaseViewController *)controller content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
