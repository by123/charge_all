//
//  MerchantEditView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantEditViewModel.h"
#import "LocationModel.h"


@interface MerchantEditView : UIView

-(instancetype)initWithViewModel:(MerchantEditViewModel *)viewModel;
//-(void)updateLocation:(AMapPOI *)poi;

@end

