//
//  WithdrawSuccessPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawSuccessPage.h"
#import "WithdrawSuccessView.h"
#import "MainPage.h"

@interface WithdrawSuccessPage()<WithdrawSuccessViewDelegate>

@property(strong, nonatomic)WithdrawSuccessView *withdrawSuccessView;
@property(strong, nonatomic)WithdrawSuccessViewModel *viewModel;
@property(copy, nonatomic)NSString *withdrawId;

@end

@implementation WithdrawSuccessPage

+(void)show:(BaseViewController *)controller withdrawId:(NSString *)withdrawId{
    WithdrawSuccessPage *page = [[WithdrawSuccessPage alloc]init];
    page.withdrawId = withdrawId;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TX needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[WithdrawSuccessViewModel alloc]init];
    _viewModel.delegate = self;
    
    _withdrawSuccessView =[[WithdrawSuccessView alloc]initWithViewModel:_viewModel];
    _withdrawSuccessView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _withdrawSuccessView.backgroundColor = cbg;
    [self.view addSubview:_withdrawSuccessView];
    
    [_viewModel requestWithdrawDetail:_withdrawId];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if(_withdrawSuccessView){
        [_withdrawSuccessView updateView];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onBackHomePage{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MainPage class]]) {
            MainPage *page =(MainPage *)controller;
            [self.navigationController popToViewController:page animated:YES];
        }
    }
}

@end

