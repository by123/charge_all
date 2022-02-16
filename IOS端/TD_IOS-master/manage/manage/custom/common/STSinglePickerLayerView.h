//
//  STSinglePickerLayerView.h
//  framework
//
//  Created by 黄成实 on 2018/5/28.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol STSinglePickerLayerViewDelegate

-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView position:(NSInteger)position;

@end


@interface STSinglePickerLayerView : UIView

@property(weak, nonatomic)id<STSinglePickerLayerViewDelegate> delegate;

-(instancetype)initWithDatas:(NSMutableArray *)datas;
-(void)setData:(NSString *)data;
-(void)updateDatas:(NSMutableArray *)datas;
-(NSMutableArray *)getDatas;
-(void)setSelect:(NSInteger)p;

@end
