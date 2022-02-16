//
//  ResetPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ResetPage.h"
#import "ResetView.h"
#import "ResetSuccessPage.h"

@interface ResetPage()<ResetViewDelegate>

@property(strong, nonatomic)ResetView *resetView;
@property(strong, nonatomic)ResetViewModel *viewModel;
@property(copy, nonatomic)NSString *scanStr;
@property(copy, nonatomic)NSString *pswStr;

@end

@implementation ResetPage

+(void)show:(UIViewController *)controller scanStr:(NSString *)scanStr pswStr:(NSString *)pswStr{
    ResetPage *page = [[ResetPage alloc]init];
    page.scanStr = scanStr;
    page.pswStr = pswStr;
    [controller.navigationController pushViewController:page animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MENU_RESET needback:YES];
    [self initView];
}

-(void)initView{
    _viewModel = [[ResetViewModel alloc]init];
    _viewModel.deviceSNStr = _scanStr;
    _viewModel.psw = _pswStr;
    _viewModel.delegate = self;
    
    _resetView =[[ResetView alloc]initWithViewModel:_viewModel];
    _resetView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_resetView];
    
    [_viewModel doReset];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_RESET_PSW]){
        [_resetView updateView:respondModel.data];
    }else if([respondModel.requestUrl containsString:URL_CONFIRM_RESET]){
        [ResetSuccessPage show:self deviceSN:_scanStr];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}


@end

