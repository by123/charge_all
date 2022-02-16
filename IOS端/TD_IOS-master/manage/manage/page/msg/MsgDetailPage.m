//
//  MsgDetailPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MsgDetailPage.h"
#import "MsgDetailView.h"

@interface MsgDetailPage()<MsgDetailViewDelegate>

@property(strong, nonatomic)MsgDetailView *msgDetailView;
@property(strong, nonatomic)MsgDetailViewModel *viewModel;

@end

@implementation MsgDetailPage

+(void)show:(BaseViewController *)controller msgId:(NSString *)msgId{
    MsgDetailPage *page = [[MsgDetailPage alloc]init];
    page.msgId = msgId;
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
    _viewModel = [[MsgDetailViewModel alloc]init];
    _viewModel.delegate = self;
    _viewModel.msgId = _msgId;
    
    _msgDetailView =[[MsgDetailView alloc]initWithViewModel:_viewModel];
    _msgDetailView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_msgDetailView];
    
    [_viewModel requesMsgDetail];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [_msgDetailView updateView];
}

-(void)onRequestFail:(NSString *)msg{
    
}


@end

