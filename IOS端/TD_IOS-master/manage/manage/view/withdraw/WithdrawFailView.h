//
//  WithdrawFailView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawFailViewModel.h"


@interface WithdrawFailView : UIView

-(instancetype)initWithViewModel:(WithdrawFailViewModel *)viewModel;
-(void)updateView;

@end

