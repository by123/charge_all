//
//  MerchantEditPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MerchantEditPage.h"
#import "MerchantEditView.h"
#import "STObserverManager.h"
#import "LocationPage.h"
#import "LocationModel.h"

@interface MerchantEditPage()<MerchantEditViewDelegate,STObserverProtocol>

@property(strong, nonatomic)MerchantEditView *merchantEditView;
@property(strong, nonatomic)MerchantEditViewModel *viewModel;
@property(strong, nonatomic)AgentDetailModel *detailModel;

@end

@implementation MerchantEditPage

+(void)show:(BaseViewController *)controller model:(AgentDetailModel *)model{
    MerchantEditPage *page = [[MerchantEditPage alloc]init];
    page.detailModel = model;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:(_detailModel.level == 1) ? MSG_TITLE_EDIT_SUB_CHAIN : MSG_TITLE_EDIT_MERCHANT needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[MerchantEditViewModel alloc]initWithModel:_detailModel];
    _viewModel.delegate = self;
    
    _merchantEditView =[[MerchantEditView alloc]initWithViewModel:_viewModel];
    _merchantEditView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _merchantEditView.backgroundColor = cbg;
    [self.view addSubview:_merchantEditView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_POSITION delegate:self];
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager]  removeSTObsever:NOTIFY_UPDATE_POSITION];
}


-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_AGENT_MERCHANT_DETAIL msg:nil];
    [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_AGENT_MERCHANT_MANAGE msg:nil];
    [self backLastPage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LCProgressHUD showMessage:MSG_UPDATE_SUCCESS];
    });
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onGoBack{
    [self backLastPage];
}

-(void)onGoLocationPage{
//    [LocationPage show:self];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
//    AMapPOI *poi = msg;
//    [_merchantEditView updateLocation:poi];
}


@end

