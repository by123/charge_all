//
//  PerformanceView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceViewModel.h"

@interface PerformanceView : UIView

-(instancetype)initWithViewModel:(PerformanceViewModel *)viewModel merchant:(PerformanceViewModel *)viewModel2 archive:(PerformanceViewModel *)viewModel3;
-(void)updateView:(PerformanceType)type;
-(void)updateTotalView:(PerformanceType)type;
-(void)updateNoData:(PerformanceType)type noData:(Boolean)noData;
@end

