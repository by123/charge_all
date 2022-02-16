//
//  UmengManage.h
//  manage
//
//  Created by by.huang on 2019/6/13.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <UMCommon/UMCommon.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface UmengManage : NSObject<UNUserNotificationCenterDelegate>
SINGLETON_DECLARATION(UmengManage)

-(void)init:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
