//
//  STAddressPickerLayerView.h
//  manage
//
//  Created by by.huang on 2019/4/3.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySelectModel.h"

@protocol STAddressPickerLayerViewDelegate

-(void)onSelectResult:(UIView *)layerView province:(NSString *)provinceStr city:(NSString *)cityStr area:(NSString *)area;

@end


@interface STAddressPickerLayerView : UIView

@property(weak, nonatomic)id<STAddressPickerLayerViewDelegate> delegate;

-(CitySelectModel *)getCurrentModel;

@end

