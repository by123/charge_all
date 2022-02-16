//
//  WeChatUtil.h
//  manage
//
//  Created by by.huang on 2019/4/28.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeChatUtil : NSObject

+(void)getWeChatCode:(UIViewController *)controller delegate:(id)delegate;


@end

NS_ASSUME_NONNULL_END
