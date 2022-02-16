//
//  OrderDetailView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailViewModel.h"


@interface OrderDetailView : UIView

-(instancetype)initWithViewModel:(OrderDetailViewModel *)viewModel;
-(void)updateView;

@end

