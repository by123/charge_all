//
//  GroupCreateSuccessPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "GroupCreateSuccessPage.h"
#import "GroupCreateSuccessView.h"
#import "TaxiPage.h"
#import "ScanPage.h"
#import "STObserverManager.h"

@interface GroupCreateSuccessPage()<GroupCreateSuccessViewDelegate>

@property(strong, nonatomic)GroupCreateSuccessView *groupCreateSuccessView;
@property(strong, nonatomic)GroupCreateSuccessViewModel *viewModel;
@property(copy, nonatomic)NSString *groupId;
@property(copy, nonatomic)NSString *groupName;

@end

@implementation GroupCreateSuccessPage

+(void)show:(BaseViewController *)controller groupId:(NSString *)groupId groupName:(NSString *)groupName{
    GroupCreateSuccessPage *page = [[GroupCreateSuccessPage alloc]init];
    page.groupId = groupId;
    page.groupName = groupName;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_GROUP_CREATE_SUCCESS needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[GroupCreateSuccessViewModel alloc]init];
    _viewModel.groupId = _groupId;
    _viewModel.groupName = _groupName;
    _viewModel.delegate = self;
    
    _groupCreateSuccessView =[[GroupCreateSuccessView alloc]initWithViewModel:_viewModel];
    _groupCreateSuccessView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_groupCreateSuccessView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onBackListPage{
    [self backAndUpdate];
}
    
-(void)backLastPage{
    [self backAndUpdate];
}
    
-(void)backAndUpdate{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TaxiPage class]]) {
            TaxiPage *page =(TaxiPage *)controller;
            [self.navigationController popToViewController:page animated:YES];
            [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_GROUP_LIST msg:nil];
        }
    }
}

-(void)onGoScanPage:(NSString *)groupId groupName:(NSString *)groupName{
    [ScanPage show:self type:ScanType_BIND_GROUP mchId:groupId mchName:groupName];
}


@end

