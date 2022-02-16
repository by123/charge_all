//
//  UnBindingPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "UnBindingPage.h"
#import "UnBindingView.h"
#import "ScanPage.h"
#import "ActiveDevicePage.h"
#import "BindMerchantPage.h"

@interface UnBindingPage()<UnBindingViewDelegate>

@property(strong, nonatomic)UnBindingView *unBindingView;
@property(strong, nonatomic)UnBindingViewModel *viewModel;

@end

@implementation UnBindingPage

+(void)show:(BaseViewController *)controller{
    UnBindingPage *page = [[UnBindingPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MENU_UNBINDING needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[UnBindingViewModel alloc]init];
    _viewModel.delegate = self;
    
    _unBindingView =[[UnBindingView alloc]initWithViewModel:_viewModel];
    _unBindingView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_unBindingView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onGoScanBindPage{
    [ScanPage show:self type:ScanType_UNBIND_DEVICE mchId:MSG_EMPTY mchName:MSG_EMPTY];
}

-(void)onGoMerchantBindPage{
    [BindMerchantPage show:self openid:MSG_EMPTY unionid:MSG_EMPTY type:MSG_EMPTY from:MerchantFromType_UNBIND];
//    [ActiveDevicePage show:self type:DeviceActiveType_UnBind];
}


@end

