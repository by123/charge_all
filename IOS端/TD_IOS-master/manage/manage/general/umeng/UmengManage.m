//
//  UmengManage.m
//  manage
//
//  Created by by.huang on 2019/6/13.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "UmengManage.h"
#import "MsgDetailPage.h"
#import "STObserverManager.h"
#import "STNetUtil.h"
#import "AccountManager.h"
#import "STUserDefaults.h"


@implementation UmengManage
SINGLETON_IMPLEMENTION(UmengManage)

-(void)init:(NSDictionary *)launchOptions{
//    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMConfigure initWithAppkey:UMENG_KEY channel:@"App Store"];
//    [UMessage setBadgeClear:YES];
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"友盟初始化成功");
        }else{
        }
    }];
}


//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSString *msgId =  [userInfo objectForKey:@"msg_id"];
        //前台有新消息
        [STUserDefaults saveKeyValue:UD_NEW_MSG value:@"1"];
        [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_NEW_MSG msg:msgId];
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSString *msgId =  [userInfo objectForKey:@"msg_id"];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
        if([[AccountManager sharedAccountManager]isLogin] && model.createTime != 0){
            MsgDetailPage *page = [[MsgDetailPage alloc]init];
            page.msgId = msgId;
            [[STNetUtil getCurrentVC].navigationController pushViewController:page animated:YES];
            [STUserDefaults saveKeyValue:UD_NEW_MSG value:@"0"];
        }

    }else{
        //应用处于后台时的本地推送接受
    }
}



@end
