//
//  AgentManagePage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AgentManagePage.h"
#import "AgentManageView.h"
#import "AgentDetailPage.h"
#import "STObserverManager.h"

@interface AgentManagePage()<AgentManageViewDelegate,STObserverProtocol>

@property(strong, nonatomic)AgentManageView *agentManageView;
@property(strong, nonatomic)AgentManageViewModel *viewModel;

@end

@implementation AgentManagePage

+(void)show:(BaseViewController *)controller{
    AgentManagePage *page = [[AgentManagePage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MENU_AGENT_MANAGE needback:YES];
    [self initView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_AGENT_MERCHANT_MANAGE delegate:self];

}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_UPDATE_AGENT_MERCHANT_MANAGE];    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[AgentManageViewModel alloc]init];
    _viewModel.delegate = self;
    
    _agentManageView =[[AgentManageView alloc]initWithViewModel:_viewModel];
    _agentManageView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _agentManageView.backgroundColor = cwhite;
    [self.view addSubview:_agentManageView];
    
    [_viewModel requestAgentList:MSG_EMPTY refreshNew:YES];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [_agentManageView onRequestSuccess:respondModel data:data];
}

-(void)onRequestFail:(NSString *)msg{
    [_agentManageView onRequestFail:msg];

}

-(void)onRequestNoData:(Boolean)hasDatas{
    [_agentManageView onRequestNoData:hasDatas];
}

-(void)onGoAgentDetailPage:(MerchantModel *)model{
    [AgentDetailPage show:self model:model];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    if([key isEqualToString:NOTIFY_UPDATE_AGENT_MERCHANT_MANAGE] ){
        [_agentManageView updateView];
    }
}


@end

