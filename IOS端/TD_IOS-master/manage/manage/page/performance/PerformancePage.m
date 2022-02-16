//
//  PerformancePage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "PerformancePage.h"
#import "PerformanceView.h"
#import "SubPerformanceMerchantPage.h"
#import "SubPerformanceActivePage.h"
#import "AgentDetailPage.h"

@interface PerformancePage()<PerformanceViewDelegate>

@property(strong, nonatomic)PerformanceView *performanceView;
@property(strong, nonatomic)PerformanceViewModel *activeVM;
@property(strong, nonatomic)PerformanceViewModel *merchantVM;
@property(strong, nonatomic)PerformanceViewModel *archiveVm;

@end

@implementation PerformancePage

+(void)show:(BaseViewController *)controller{
    PerformancePage *page = [[PerformancePage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_ACHIEVE needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _activeVM = [[PerformanceViewModel alloc]init];
    _activeVM.delegate = self;
    _activeVM.controller = self;
    
    _merchantVM = [[PerformanceViewModel alloc]init];
    _merchantVM.delegate = self;
    _merchantVM.controller = self;
    
    _archiveVm = [[PerformanceViewModel alloc]init];
    _archiveVm.delegate = self;
    _archiveVm.controller = self;
    
    _performanceView =[[PerformanceView alloc]initWithViewModel:_activeVM merchant:_merchantVM archive:_archiveVm];
    _performanceView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _performanceView.backgroundColor = cbg;
    [self.view addSubview:_performanceView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_PERFORMANCE_ACTIVE_LIST]){
        [_performanceView updateView:PerformanceType_Active];
    }else if([respondModel.requestUrl containsString:URL_PERFORMANCE_MERCHANT_LIST] || [respondModel.requestUrl containsString:URL_PERFORMANCE_MERCHANT_SUBLIST]){
        [_performanceView updateView:PerformanceType_Merchant];
    }else if([respondModel.requestUrl containsString:URL_PERFORMANCE_ACTIVE_TOTAL]){
        [_performanceView updateTotalView:PerformanceType_Active];
    }else if([respondModel.requestUrl containsString:URL_PERFORMANCE_MERCHANT_TOTAL]){
        [_performanceView updateTotalView:PerformanceType_Merchant];
    }else if([respondModel.requestUrl containsString:URL_PROFIT_LIST]){
        [_performanceView updateView:PerformanceType_Archive];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onRequestNoData:(Boolean)noData requestUrl:(NSString *)requestUrl{
    if([requestUrl containsString:URL_PERFORMANCE_ACTIVE_LIST]){
        [_performanceView updateNoData:PerformanceType_Active noData:noData];
    }else if([requestUrl containsString:URL_PERFORMANCE_MERCHANT_LIST] || [requestUrl containsString:URL_PERFORMANCE_MERCHANT_SUBLIST]){
        [_performanceView updateNoData:PerformanceType_Merchant noData:noData];
    }else if([requestUrl containsString:URL_PROFIT_LIST]){
        [_performanceView updateNoData:PerformanceType_Archive noData:noData];
    }
}


-(void)onGoSubPerformanceActivePage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay{
    [SubPerformanceActivePage show:self mchId:mchId mchName:mchName startDay:startDay endDay:endDay];
}

-(void)onGoSubPerformanceMerchantPage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay{
    [SubPerformanceMerchantPage show:self mchId:mchId mchName:mchName startDay:startDay endDay:endDay];
}

-(void)onGoDetailPage:(NSString *)mchId mchType:(int)mchType{
    MerchantModel *model = [[MerchantModel alloc]init];
    model.mchId = mchId;
    model.mchType = mchType;
    [AgentDetailPage show:self model:model];
}
@end

