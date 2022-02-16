//
//  AchieveView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AchieveViewModel.h"


@interface AchieveView : UIView

-(instancetype)initWithViewModel:(AchieveViewModel *)viewModel;
-(void)updateView;

@end

