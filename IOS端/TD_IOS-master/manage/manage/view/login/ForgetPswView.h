//
//  ForgetPswView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgetPswViewModel.h"


@interface ForgetPswView : UIView

-(instancetype)initWithViewModel:(ForgetPswViewModel *)viewModel;
-(void)updateView;
-(void)updateStep1;
-(void)updateStep2;
-(void)updateStep3;


@end

