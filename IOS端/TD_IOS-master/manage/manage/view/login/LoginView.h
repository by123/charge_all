//
//  LoginView.h
//  manage
//
//  Created by by.huang on 2018/10/25.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginView : UIView

-(instancetype)initWithViewModel:(LoginViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
