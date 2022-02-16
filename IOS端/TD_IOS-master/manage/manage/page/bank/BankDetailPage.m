//
//  BankDetailPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BankDetailPage.h"
#import "BankDetailView.h"

@interface BankDetailPage()<BankDetailViewDelegate>

@property(strong, nonatomic)BankDetailView *bankDetailView;
@property(strong, nonatomic)BankDetailViewModel *viewModel;
@property(strong, nonatomic)BankModel *mBankModel;

@end

@implementation BankDetailPage

+(void)show:(BaseViewController *)controller model:(BankModel *)bankModel{
    BankDetailPage *page = [[BankDetailPage alloc]init];
    page.mBankModel = bankModel;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_BK_DETAIL needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[BankDetailViewModel alloc]initWithModel:_mBankModel];
    _viewModel.delegate = self;
    
    _bankDetailView =[[BankDetailView alloc]initWithViewModel:_viewModel];
    _bankDetailView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_bankDetailView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    
}

-(void)onRequestFail:(NSString *)msg{
    
}


@end

