//
//  WhiteListChargeTimeView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteListChargeTimeViewModel.h"


@interface WhiteListChargeTimeView : UIView

-(instancetype)initWithViewModel:(WhiteListChargeTimeViewModel *)viewModel;
-(void)updateView;

@end

