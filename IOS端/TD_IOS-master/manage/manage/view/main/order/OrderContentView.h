//
//  OrderContentView.h
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderViewModel.h"
#import "OrderContentViewModel.h"
#import "MerchantModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderContentView : UIView

-(instancetype)initWithType:(OrderType)type viewModel:(nonnull OrderViewModel *)orderViewModel;
-(void)updateView;
-(void)uploadMore;
-(void)refreshNew;
-(void)updateCondition:(NSString *)startDate end:(NSString *)endDate model:(MerchantModel *)model;

@end

NS_ASSUME_NONNULL_END
