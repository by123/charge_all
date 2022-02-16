//
//  SettingPage.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "SettingPage.h"
#import "SettingView.h"
#import "LoginPage.h"
#import "UpdatePswPage.h"
#import "AboutPage.h"
#import "AccountManager.h"
@interface SettingPage ()<SettingViewDelegate>

@property(strong, nonatomic)SettingView *settingView;

@end

@implementation SettingPage

+(void)show:(BaseViewController *)controller{
    SettingPage *page = [[SettingPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_SETTING needback:YES];
    [self initView];
}

-(void)initView{
    SettingViewModel *viewModel = [[SettingViewModel alloc]init];
    viewModel.delegate = self;
    
    _settingView = [[SettingView alloc]initWithViewModel:viewModel];
    _settingView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _settingView.backgroundColor = cbg;
    [self.view addSubview:_settingView];
}

-(void)onLogout{
    WS(weakSelf)
    [STAlertUtil showAlertController:MSG_EMPTY content:MSG_CONFIRM_EXIT controller:self confirm:^{
        [[AccountManager sharedAccountManager]clearUserModel];
        [LoginPage back:weakSelf content:MSG_EMPTY];
        
    }];
   
}


-(void)onGoUpdatePswPage{
    [UpdatePswPage show:self];
}

-(void)onGoAboutPage{
    [AboutPage show:self];
}


@end
