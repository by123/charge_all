//
//  SubPerformanceActiveViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubPerformanceActiveViewDelegate<BaseRequestDelegate>

-(void)onGoSubPerformanceActivePage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay;
-(void)onRequestNoData:(Boolean)noData requestUrl:(NSString *)requestUrl;
-(void)onGoDetailPage:(NSString *)mchId mchType:(int)mchType;

@end


@interface SubPerformanceActiveViewModel : NSObject

@property(weak, nonatomic)id<SubPerformanceActiveViewDelegate> delegate;
@property(strong, nonatomic)UIViewController *controller;
@property(strong, nonatomic)NSMutableArray *activeDatas;
@property(copy, nonatomic)NSString *mchId;
@property(copy, nonatomic)NSString *mchName;
@property(copy, nonatomic)NSString *startDay;
@property(copy, nonatomic)NSString *endDay;
@property(copy, nonatomic)NSString *qryInfo;
@property(assign, nonatomic)int count;

-(void)requestActive:(Boolean)refreshNew;
-(void)requestActiveTotal;
-(void)goSubPerformanceActivePage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay;
-(void)goDetailPage:(NSString *)mchId mchType:(int)mchType;

@end


