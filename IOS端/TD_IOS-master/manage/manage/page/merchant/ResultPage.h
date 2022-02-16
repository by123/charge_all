//
//  MerchatResultPage.h
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


//0 商户 1代理商 2业务员
@interface ResultPage : BaseViewController

+(void)show:(BaseViewController *)controller username:(NSString *)userName psw:(NSString *)password type:(int)type;

@end

NS_ASSUME_NONNULL_END
