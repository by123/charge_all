//
//  MainViewModel.h
//  bus
//
//  Created by by.huang on 2018/9/14.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "CapitalModel.h"

@protocol MainViewDelegate<BaseRequestDelegate>

-(void)onGoScanPage;
-(void)onGoActiveDevice;
-(void)onGoAddMerchat;
-(void)onGoAddAgent;
-(void)onGoAddSaleman;
-(void)onGoAddChain;
-(void)onGoAccountDetail;
-(void)onGogoBankDetail;
-(void)onGoTaxi;
-(void)onGoAppSettingPage;
-(void)onGoWhiteListPage;
-(void)onGoResetPage;
-(void)onGoArchievePage:(NSInteger)tab;
-(void)onGoMsgPage;
-(void)onGoOrderSearchPage;
-(void)onGoOrderDetailPage:(NSString *)orderId;
-(void)onGoRefundPage:(OrderModel *)model;
-(void)onGoHelpPage;
-(void)onGoWithdrawPage:(CapitalModel *)model;
-(void)onGoWithdrawSuccessPage:(NSString *)withdrawId;
-(void)onGoWithdrawFailPage:(NSString *)withdrawId;
-(void)onGoAgentManagePage;
-(void)onGoCapitalDetailPage:(NSString *)date;
-(void)onOpenCalendar;
-(void)onGoUnBindingPage;

@end

@interface MainViewModel : NSObject

@property(weak, nonatomic)id<MainViewDelegate> delegate;


//首页数据
-(void)getHomeData;

//扫码绑定商户
-(void)scanMerchant;

//激活设备
-(void)goActiveDevice;

//添加商户
-(void)goAddMerchat;

//添加代理
-(void)goAddAgent;

//添加业务员
-(void)goAddSaleman;
    
//添加连锁门店
-(void)goAddChain;

//跳转到出租车业务
-(void)goTaxi;

//账户详情
-(void)goAccountDetail;

//BK信息
-(void)goBankDetail;

//跳转到设置
-(void)goSettingPage;

//跳转到白名单
-(void)goWhiteListPage;

//跳转到设备密码重置
-(void)goReset;

//跳转到业绩明细
-(void)goArchievePage:(NSInteger)tab;

//跳转到消息
-(void)goMsgPage;

//跳转到搜索
-(void)goOrderSearchPage;

//跳转到订单详情
-(void)goOrderDetailPage:(NSString *)orderId;

//跳转到退款
-(void)goRefundPage:(OrderModel *)model;

//资金帮助
-(void)goHelpPage;

//跳转到tx
-(void)goWithdrawPage:(CapitalModel *)model;

//跳转到tx成功
-(void)goWithdrawSuccessPage:(NSString *)withdrawId;

//跳转到tx失败
-(void)goWithdrawFailPage:(NSString *)withdrawId;

//跳转到代理商管理
-(void)goAgentManagePage;

//设备解绑
-(void)goUnBindingPage;

//跳转到收益详情
-(void)goCapitalDetailPage:(NSString *)capitalId;

@end
