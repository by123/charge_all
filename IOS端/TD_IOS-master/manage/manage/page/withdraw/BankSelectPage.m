//
//  BankSelectPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BankSelectPage.h"
#import "BankSelectView.h"
#import "STObserverManager.h"
#import "BankHomePage.h"

@interface BankSelectPage()

@property(strong, nonatomic)BankSelectView *bankSelectView;
@property(strong, nonatomic)NSMutableArray *datas;

@end

@implementation BankSelectPage

+(void)show:(BaseViewController *)controller datas:(NSMutableArray *)datas{
    BankSelectPage *page = [[BankSelectPage alloc]init];
    page.datas = datas;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_WITHDRAW_SELECT_STYLE needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _bankSelectView =[[BankSelectView alloc]initWithDatas:_datas page:self];
    _bankSelectView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_bankSelectView];
}

-(void)backLastPage{
    [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_BANK msg:_datas];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goAddBankHomePage{
    [BankHomePage show:self banks:_datas from:BIND_FROM_WITHDRAW_BANKINFO];
}

@end

