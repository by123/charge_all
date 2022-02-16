//
//  CapitalDetailView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapitalDetailViewModel.h"


@interface CapitalDetailView : UIView

-(instancetype)initWithViewModel:(CapitalDetailViewModel *)viewModel;
-(void)updateContentView:(NSArray *)contents noData:(Boolean)noData;
-(void)updateProfitView;
-(void)updateDeviceView;
-(void)updateNoData:(int)type;
-(void)updateFail;
-(void)updateSettementPeriod:(int)settement;

@end

