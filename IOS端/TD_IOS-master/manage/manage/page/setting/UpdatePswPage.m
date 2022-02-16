//
//  UpdatePswPage.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "UpdatePswPage.h"
#import "UpdatePswView.h"
#import "LoginPage.h"

@interface UpdatePswPage ()<UpdatePswViewDelegate>

@property(strong, nonatomic)UpdatePswView *updatePswView;

@end

@implementation UpdatePswPage

+(void)show:(BaseViewController *)controller{
    UpdatePswPage *page = [[UpdatePswPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_UPDATE_PSW needback:YES];
    [self initView];
}

-(void)initView{
    UpdatePswViewModel *viewModel = [[UpdatePswViewModel alloc]init];
    viewModel.delegate = self;
    
    _updatePswView = [[UpdatePswView alloc]initWithModel:viewModel];
    _updatePswView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _updatePswView.backgroundColor = cbg;
    [self.view addSubview:_updatePswView];
}


-(void)onRequestBegin{
    
}

-(void)onRequestFail:(NSString *)msg{
    
}


-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [LoginPage back:self content:MSG_UPDATE_PSW_SUCCESS];
}


@end
