//
//  RefundPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "RefundPage.h"
#import "RefundView.h"
#import "STObserverManager.h"

@interface RefundPage()<RefundViewDelegate>

@property(strong, nonatomic)RefundView *refundView;
@property(strong, nonatomic)RefundViewModel *viewModel;
@property(strong, nonatomic)OrderModel *orderModel;


@end

@implementation RefundPage

+(void)show:(BaseViewController *)controller orderModel:(OrderModel *)orderModel{
    RefundPage *page = [[RefundPage alloc]init];
    page.orderModel = orderModel;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_REFUND needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[RefundViewModel alloc]init];
    _viewModel.model = _orderModel;
    _viewModel.delegate = self;
    
    _refundView =[[RefundView alloc]initWithViewModel:_viewModel];
    _refundView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_refundView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_REFUND]){
        [LCProgressHUD showSuccess:MSG_REFUND_SUCCESS];
        [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_ORDER msg:nil];
        WS(weakSelf)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf backLastPage];
        });
    }
}

-(void)onRequestFail:(NSString *)msg{

}


@end

