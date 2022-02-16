//
//  OrderViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "MerchantModel.h"

@protocol OrderViewDelegate<BaseRequestDelegate>

-(void)onUpdateTotalStr:(NSString *)orderCount profit:(NSString *)profit;
-(void)onGoOrderDetailPage:(NSString *)orderId;
-(void)onGoRefundPage:(OrderModel *)model;

-(void)onRefreshEnd;
-(void)noMoreData;
-(void)onUpdateUI:(int)type datas:(NSMutableArray *)datas;

@end

@interface OrderViewModel : NSObject

@property(weak, nonatomic)id<OrderViewDelegate> delegate;
@property(copy, nonatomic)NSString *startDate;
@property(copy, nonatomic)NSString *endDate;
@property(copy, nonatomic)NSString *startDateStr;
@property(copy, nonatomic)NSString *endDateStr;
@property(strong, nonatomic)MerchantModel *model;
@property(strong, nonatomic)NSMutableArray *queryDatas;


-(void)goOrderDetailPage:(NSString *)orderId;
-(void)goRefundPage:(OrderModel *)model;
//反向代理更新
-(void)updateUI:(int)type datas:(NSMutableArray *)datas;
-(void)queryAgentAndMerchant;

@end


