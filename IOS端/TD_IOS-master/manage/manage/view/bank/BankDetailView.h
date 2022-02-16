//
//  BankDetailView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankDetailViewModel.h"


@interface BankDetailView : UIView

-(instancetype)initWithViewModel:(BankDetailViewModel *)viewModel;
-(void)updateView;

@end

