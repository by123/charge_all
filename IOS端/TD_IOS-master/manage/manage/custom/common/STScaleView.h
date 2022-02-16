//
//  STScaleView.h
//  manage
//
//  Created by by.huang on 2018/11/3.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface STScaleView : UIButton

-(instancetype)initWithPosition:(NSInteger)position;
-(void)setData:(TitleContentModel *)model;

@end

NS_ASSUME_NONNULL_END
