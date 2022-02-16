//
//  ResetView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResetViewModel.h"


@interface ResetView : UIView


-(instancetype)initWithViewModel:(ResetViewModel *)viewModel;
-(void)updateView:(NSString *)psw;

@end

