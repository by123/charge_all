//
//  ResetSuccessView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResetSuccessViewModel.h"


@interface ResetSuccessView : UIView

-(instancetype)initWithViewModel:(ResetSuccessViewModel *)viewModel;
-(void)updateView;

@end

