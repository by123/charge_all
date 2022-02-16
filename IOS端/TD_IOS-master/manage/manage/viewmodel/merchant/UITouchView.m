//
//  UITouchView.m
//  manage
//
//  Created by by.huang on 2021/6/17.
//  Copyright © 2021 by.huang. All rights reserved.
//

#import "UITouchView.h"

@implementation UITouchView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesBegan:touches withEvent:event];
}
@end
