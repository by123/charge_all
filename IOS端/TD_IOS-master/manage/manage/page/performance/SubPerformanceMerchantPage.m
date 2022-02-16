//
//  SubPerformanceMerchantPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "SubPerformanceMerchantPage.h"
#import "SubPerformanceMerchantView.h"
#import "AgentDetailPage.h"

@interface SubPerformanceMerchantPage()<SubPerformanceMerchantViewDelegate>

@property(strong, nonatomic)SubPerformanceMerchantView *subPerformanceMerchantView;
@property(strong, nonatomic)SubPerformanceMerchantViewModel *viewModel;
@property(copy, nonatomic)NSString *mchId;
@property(copy, nonatomic)NSString *mchName;
@property(copy, nonatomic)NSString *startDay;
@property(copy, nonatomic)NSString *endDay;

@end

@implementation SubPerformanceMerchantPage

+(void)show:(BaseViewController *)controller mchId:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay{
    SubPerformanceMerchantPage *page = [[SubPerformanceMerchantPage alloc]init];
    page.mchId = mchId;
    page.mchName = mchName;
    page.startDay = startDay;
    page.endDay = endDay;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:@"开发商户数" needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[SubPerformanceMerchantViewModel alloc]init];
    _viewModel.delegate = self;
    _viewModel.controller = self;
    _viewModel.mchId = _mchId;
    _viewModel.mchName = _mchName;
    _viewModel.startDay = _startDay;
    _viewModel.endDay = _endDay;
    
    _subPerformanceMerchantView =[[SubPerformanceMerchantView alloc]initWithViewModel:_viewModel];
    _subPerformanceMerchantView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _subPerformanceMerchantView.backgroundColor = cbg;
    [self.view addSubview:_subPerformanceMerchantView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
   if([respondModel.requestUrl containsString:URL_PERFORMANCE_MERCHANT_LIST] || [respondModel.requestUrl containsString:URL_PERFORMANCE_MERCHANT_SUBLIST]){
        [_subPerformanceMerchantView updateView];
    }else if([respondModel.requestUrl containsString:URL_PERFORMANCE_MERCHANT_TOTAL]){
        [_subPerformanceMerchantView updateTotalView];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onRequestNoData:(Boolean)noData requestUrl:(NSString *)requestUrl{
    if([requestUrl containsString:URL_PERFORMANCE_MERCHANT_LIST] || [requestUrl containsString:URL_PERFORMANCE_MERCHANT_SUBLIST]){
        [_subPerformanceMerchantView updateNoData:noData];
    }
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

