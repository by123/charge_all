//
//  AppDelegate.h
//  bus
//
//  Created by by.huang on 2018/9/13.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AppDelegate *app;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
-(void)doWeChatLogin:(UIViewController *)controller;


@end

