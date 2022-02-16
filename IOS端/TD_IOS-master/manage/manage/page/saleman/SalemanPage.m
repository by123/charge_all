//
//  SalemanPage.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "SalemanPage.h"
#import "SalemanView.h"
#import "ResultPage.h"

@interface SalemanPage ()<SalemanViewDelegate>

@property(strong, nonatomic)SalemanView *salemanView;
@end

@implementation SalemanPage

+(void)show:(BaseViewController *)controller{
    SalemanPage *page = [[SalemanPage alloc]init];
    [controller pushPage:page];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showSTNavigationBar:MENU_ADD_SALEMAN needback:YES];
    
    SalemanViewModel *viewModel = [[SalemanViewModel alloc]init];
    viewModel.delegate = self;
    
     _salemanView= [[SalemanView alloc]initWithViewModel:viewModel];
    _salemanView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _salemanView.backgroundColor = c04;
    [self.view addSubview:_salemanView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    NSString *userName = [data objectForKey:@"userId"];
    NSString *psw = [data objectForKey:@"password"];
    [ResultPage show:self username:userName psw:psw type:2];
    
}

-(void)onRequestFail:(NSString *)msg{
}



@end



