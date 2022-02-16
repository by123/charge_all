//
//  STCityPickerLayerView.h
//  manage
//
//  Created by by.huang on 2018/12/3.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySelectModel.h"

@protocol STCityPickerLayerViewDelegate

-(void)onSelectResult:(UIView *)layerView province:(NSString *)provinceStr city:(NSString *)cityStr code:(NSString *)code;

@end


@interface STCityPickerLayerView : UIView

@property(weak, nonatomic)id<STCityPickerLayerViewDelegate> delegate;

-(void)setData:(NSString *)province city:(NSString *)city;

-(CitySelectModel *)getCurrentModel;

@end
