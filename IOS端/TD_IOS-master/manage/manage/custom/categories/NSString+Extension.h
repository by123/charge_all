//
//  NSString+Extension.h
//  MYSlideViewController
//
//  Created by michael on 2017/6/27.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(CGFloat)font;
- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(CGFloat)font fontName:(NSString *)fontName;
@end
