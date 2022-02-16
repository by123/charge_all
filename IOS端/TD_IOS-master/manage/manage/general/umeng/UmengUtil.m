//
//  UmengUtil.m
//  manage
//
//  Created by by.huang on 2019/6/13.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "UmengUtil.h"

@implementation Manage
SINGLETON_IMPLEMENTION(AccountManager)

+(void)init:(NSDictionary *)launchOptions{
    [UMConfigure setLogEnabled:DEBUG];//设置打开日志
    [UMConfigure initWithAppkey:UMENG_KEY channel:@"App Store"];
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    }
    
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
}
@end
