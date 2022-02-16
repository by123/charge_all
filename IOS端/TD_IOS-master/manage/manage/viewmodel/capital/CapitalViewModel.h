//
//  CapitalViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CapitalModel.h"
#import "ProfitModel.h"
#import "WithdrawDetailModel.h"
#import "MainViewModel.h"

@protocol CapitalViewDelegate<BaseRequestDelegate>

-(void)onUpdateUI:(int)type count:(NSInteger)count;
-(void)onRefreshEnd;
-(void)onRequestNoData:(int)type;

@end


@interface CapitalViewModel : NSObject

@property(weak, nonatomic)id<CapitalViewDelegate> delegate;
@property(strong, nonatomic)MainViewModel *mainViewModel;
@property(strong, nonatomic)CapitalModel *model;
@property(assign, nonatomic)int year;
@property(assign, nonatomic)int month;
@property(strong, nonatomic)NSMutableArray<WithdrawDetailModel *> *withdrawDatas;
@property(strong, nonatomic)NSMutableArray<ProfitModel *> *profitDatas;

//请求总数据
-(void)requestCapitalData;
//反向代理更新
-(void)updateUI:(int)type count:(NSInteger)count;
//请求收益明细列表
-(void)reqeustCapitalList:(Boolean)refreshNew;
//请求提现明细列表
-(void)reqeustWithdrawList:(Boolean)refreshNew;

//跳转提现失败页面
-(void)goWithdrawFailPage:(NSString *)withdrawId;
//跳转提现成功页面
-(void)goWithdrawSuccessPage:(NSString *)withdrawId;
//跳转收益详情页面
-(void)goCapitalDetailPage:(NSString *)capitalId;

@end


