//
//  BindMerchatPage.h
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BindMerchantPage : BaseViewController

+(void)show:(UIViewController *)controller openid:(NSString *)openid unionid:(NSString *)unionid type:(NSString *)type from:(MerchantFromType)from;


@end

NS_ASSUME_NONNULL_END
