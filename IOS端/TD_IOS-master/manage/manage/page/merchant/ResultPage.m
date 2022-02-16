//
//  MerchatResultPage.m
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ResultPage.h"
#import "ResultView.h"
#import "MainPage.h"
#import "STFileUtil.h"
#import <Photos/Photos.h>

@interface ResultPage ()<ResultViewDelegate>

@property(strong, nonatomic)NSString *mUserNameStr;
@property(strong, nonatomic)NSString *mPswStr;
@property(assign, nonatomic)int mType;

@property(strong, nonatomic)ResultView *resultView;

@end

@implementation ResultPage{
    Boolean hasPhotoAuth;
    Boolean hasCopy;
}


+(void)show:(BaseViewController *)controller username:(NSString *)userName psw:(NSString *)password type:(int)type{
    ResultPage *page = [[ResultPage alloc]init];
    page.mUserNameStr = userName;
    page.mPswStr = password;
    page.mType = type;
    [controller pushPage:page];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_RESULT needback:YES];
    
    ResultViewModel *viewModel = [[ResultViewModel alloc]init];
    viewModel.delegate = self;
    viewModel.mType = _mType;
    viewModel.mUserNameStr = _mUserNameStr;
    viewModel.mPswStr = _mPswStr;
    
    _resultView = [[ResultView alloc]initWithViewModel:viewModel];
    _resultView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_resultView];
    
   
    [self checkPhotoAuth];
}


-(void)checkPhotoAuth{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusRestricted ||
                status == PHAuthorizationStatusDenied) {
                self->hasPhotoAuth = NO;
            }else if(status == PHAuthorizationStatusAuthorized){
                self->hasPhotoAuth = YES;
            }
        }];
    }
}

-(void)onConfirmCallBack{
    [self handleUserAction];
}

-(void)onCopyCallback:(NSString *)userName psw:(NSString *)password{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:MSG_RESULT_CONTENT,_mUserNameStr,_mPswStr];
    [STAlertUtil showAlertController:MSG_EMPTY content:MSG_RESULT_COPY_SUCCESS controller:self];
    hasCopy = YES;
}


-(void)backLastPage{
    [self handleUserAction];
}

-(void)handleUserAction{
    if(!hasCopy && !hasPhotoAuth){
        [LCProgressHUD showMessage:MSG_RESULT_COPY_ACCOUNT];
    }else{
        if(hasPhotoAuth){
            [STFileUtil doSaveScreenShot];
        }
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MainPage class]]) {
                MainPage *page =(MainPage *)controller;
                [self.navigationController popToViewController:page animated:YES];
            }
        }
    }
}


@end
