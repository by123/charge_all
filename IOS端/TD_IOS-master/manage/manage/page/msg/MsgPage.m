//
//  MsgPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MsgPage.h"
#import "MsgView.h"
#import "MsgDetailPage.h"
#import "MainPage.h"

@interface MsgPage()<MsgViewDelegate>

@property(strong, nonatomic)MsgView *msgView;
@property(strong, nonatomic)MsgViewModel *viewModel;

@end

@implementation MsgPage

+(void)show:(BaseViewController *)controller{
    MsgPage *page = [[MsgPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_MESSAGE needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[MsgViewModel alloc]init];
    _viewModel.delegate = self;
    
    _msgView =[[MsgView alloc]initWithViewModel:_viewModel];
    _msgView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_msgView];
    
    [_viewModel requestMsgList:YES];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [_msgView updateView];
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onRequestNoData:(Boolean)hasDatas{
    [_msgView updateNoDatas:hasDatas];
}

-(void)onGoMsgDetailPage:(NSString *)msgId{
    [MsgDetailPage show:self msgId:msgId];
}


-(void)backLastPage{
    if(self.navigationController.viewControllers.count == 1){
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:[MainPage new]];
        UIWindow * window = [[UIApplication sharedApplication].delegate window];
        window.rootViewController = navigationController;
        [window makeKeyAndVisible];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

