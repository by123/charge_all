//
//  AgreementPage.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AgreementPage.h"
#import "AgreementView.h"

@interface AgreementPage () 

@end

@implementation AgreementPage


+(void)show:(BaseViewController *)controller{
    AgreementPage *page = [[AgreementPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_AGREEMENT needback:YES];
    [self initView];
}

-(void)initView{
    AgreementView *agreementView = [[AgreementView alloc]init];
    agreementView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:agreementView];
}


@end
