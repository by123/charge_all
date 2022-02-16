//
//  HelpView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpViewModel.h"


@interface HelpView : UIView

-(instancetype)initWithViewModel:(HelpViewModel *)viewModel;
-(void)updateView;

@end

