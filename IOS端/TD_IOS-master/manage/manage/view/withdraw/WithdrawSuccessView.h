//
//  WithdrawSuccessView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawSuccessViewModel.h"


@interface WithdrawSuccessView : UIView

-(instancetype)initWithViewModel:(WithdrawSuccessViewModel *)viewModel;
-(void)updateView;

@end

