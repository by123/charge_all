//
//  GroupEditPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "GroupEditPage.h"
#import "GroupEditView.h"
#import "GroupDetailPage.h"
#import "STObserverManager.h"

@interface GroupEditPage()<GroupEditViewDelegate>

@property(strong, nonatomic)GroupEditView *groupEditView;
@property(strong, nonatomic)GroupEditViewModel *viewModel;
@property(strong, nonatomic)GroupModel *groupModel;

@end

@implementation GroupEditPage

+(void)show:(BaseViewController *)controller model:(GroupModel *)groupModel{
    GroupEditPage *page = [[GroupEditPage alloc]init];
    page.groupModel = groupModel;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_GROUP_EDIT needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[GroupEditViewModel alloc]init];
    _viewModel.model = _groupModel;
    _viewModel.delegate = self;
    
    _groupEditView =[[GroupEditView alloc]initWithViewModel:_viewModel];
    _groupEditView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _groupEditView.backgroundColor = cbg;
    [self.view addSubview:_groupEditView];
    
    [_viewModel requestSaleMans];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_ALL_USER]){
        [_groupEditView updateSaleSelectView];
    }else if([respondModel.requestUrl containsString:URL_GROUP_EDIT]){
        [LCProgressHUD showMessage:MSG_UPDATE_SUCCESS];
        [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_GROUP msg:nil];
        [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_GROUP_LIST msg:nil];
        [self backLastPage];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}


@end

