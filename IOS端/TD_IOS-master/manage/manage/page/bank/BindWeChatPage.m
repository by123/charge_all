//
//  BindWeChatPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BindWeChatPage.h"
#import "BindWeChatView.h"
#import "WeChatUtil.h"
#import "AppDelegate.h"
#import "STObserverManager.h"
#import "BankPage.h"
#import "WithdrawPage.h"

@interface BindWeChatPage()<BindWeChatViewDelegate,STObserverProtocol>

@property(strong, nonatomic)BindWeChatView *bindWeChatView;
@property(strong, nonatomic)BindWeChatViewModel *viewModel;
@property(assign, nonatomic)int from;

@end

@implementation BindWeChatPage

+(void)show:(BaseViewController *)controller from:(int)from{
    BindWeChatPage *page = [[BindWeChatPage alloc]init];
    page.from = from;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_BIND_WECHAT_TITLE needback:YES];
    [self initView];
    [[STObserverManager sharedSTObserverManager]registerSTObsever:NOTIFY_WECHAT_CODE delegate:self];
}


-(void)dealloc{
    [[STObserverManager sharedSTObserverManager]removeSTObsever:NOTIFY_WECHAT_CODE];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[BindWeChatViewModel alloc]init];
    _viewModel.delegate = self;
    
    _bindWeChatView =[[BindWeChatView alloc]initWithViewModel:_viewModel];
    _bindWeChatView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_bindWeChatView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_BIND_WECAHT]){
        [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_WECHAT_BIND msg:nil];
        if(_from == BIND_FROM_BANKINFO){
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[BankPage class]]) {
                    BankPage *page =(BankPage *)controller;
                    [self.navigationController popToViewController:page animated:YES];
                }
            }
        }else if(_from == BIND_FROM_WITHDRAW || _from == BIND_FROM_WITHDRAW_BANKINFO){
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[WithdrawPage class]]) {
                    WithdrawPage *page =(WithdrawPage *)controller;
                    [self.navigationController popToViewController:page animated:YES];
                }
            }
        }
        else{
            [self backLastPage];
        }
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onDoWeChatAuth{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate doWeChatLogin:self];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    if([key isEqualToString:NOTIFY_WECHAT_CODE]){
        NSString *code = msg;
        [_viewModel bindWeChat:code];
    }
}


@end

