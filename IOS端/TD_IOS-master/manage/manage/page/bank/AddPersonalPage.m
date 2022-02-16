//
//  AddPersonalPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AddPersonalPage.h"
#import "AddPersonalView.h"
#import "BankPage.h"
#import "WithdrawPage.h"
#import "STObserverManager.h"

@interface AddPersonalPage()<AddBankViewDelegate>

@property(strong, nonatomic)AddPersonalView *addPersonalView;
@property(strong, nonatomic)AddBankViewModel *viewModel;

@end

@implementation AddPersonalPage

+(void)show:(BaseViewController *)controller{
    AddPersonalPage *page = [[AddPersonalPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_ADD_BK needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[AddBankViewModel alloc]init];
    _viewModel.delegate = self;
    
    _addPersonalView =[[AddPersonalView alloc]initWithViewModel:_viewModel];
    _addPersonalView.backgroundColor = cbg;
    _addPersonalView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_addPersonalView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_CARDNUM_CHECK]){
        [_addPersonalView updateBankName:data];
    }else{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[BankPage class]]) {
                BankPage *page =(BankPage *)controller;
                [self.navigationController popToViewController:page animated:YES];
                [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_BANK msg:nil];
            }
            else if([controller isKindOfClass:[WithdrawPage class]]){
                WithdrawPage *page =(WithdrawPage *)controller;
                [self.navigationController popToViewController:page animated:YES];
                [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_BANK_WITHDRAW msg:nil];
            }
        }
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}


@end

