//
//  STYearMonthLayerView.h
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol STYearMonthLayerViewDelegate

-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView yearposition:(int)yearposition monthposition:(int)monthposition;

@end


@interface STYearMonthLayerView : UIView

@property(weak, nonatomic)id<STYearMonthLayerViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;
-(void)setData:(NSString *)year month:(NSString *)month;

@end
