//
//  PerformanceArchiveView.h
//  manage
//
//  Created by by.huang on 2019/7/1.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceArchiveView : UIView

-(instancetype)initWithViewModel:(PerformanceViewModel *)viewModel;
-(void)updateNoData:(Boolean)noData;
-(void)updateView;

@end

NS_ASSUME_NONNULL_END
