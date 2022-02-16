//
//  UIPickerView+SelectView.h
//  manage
//
//  Created by by.huang on 2018/10/31.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPickerView(SelectView)

-(instancetype)initWithDatas:(NSMutableArray *)datas;

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

NS_ASSUME_NONNULL_END
