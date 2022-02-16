//
//  BankPage.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BankPage.h"
#import "BankView.h"
#import "BankHomePage.h"
#import "BankDetailPage.h"
#import "STObserverManager.h"

@interface BankPage ()<BankViewDelegate,STObserverProtocol>

@property(strong, nonatomic)BankView *bankView;
@property(strong, nonatomic)BankViewModel *viewModel;

@end

@implementation BankPage

+(void)show:(BaseViewController *)controller{
    BankPage *page = [[BankPage alloc]init];
    [controller pushPage:page];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_BANK delegate:self];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_WECHAT_BIND delegate:self];

}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_UPDATE_BANK];
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_WECHAT_BIND];
}

-(void)initView{
    [self showSTNavigationBar:MSG_BK_DETAIL needback:YES];
    
    _viewModel = [[BankViewModel alloc]init];
    _viewModel.delegate = self;
    
    _bankView = [[BankView alloc]initWithViewModel:_viewModel];
    _bankView.backgroundColor = cwhite;
    _bankView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_bankView];
    
    [_viewModel getBankInfo];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    if(_viewModel){
        if([key isEqualToString:NOTIFY_UPDATE_BANK]){
            [_viewModel getBankInfo];
        }else if([key isEqualToString:NOTIFY_WECHAT_BIND]){
            [_viewModel getBankInfo];
        }
    }
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if(_bankView){
        [_bankView updateView];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}


-(void)onGoBankDetailPage:(BankModel *)bankModel{
    [BankDetailPage show:self model:bankModel];
}


-(void)onGoAddBankHomePage:(NSMutableArray *)banks{
    [BankHomePage show:self banks:banks from:BIND_FROM_BANKINFO];
}

@end
