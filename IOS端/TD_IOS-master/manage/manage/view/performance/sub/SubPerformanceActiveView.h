//
//  SubPerformanceActiveView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubPerformanceActiveViewModel.h"


@interface SubPerformanceActiveView : UIView

-(instancetype)initWithViewModel:(SubPerformanceActiveViewModel *)viewModel;
-(void)updateView;
-(void)updateTotalView;
-(void)updateNoData:(Boolean)noData;

@end

