//
//  BankHomePage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BankHomePage.h"
#import "BankHomeView.h"
#import "AddCorporatePage.h"
#import "AddPersonalPage.h"
#import "BindWeChatPage.h"

@interface BankHomePage()<BankHomeViewDelegate>

@property(strong, nonatomic)BankHomeView *bankHomeView;
@property(strong, nonatomic)BankHomeViewModel *viewModel;
@property(strong, nonatomic)NSMutableArray *banks;
@property(assign, nonatomic)int from;

@end

@implementation BankHomePage

+(void)show:(BaseViewController *)controller banks:(NSMutableArray *)banks from:(int)from{
    BankHomePage *page = [[BankHomePage alloc]init];
    page.banks = banks;
    page.from = from;
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
    _viewModel = [[BankHomeViewModel alloc]init];
    _viewModel.banks = _banks;
    _viewModel.delegate = self;
    
    _bankHomeView =[[BankHomeView alloc]initWithViewModel:_viewModel];
    _bankHomeView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_bankHomeView];
    
//    [_viewModel requestRule];
    [_bankHomeView updateView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
//    if([respondModel.requestUrl containsString:URL_WITHDRAW_RULE]){
//        [_bankHomeView updateView];
//    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onGoAddBankPage:(NSInteger)type{
    if(type == WeChat){
        [BindWeChatPage show:self from:_from];
        return;
    }
    if(type == Corporate){
        [AddCorporatePage show:self];
        return;
    }
    if(type == Personal){
        [AddPersonalPage show:self];
        return;
    }
}

@end

