//
//  RefundView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefundViewModel.h"


@interface RefundView : UIView

-(instancetype)initWithViewModel:(RefundViewModel *)viewModel;
-(void)updateView;

@end

