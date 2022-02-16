//
//  OrderView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewModel.h"


@interface OrderView : UIView

-(instancetype)initWithViewModel:(MainViewModel *)mainViewModel;
-(void)updateView;
-(void)updateDate:(NSInteger)startDate end:(NSInteger)endDate;

@end

