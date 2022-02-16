//
//  PerformanceViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PerformanceViewDelegate<BaseRequestDelegate>

-(void)onGoSubPerformanceActivePage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay;
-(void)onGoSubPerformanceMerchantPage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay;
-(void)onRequestNoData:(Boolean)noData requestUrl:(NSString *)requestUrl;
-(void)onGoDetailPage:(NSString *)mchId mchType:(int)mchType;

@end


@interface PerformanceViewModel : NSObject

@property(weak, nonatomic)id<PerformanceViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *merchantDatas;
@property(strong, nonatomic)NSMutableArray *activeDatas;
@property(strong, nonatomic)NSMutableArray *archiveDatas;
@property(strong, nonatomic)UIViewController *controller;
@property(copy, nonatomic)NSString *mchId;
@property(copy, nonatomic)NSString *startDay;
@property(copy, nonatomic)NSString *endDay;
@property(copy, nonatomic)NSString *qryInfo;
@property(assign, nonatomic)int count;

@property(assign, nonatomic)Boolean isChild;
@property(assign, nonatomic)int directAgent;
@property(assign, nonatomic)int directTenant;
@property(assign, nonatomic)int subordinateAgent;
@property(assign, nonatomic)int subordinateTenant;

@property(assign, nonatomic)int orderCount;
@property(assign, nonatomic)double amountCount;



-(void)requestActive:(Boolean)refreshNew;
-(void)reqeustMerchant:(Boolean)refreshNew;
-(void)requestArchiveList:(Boolean)refreshNew;
-(void)requestActiveTotal;
-(void)requestMerchantTotal;
-(void)goSubPerformanceActivePage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay;
-(void)goSubPerformanceMerchantPage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay;
-(void)goDetailPage:(NSString *)mchId mchType:(int)mchType;


@end


