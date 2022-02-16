//
//  MerchantUnBindResultPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MerchantUnBindResultPage.h"
#import "MerchantUnBindResultView.h"
#import "MainPage.h"
//#import "ActiveDevicePage.h"
#import "BindMerchantPage.h"

@interface MerchantUnBindResultPage()<MerchantUnBindResultViewDelegate>

@property(strong, nonatomic)MerchantUnBindResultView *merchantUnBindResultView;
@property(strong, nonatomic)MerchantUnBindResultViewModel *viewModel;
@property(assign, nonatomic)int count;
@property(assign, nonatomic)Boolean isSuccess;

@end

@implementation MerchantUnBindResultPage

+(void)show:(BaseViewController *)controller isSuccess:(Boolean)isSuccess count:(int)count{
    MerchantUnBindResultPage *page = [[MerchantUnBindResultPage alloc]init];
    page.isSuccess = isSuccess;
    page.count = count;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:@"" needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[MerchantUnBindResultViewModel alloc]init];
    _viewModel.isSuccess = _isSuccess;
    _viewModel.count = _count;
    _viewModel.delegate = self;
    
    _merchantUnBindResultView =[[MerchantUnBindResultView alloc]initWithViewModel:_viewModel];
    _merchantUnBindResultView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_merchantUnBindResultView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onBankHome{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MainPage class]]) {
            MainPage *page =(MainPage *)controller;
            [self.navigationController popToViewController:page animated:YES];
            break;
        }
    }
}

-(void)backLastPage{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BindMerchantPage class]]) {
            BindMerchantPage *page =(BindMerchantPage *)controller;
            [self.navigationController popToViewController:page animated:YES];
            break;
        }
    }
}


@end

