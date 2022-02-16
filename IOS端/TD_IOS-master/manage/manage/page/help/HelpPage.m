//
//  HelpPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "HelpPage.h"
#import "HelpView.h"

@interface HelpPage()<HelpViewDelegate>

@property(strong, nonatomic)HelpView *helpView;
@property(strong, nonatomic)HelpViewModel *viewModel;

@end

@implementation HelpPage

+(void)show:(BaseViewController *)controller{
    HelpPage *page = [[HelpPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_HELP needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[HelpViewModel alloc]init];
    _viewModel.delegate = self;
    
    _helpView =[[HelpView alloc]initWithViewModel:_viewModel];
    _helpView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_helpView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [_helpView updateView];
}

-(void)onRequestFail:(NSString *)msg{
    
}


@end

