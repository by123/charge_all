//
//  WeChatUtil.m
//  manage
//
//  Created by by.huang on 2019/4/28.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "WeChatUtil.h"
#import "WXApi.h"

@implementation WeChatUtil


+(void)getWeChatCode:(UIViewController *)controller delegate:(id)delegate{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"xhd";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:req viewController:controller delegate:delegate completion:^(BOOL success) {
//        NSLog(@"微信注册结果:%d",success);
    }];
}

@end
