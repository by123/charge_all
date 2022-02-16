//
//  OrderContentViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "MerchantModel.h"


@protocol OrderContentViewDelegate<BaseRequestDelegate>

-(void)onRequestNoData:(int)type;
-(void)onRequestTotalCount:(NSString *)count sum:(NSString *)sum;

@end


@interface OrderContentViewModel : NSObject

@property(weak, nonatomic)id<OrderContentViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray<OrderModel *> *datas;
@property(copy, nonatomic)NSString *startDate;
@property(copy, nonatomic)NSString *endDate;
@property(strong, nonatomic)MerchantModel *model;

-(void)requestOrderList:(OrderType)type refreshNew:(Boolean)refreshNew;


@end


