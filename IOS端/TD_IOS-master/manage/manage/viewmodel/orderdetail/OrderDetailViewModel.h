//
//  OrderDetailViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailModel.h"
#import "OrderModel.h"

@protocol OrderDetailViewDelegate<BaseRequestDelegate>

-(void)onGoRefundPage:(OrderModel *)model;

@end


@interface OrderDetailViewModel : NSObject

@property(weak, nonatomic)id<OrderDetailViewDelegate> delegate;
@property(copy, nonatomic)NSString *orderId;
@property(strong, nonatomic)OrderDetailModel *model;

-(void)requestOrderDetail;
-(void)goRefundPage:(OrderDetailModel *)model;
@end


