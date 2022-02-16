//
//  ThreePartyMacro.h
//  framework
//
//  Created by 黄成实 on 2018/4/17.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

#pragma mark 定义三方库appid,appkey....

#define BUGLY_APPID @"b61a54a0e6"


//小程序分享
#ifdef DEBUG

#define WX_APPKEY @"wx74c1232f5fc4c536"
#define MINIAPP_ID @"gh_a61505d30870"

#else

#define WX_APPKEY @"wxba676206ee56928d"
#define MINIAPP_ID @"gh_2efaf25b7678"

#endif

//小程序版本
#define MINIAPP_ENV WXMiniProgramTypeRelease
//#define MINIAPP_ENV WXMiniProgramTypeTest
//#define MINIAPP_ENV WXMiniProgramTypePreview

#define UMENG_KEY @"60a61484c9aacd3bd4df1c72"
#define MAP_KEY @"b108b162079b57777b19ddb045a1bf66"
