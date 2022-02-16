//
//  OrderSearchViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "MerchantModel.h"

@protocol OrderSearchViewDelegate<BaseRequestDelegate>

-(void)onRequestNoData;
-(void)onClosePage;
-(void)onGoOrderDetailPage:(NSString *)orderId;
-(void)onGoRefundPage:(OrderModel *)orderModel;
-(void)onRequestNoData:(Boolean)hasDatas;

@end


@interface OrderSearchViewModel : NSObject


@property(weak, nonatomic)id<OrderSearchViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray<OrderModel *> *datas;
@property(strong, nonatomic)NSMutableArray<MerchantModel *> *merchantDatas;

-(void)requestOrderList:(Boolean)refreshNew orderId:(NSString *)orderId mchName:(NSString *)mchName deviceSn:(NSString *)deviceSn;
-(void)closePage;
-(void)goOrderDetailPage:(NSString *)orderId;
-(void)goRefundPage:(OrderModel *)orderModel;
-(void)searchDevice:(NSString *)key refreshNew:(Boolean)refreshNew;
@end


