//
//  AgentEditPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AgentEditPage.h"
#import "AgentEditView.h"
#import "STObserverManager.h"
#import "LocationPage.h"
#import "LocationModel.h"

@interface AgentEditPage()<AgentEditViewDelegate,STObserverProtocol>

@property(strong, nonatomic)AgentEditView *agentEditView;
@property(strong, nonatomic)AgentEditViewModel *viewModel;
@property(strong, nonatomic)AgentDetailModel *detailModel;

@end

@implementation AgentEditPage

+(void)show:(BaseViewController *)controller model:(AgentDetailModel *)model{
    AgentEditPage *page = [[AgentEditPage alloc]init];
    page.detailModel = model;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:(_detailModel.level == 4) ? MSG_TITLE_EDIT_CHAIN : MSG_TITLE_EDIT_AGENT needback:YES];
    [self initView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[AgentEditViewModel alloc]init];
    _viewModel.detailModel = _detailModel;
    _viewModel.delegate = self;
    
    _viewModel.model.level = IntStr(_detailModel.level);
    _viewModel.model.mchId = _detailModel.mchId;
    
    _agentEditView =[[AgentEditView alloc]initWithViewModel:_viewModel];
    _agentEditView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _agentEditView.backgroundColor = cbg;
    [self.view addSubview:_agentEditView];
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

//-(void)onReciveResult:(NSString *)key msg:(id)msg{
//    AMapPOI *poi = msg;
//    [_agentEditView updateLocation:poi];
//}


@end

