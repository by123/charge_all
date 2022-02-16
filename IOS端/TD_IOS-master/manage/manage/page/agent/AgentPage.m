//
//  AgentPage.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AgentPage.h"
#import "AgentView.h"
#import "ResultPage.h"
#import "STObserverManager.h"
#import "LocationPage.h"
#import "LocationModel.h"

@interface AgentPage ()<AgentViewDelegate,STObserverProtocol>

@property(strong, nonatomic)AgentView *agentView;

@end

@implementation AgentPage

+(void)show:(BaseViewController *)controller{
    AgentPage *page = [[AgentPage alloc]init];
    [controller pushPage:page];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showSTNavigationBar:MENU_ADD_AGENT needback:YES];
    
    AgentViewModel *viewModel = [[AgentViewModel alloc]init];
    viewModel.delegate = self;
    
    _agentView = [[AgentView alloc]initWithViewModel:viewModel];
    _agentView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _agentView.backgroundColor = c04;
    [self.view addSubview:_agentView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_POSITION delegate:self];
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager]  removeSTObsever:NOTIFY_UPDATE_POSITION];
}


-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    NSString *userName = [data objectForKey:@"SuperUser"];
    NSString *psw = [data objectForKey:@"password"];
    [ResultPage show:self username:userName psw:psw type:1];
    
}

-(void)onRequestFail:(NSString *)msg{
}


-(void)onGoLocationPage{
//    [LocationPage show:self];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
//    AMapPOI *poi = msg;
//    [_agentView updateLocation:poi];
}


@end



