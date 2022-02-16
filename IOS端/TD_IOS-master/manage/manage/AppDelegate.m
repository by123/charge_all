//
//  AppDelegate.m
//  bus
//
//  Created by by.huang on 2018/9/13.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainPage.h"
#import "STObserverManager.h"
#import "STUpdateUtil.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "STNetUtil.h"
#import "LoginPage.h"
#import "AccountManager.h"
#import "ScanPage.h"
#import "STAlertUtil.h"
#import "STNetUtil.h"
#import <Bugly/Bugly.h>
#import "STUserDefaults.h"
#import "UpdateView.h"
#import <Photos/Photos.h>
#import "WXApi.h"
#import "WeChatUtil.h"
#import "ConfigModel.h"
#import "UmengManage.h"
#import "MapManage.h"
#import "MsgPage.h"

#import "Test.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//   NSDictionary* remoteNotification =  [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    _app = self;
    //皮肤选择
    [[SkinManage sharedSkinManage] useSkin:SkinType_Yellow];
    //获取配置
    [self getSetting];
    //页面初始化
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    id controller;
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
//    if(remoteNotification == nil){
    if([[AccountManager sharedAccountManager]isLogin] && model.createTime != 0){
        controller = [[MainPage alloc]init];
    }else{
        controller = [[LoginPage alloc]init];
    }
//    }else{
//        //通过推送进入
//        if([[AccountManager sharedAccountManager]isLogin] && model.createTime != 0){
//            controller = [[MsgPage alloc]init];
//        }else{
//            controller = [[LoginPage alloc]init];
//        }
//    }
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    //观察者初始化
    [[STObserverManager sharedSTObserverManager]setup];
    //网络初始化
    [self initNet];
    //初始化推送
    [[UmengManage sharedUmengManage] init:launchOptions];
    //获取配置
    [self getConfig];
    //检测更新
    [self checkUpdate];
    //BUG收集
    [Bugly startWithAppId:BUGLY_APPID];
    if(IS_YELLOW_SKIN){
        //微信初始化
        [WXApi registerApp:WX_APPKEY universalLink:@"https://com.jifung.td/"];
    }
//    [[MapManage sharedMapManage] initMap];
    
//    [[Test alloc]init];s
    
    
    return YES;
}


-(void)doWeChatLogin:(UIViewController *)controller{
    [WeChatUtil getWeChatCode:controller delegate:self];
}

-(void)initNet{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [STNetUtil startListenNetWork];
}



/**************获取deviceToken**************/

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    [STLog print:@"获取失败"];
}

/**************获取deviceToken**************/

-(void)getConfig{
    [STNetUtil getConfig:CONFIG_ALL success:^(NSString *result) {
        NSMutableArray *datas= [ConfigModel mj_objectArrayWithKeyValuesArray:result];
        if(!IS_NS_COLLECTION_EMPTY(datas)){
            for(ConfigModel *model in datas){
              [STUserDefaults saveKeyValue:model.key value:model.value];
            }
        }
    }];
    
    [STNetUtil getConfig:CONFIG_INDUSTY success:^(NSString *result) {
        [STUserDefaults saveKeyValue:UD_INDUSTY value:result];
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer  API_AVAILABLE(ios(10.0)){
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            if (@available(iOS 10.0, *)) {
                _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"bus"];
            } else {
                // Fallback on earlier versions
            }
            if (@available(iOS 10.0, *)) {
                [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                    if (error != nil) {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        
                        /*
                         Typical reasons for an error here include:
                         * The parent directory does not exist, cannot be created, or disallows writing.
                         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                         * The device is out of space.
                         * The store could not be migrated to the current model version.
                         Check the error message to determine what the actual problem was.
                         */
                        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                        abort();
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


-(void)checkUpdate{
    double currentVersion =  [STPUtil getAppVersion];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"softwareType"] = @(1);
    dic[@"currentVersionNum"] = @(currentVersion);
    [STNetUtil get:URL_CHECKUPDATE parameters:dic success:^(RespondModel *repondModel) {
        NSMutableArray *datas = repondModel.data;
        if(!IS_NS_COLLECTION_EMPTY(datas)){
            id newData = [datas objectAtIndex:(datas.count - 1)];
            UpdateModel *model = [UpdateModel mj_objectWithKeyValues:newData];
            if(model.versionNum > currentVersion){
                UpdateView *view = [[UpdateView alloc]initWithModel:model];
                [[UIApplication sharedApplication].keyWindow addSubview:view];
            }
        }else{
            NSLog(@"已是最新版本");
        }
    } failure:^(int errorCode) {
        
    }];
}


-(void)getSetting{
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    if([[STConvertUtil base64Decode:MSG_TEST_ID] isEqualToString:model.mchId] || [[STConvertUtil base64Decode:MSG_TEST_ID] isEqualToString:model.userId]){
        [STUserDefaults saveKeyValue:UD_SETTING value:LIMIT_CLOSE];
    }else{
        [STUserDefaults saveKeyValue:UD_SETTING value:LIMIT_OPEN];
    }
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return  [WXApi handleOpenURL:url delegate:self];
}
    
-(void)onReq:(BaseReq *)req{
    
}

-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp;
//        /* Prevent Cross Site Request Forgery */
//        if (![authResp.state isEqualToString:self.authState]) {
//           //拒绝
//            return;
//        }
//
        switch (resp.errCode) {
            case WXSuccess:
                [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_WECHAT_CODE msg:authResp.code];
                //成功
                [STLog print:@"授权成功"];
                break;
            case WXErrCodeAuthDeny:
                //拒绝
                [STLog print:@"授权拒绝"];
                break;
            case WXErrCodeUserCancel:
                 //取消
                [STLog print:@"授权取消"];
            default:
                break;
        }
    }
}



@end
