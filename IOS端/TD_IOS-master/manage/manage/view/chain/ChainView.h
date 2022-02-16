//
//  ChainView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChainViewModel.h"
#import "LocationModel.h"

@interface ChainView : UIView
    
-(instancetype)initWithViewModel:(ChainViewModel *)viewModel;
//-(void)updateLocation:(AMapPOI *)poi;

@end

