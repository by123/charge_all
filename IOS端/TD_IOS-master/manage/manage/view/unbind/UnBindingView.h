//
//  UnBindingView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnBindingViewModel.h"


@interface UnBindingView : UIView

-(instancetype)initWithViewModel:(UnBindingViewModel *)viewModel;
-(void)updateView;

@end

