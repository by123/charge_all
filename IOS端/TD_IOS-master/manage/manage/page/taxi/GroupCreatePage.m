//
//  GroupCreatePage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "GroupCreatePage.h"
#import "GroupCreateView.h"
#import "GroupCreateSuccessPage.h"

@interface GroupCreatePage()<GroupCreateViewDelegate>

@property(strong, nonatomic)GroupCreateView *groupCreateView;
@property(strong, nonatomic)GroupCreateViewModel *viewModel;
@property(strong, nonatomic)UITableView *tableView;

@end

@implementation GroupCreatePage

+(void)show:(BaseViewController *)controller{
    GroupCreatePage *page = [[GroupCreatePage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_GROUP_CREATE needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[GroupCreateViewModel alloc]init];
    _viewModel.delegate = self;
    
    _groupCreateView =[[GroupCreateView alloc]initWithViewModel:_viewModel];
    _groupCreateView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _groupCreateView.backgroundColor = cbg;
    [self.view addSubview:_groupCreateView];
    
    [_viewModel requestSaleMans];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_ALL_USER]){
        [_groupCreateView updateSaleSelectView];
    }else if([respondModel.requestUrl containsString:URL_GROUP_ADD]){
        [LCProgressHUD showMessage:MSG_GROUP_CREATE_SUCCESS];
        [GroupCreateSuccessPage show:self groupId:_viewModel.model.groupId groupName:_viewModel.model.groupName];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}


@end

