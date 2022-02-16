//
//  STFileUtil.m
//  framework
//
//  Created by 黄成实 on 2018/4/26.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import "STFileUtil.h"
#import <Photos/Photos.h>

@implementation STFileUtil

+(NSString *)saveImageFile:(NSString *)filePath image:(UIImage *)image{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:filePath];
    BOOL statu = [UIImageJPEGRepresentation(image, 100) writeToFile:imageFilePath  atomically:YES];
    if(statu){
        [STLog print:MSG_PIC_SAVE_SUCCESS];
        return imageFilePath;
    }else{
        [STLog print:MSG_PIC_SAVE_FAIL];
    }
    return nil;
}


+(NSString *)loadFile:(NSString *)filePath{
    if(!IS_NS_STRING_EMPTY(filePath) && [filePath containsString:@"."]){
        NSArray<NSString *> *array = [filePath componentsSeparatedByString:@"."];
        NSString *path = [[NSBundle mainBundle] pathForResource:array[0] ofType:array[1]];
        return [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    return MSG_EMPTY;
}


+(void)doSaveScreenShot{
    UIImage *image = [self dataWithScreenshotInPNGFormat];
    if(image == nil){
        return;
    }
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            [STLog print:MSG_PIC_SAVE_FAIL];
        } else {
            dispatch_main_async_safe(^{
                [LCProgressHUD showMessage:MSG_PHOTO_LIBRARY];
            });
        }
    }];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
+(UIImage *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    return UIImagePNGRepresentation(image);
    return image;

}

@end
