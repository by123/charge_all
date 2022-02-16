//
//  STFileUtil.h
//  framework
//
//  Created by 黄成实 on 2018/4/26.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STFileUtil : NSObject

+(NSString *)saveImageFile:(NSString *)filePath image:(UIImage *)image;

#pragma mark 注意此接口文件名需要加后缀
+(NSString *)loadFile:(NSString *)filePath;

#pragma mark 截取屏幕并保存至相册
+(void)doSaveScreenShot;

@end
