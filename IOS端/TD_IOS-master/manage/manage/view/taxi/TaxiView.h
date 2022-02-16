//
//  TaxiView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaxiViewModel.h"


@interface TaxiView : UIView

-(instancetype)initWithViewModel:(TaxiViewModel *)viewModel;
-(void)updateView;
-(void)onRequestNoData:(Boolean)empty;

@end

