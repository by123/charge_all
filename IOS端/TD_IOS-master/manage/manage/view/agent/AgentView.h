//
//  AgentView.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentViewModel.h"
#import "LocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AgentView : UIView

-(instancetype)initWithViewModel:(AgentViewModel *)viewModel;
//-(void)updateLocation:(AMapPOI *)poi;
@end

NS_ASSUME_NONNULL_END
