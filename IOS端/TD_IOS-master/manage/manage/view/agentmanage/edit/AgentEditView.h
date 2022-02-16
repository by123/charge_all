//
//  AgentEditView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentEditViewModel.h"
#import "LocationModel.h"

@interface AgentEditView : UIView

-(instancetype)initWithViewModel:(AgentEditViewModel *)viewModel;
-(void)updateView;
//-(void)updateLocation:(AMapPOI *)poi;

@end

