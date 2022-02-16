//
//  WhiteListScopeView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteListScopeViewModel.h"


@interface WhiteListScopeView : UIView

-(instancetype)initWithViewModel:(WhiteListScopeViewModel *)viewModel;
-(void)updateView:(int)position;

@end

