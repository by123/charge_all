//
//  ScanPage.h
//  manage
//
//  Created by by.huang on 2018/10/13.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBXScanViewController.h"
#import "BaseViewController.h"


@interface ScanPage : LBXScanViewController

//type 0 激活设备 1 添加商户 2 设备密码重置
+(void)show:(BaseViewController *)controller type:(ScanType)type mchId:(NSString *)mchId mchName:(NSString *)mchName;

@end

