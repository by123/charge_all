//
//  STEdgeLabel.m
//  framework
//
//  Created by 黄成实 on 2018/5/17.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import "STEdgeLabel.h"


@interface STEdgeLabel ()
@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@end

@implementation STEdgeLabel

- (instancetype)initWithFont:(CGFloat)fontSize text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor multiLine:(Boolean)multiLine
{
    if(self == [super initWithFont:fontSize text:text textAlignment:textAlignment textColor:textColor backgroundColor:backgroundColor multiLine:multiLine])
    {
        self.edgeInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
    }
    return self;
}


// 修改绘制文字的区域，edgeInsets增加bounds
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    
    /*
     调用父类该方法
     注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
     */
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,
                                                                 self.edgeInsets) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.edgeInsets.left;
    rect.origin.y -= self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

//绘制文字
- (void)drawTextInRect:(CGRect)rect
{
    //令绘制区域为原始区域，增加的内边距区域不绘制
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end

