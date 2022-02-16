//
//  STTitleButton.h
//  manage
//
//  Created by by.huang on 2018/10/26.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface STTitleButton : UIButton

-(instancetype)initWithTitle:(NSString *)title content:(NSString *)content width:(CGFloat)width height:(CGFloat)height;


-(void)setMainTitle:(NSString *)title;
@end

