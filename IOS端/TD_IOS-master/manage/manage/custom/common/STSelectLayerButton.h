//
//  STSelectLayerButton.h
//  framework
//
//  Created by 黄成实 on 2018/6/6.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSelectLayerButton : UIButton

-(instancetype)initWithFrame:(CGRect)frame;
-(void)setSelectText:(NSString *)text;
-(void)setHolderText:(NSString *)text;
-(NSString *)getSelectText;
@end
