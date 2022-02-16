//
//  AchievePage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AchievePage.h"
#import "AchieveView.h"
#import "AgentDetailPage.h"

@interface AchievePage()<AchieveViewDelegate>

@property(strong, nonatomic)AchieveView *achieveView;
@property(strong, nonatomic)AchieveViewModel *viewModel;
@property(assign, nonatomic)NSInteger tab;

@end

@implementation AchievePage

+(void)show:(BaseViewController *)controller tab:(NSInteger)tab{
    AchievePage *page = [[AchievePage alloc]init];
    page.tab = tab;
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
    
    _viewModel = [[AchieveViewModel alloc]init];
    _viewModel.currentTab = _tab;
    _viewModel.delegate = self;
    
    _achieveView =[[AchieveView alloc]initWithViewModel:_viewModel];
    _achieveView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_achieveView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onGoAgentDetailPage:(MerchantModel *)model{
    [AgentDetailPage show:self model:model];
}


@end

