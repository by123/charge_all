//
//  SubPerformanceActivePage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "SubPerformanceActivePage.h"
#import "SubPerformanceActiveView.h"
#import "AgentDetailPage.h"

@interface SubPerformanceActivePage()<SubPerformanceActiveViewDelegate>

@property(strong, nonatomic)SubPerformanceActiveView *subPerformanceActiveView;
@property(strong, nonatomic)SubPerformanceActiveViewModel *viewModel;
@property(copy, nonatomic)NSString *mchId;
@property(copy, nonatomic)NSString *mchName;
@property(copy, nonatomic)NSString *startDay;
@property(copy, nonatomic)NSString *endDay;
@end

@implementation SubPerformanceActivePage

+(void)show:(BaseViewController *)controller mchId:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay{
    SubPerformanceActivePage *page = [[SubPerformanceActivePage alloc]init];
    page.mchId = mchId;
    page.mchName = mchName;
    page.startDay = startDay;
    page.endDay = endDay;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:@"激活设备数" needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[SubPerformanceActiveViewModel alloc]init];
    _viewModel.delegate = self;
    _viewModel.controller = self;
    _viewModel.mchId = _mchId;
    _viewModel.mchName = _mchName;
    _viewModel.startDay = _startDay;
    _viewModel.endDay = _endDay;

    _subPerformanceActiveView =[[SubPerformanceActiveView alloc]initWithViewModel:_viewModel];
    _subPerformanceActiveView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _subPerformanceActiveView.backgroundColor = cbg;
    [self.view addSubview:_subPerformanceActiveView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_PERFORMANCE_ACTIVE_LIST]){
        [_subPerformanceActiveView updateView];
    }else if([respondModel.requestUrl containsString:URL_PERFORMANCE_ACTIVE_TOTAL]){
        [_subPerformanceActiveView updateTotalView];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onRequestNoData:(Boolean)noData requestUrl:(NSString *)requestUrl{
    if([requestUrl containsString:URL_PERFORMANCE_ACTIVE_LIST]){
        [_subPerformanceActiveView updateNoData:noData];
    }
}


-(void)onGoSubPerformanceActivePage:(NSString *)mchId mchName:(NSString *)mchName startDay:(NSString *)startDay endDay:(NSString *)endDay{
    [SubPerformanceActivePage show:self mchId:mchId mchName:mchName startDay:startDay endDay:endDay];
}

-(void)onGoDetailPage:(NSString *)mchId mchType:(int)mchType{
    MerchantModel *model = [[MerchantModel alloc]init];
    model.mchId = mchId;
    model.mchType = mchType;
    [AgentDetailPage show:self model:model];
}

@end

