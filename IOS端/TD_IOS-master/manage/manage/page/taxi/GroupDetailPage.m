//
//  GroupDetailPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "GroupDetailPage.h"
#import "GroupDetailView.h"
#import "GroupEditPage.h"
#import "STObserverManager.h"

@interface GroupDetailPage()<GroupDetailViewDelegate,STObserverProtocol>

@property(strong, nonatomic)GroupDetailView *groupDetailView;
@property(strong, nonatomic)GroupDetailViewModel *viewModel;
@property(strong, nonatomic)GroupModel *model;

@end

@implementation GroupDetailPage

+(void)show:(BaseViewController *)controller model:(GroupModel *)model{
    GroupDetailPage *page = [[GroupDetailPage alloc]init];
    page.model = model;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_GROUP_DETAIL needback:YES];
    [self initView];
    
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_GROUP delegate:self];
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_UPDATE_GROUP];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    [_viewModel requestGroupDetail];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[GroupDetailViewModel alloc]init];
    _viewModel.groupModel = _model;
    _viewModel.delegate = self;
    
    _groupDetailView =[[GroupDetailView alloc]initWithViewModel:_viewModel];
    _groupDetailView.backgroundColor = cbg;
    _groupDetailView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_groupDetailView];
    
    [_viewModel requestGroupDetail];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [_groupDetailView updateView];
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onGoGroupEditPage:(GroupModel *)groupModel{
    [GroupEditPage show:self model:groupModel];
}

@end

