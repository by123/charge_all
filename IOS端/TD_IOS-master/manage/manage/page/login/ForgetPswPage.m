//
//  ForgetPswPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ForgetPswPage.h"
#import "ForgetPswView.h"

@interface ForgetPswPage()<ForgetPswViewDelegate>

@property(strong, nonatomic)ForgetPswView *forgetPswView;
@property(strong, nonatomic)ForgetPswViewModel *viewModel;

@end

@implementation ForgetPswPage

+(void)show:(BaseViewController *)controller{
    ForgetPswPage *page = [[ForgetPswPage alloc]init];
    [controller.navigationController presentViewController:page animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[ForgetPswViewModel alloc]init];
    _viewModel.delegate = self;
    
    _forgetPswView =[[ForgetPswView alloc]initWithViewModel:_viewModel];
    _forgetPswView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight);
    [self.view addSubview:_forgetPswView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_GET_VERIFYCODE]){
        [_forgetPswView updateStep1];
    }else if([respondModel.requestUrl containsString:URL_CHECK_VERIFYCODE]){
        [_forgetPswView updateStep2];
    }else if([respondModel.requestUrl containsString:URL_RESET_PASSWORD]){
        [LCProgressHUD showMessage:MSG_UPDATE_SUCCESS];
        [_forgetPswView updateStep3];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onClosePage{
    [self dismissViewControllerAnimated:self completion:nil];
}

@end

