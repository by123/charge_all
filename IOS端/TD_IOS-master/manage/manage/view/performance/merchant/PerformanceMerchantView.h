//
//  PerformanceMerchantView.h
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceMerchantView : UIView

-(instancetype)initWithViewModel:(PerformanceViewModel *)viewModel;
-(void)hiddenKeyboard;
-(void)updateNoData:(Boolean)noData;
-(void)updateView;
-(void)updateTotalView;

@end

NS_ASSUME_NONNULL_END
