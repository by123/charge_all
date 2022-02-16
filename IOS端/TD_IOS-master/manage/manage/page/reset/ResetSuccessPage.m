//
//  ResetSuccessPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ResetSuccessPage.h"
#import "ResetSuccessView.h"
#import "MainPage.h"

@interface ResetSuccessPage()<ResetSuccessViewDelegate>

@property(strong, nonatomic)ResetSuccessView *resetSuccessView;
@property(strong, nonatomic)ResetSuccessViewModel *viewModel;
@property(copy, nonatomic)NSString *deviceSN;

@end

@implementation ResetSuccessPage

+(void)show:(BaseViewController *)controller deviceSN:(NSString *)deviceSNStr{
    ResetSuccessPage *page = [[ResetSuccessPage alloc]init];
    page.deviceSN = deviceSNStr;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_RESET_SUCCESS needback:YES];
    [self initView];
}

-(void)initView{
    _viewModel = [[ResetSuccessViewModel alloc]init];
    _viewModel.deviceSNStr = _deviceSN;
    _viewModel.delegate = self;
    
    _resetSuccessView =[[ResetSuccessView alloc]initWithViewModel:_viewModel];
    _resetSuccessView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_resetSuccessView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)backLastPage{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MainPage class]]) {
            MainPage *page =(MainPage *)controller;
            [self.navigationController popToViewController:page animated:YES];
        }
    }
}


@end

