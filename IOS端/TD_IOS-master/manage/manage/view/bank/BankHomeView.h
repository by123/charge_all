//
//  BankHomeView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankHomeViewModel.h"


@interface BankHomeView : UIView

-(instancetype)initWithViewModel:(BankHomeViewModel *)viewModel;
-(void)updateView;

@end

