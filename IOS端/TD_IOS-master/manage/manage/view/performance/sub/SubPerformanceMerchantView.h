//
//  SubPerformanceMerchantView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubPerformanceMerchantViewModel.h"


@interface SubPerformanceMerchantView : UIView

-(instancetype)initWithViewModel:(SubPerformanceMerchantViewModel *)viewModel;
-(void)updateView;
-(void)updateNoData:(Boolean)noData;
-(void)updateTotalView;

@end

