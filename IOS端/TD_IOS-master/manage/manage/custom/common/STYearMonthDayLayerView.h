//
//  STYearMonthDayLayerView.h
//  manage
//
//  Created by by.huang on 2019/1/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol STYearMonthDayLayerViewDelegate

-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView yearposition:(int)yearposition monthposition:(int)monthposition daypostion:(int)dayposition;

@end


@interface STYearMonthDayLayerView : UIView

@property(weak, nonatomic)id<STYearMonthDayLayerViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;
-(void)setData:(NSString *)year month:(NSString *)month day:(NSString *)day;


@end

