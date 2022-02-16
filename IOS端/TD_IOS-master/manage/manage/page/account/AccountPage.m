//
//  AccountPage.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AccountPage.h"
#import "AccountView.h"

@interface AccountPage ()<AccountViewDelegate>

@property(strong, nonatomic)AccountView *accountView;
@property(strong, nonatomic)AccountViewModel *viewModel;



@end

@implementation AccountPage

+(void)show:(BaseViewController *)controller{
    AccountPage *page = [[AccountPage alloc]init];
    [controller pushPage:page];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showSTNavigationBar:MSG_TITLE_ACCOUNT needback:YES];
    
    _viewModel = [[AccountViewModel alloc]init];
    _viewModel.delegate = self;
    
    _accountView = [[AccountView alloc]initWithViewModel:_viewModel];
    _accountView.backgroundColor = c04;
    _accountView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_accountView];
    
    [_accountView updateData];
//    [_viewModel getMyDetailData];
    
}

-(void)onRequestBegin{
    
}


-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
//    if(_accountView){
//        [_accountView updateData:data];
//    }
}

-(void)onRequestFail:(NSString *)msg{
    
}


@end
