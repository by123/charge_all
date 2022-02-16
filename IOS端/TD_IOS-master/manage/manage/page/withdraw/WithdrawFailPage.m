//
//  WithdrawFailPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawFailPage.h"
#import "WithdrawFailView.h"

@interface WithdrawFailPage()<WithdrawFailViewDelegate>

@property(strong, nonatomic)WithdrawFailView *withdrawFailView;
@property(strong, nonatomic)WithdrawFailViewModel *viewModel;
@property(copy, nonatomic)NSString *withdrawId;

@end

@implementation WithdrawFailPage

+(void)show:(BaseViewController *)controller withdrawId:(NSString *)withdrawId{
    WithdrawFailPage *page = [[WithdrawFailPage alloc]init];
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
    _viewModel = [[WithdrawFailViewModel alloc]init];
    _viewModel.delegate = self;
    
    _withdrawFailView =[[WithdrawFailView alloc]initWithViewModel:_viewModel];
    _withdrawFailView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_withdrawFailView];
    
    [_viewModel requestWithdrawDetail:_withdrawId];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if(_withdrawFailView){
        [_withdrawFailView updateView];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}


@end

