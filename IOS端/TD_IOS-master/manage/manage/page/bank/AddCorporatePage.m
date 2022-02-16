//
//  AddCorporatePage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AddCorporatePage.h"
#import "AddCorporateView.h"
#import "BankPage.h"
#import "STObserverManager.h"
#import "WithdrawPage.h"

@interface AddCorporatePage()<AddBankViewDelegate>

@property(strong, nonatomic)AddCorporateView *addCorporateView;
@property(strong, nonatomic)AddBankViewModel *viewModel;

@end

@implementation AddCorporatePage

+(void)show:(BaseViewController *)controller{
    AddCorporatePage *page = [[AddCorporatePage alloc]init];
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
    
    _addCorporateView =[[AddCorporateView alloc]initWithViewModel:_viewModel];
    _addCorporateView.backgroundColor = cbg;
    _addCorporateView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_addCorporateView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_CARDNUM_CHECK]){
        [_addCorporateView updateBankName:data];
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

