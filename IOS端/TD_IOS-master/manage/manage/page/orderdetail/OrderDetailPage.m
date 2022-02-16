//
//  OrderDetailPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderDetailPage.h"
#import "OrderDetailView.h"
#import "RefundPage.h"

@interface OrderDetailPage()<OrderDetailViewDelegate>

@property(strong, nonatomic)OrderDetailView *orderDetailView;
@property(strong, nonatomic)OrderDetailViewModel *viewModel;
@property(strong, nonatomic)NSString *mOrderId;

@end

@implementation OrderDetailPage

+(void)show:(BaseViewController *)controller orderId:(NSString *)orderId{
    OrderDetailPage *page = [[OrderDetailPage alloc]init];
    page.mOrderId = orderId;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_ORDER_DETAIL needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
    [_viewModel requestOrderDetail];

}

-(void)initView{
    _viewModel = [[OrderDetailViewModel alloc]init];
    _viewModel.orderId = _mOrderId;
    _viewModel.delegate = self;
    
    _orderDetailView =[[OrderDetailView alloc]initWithViewModel:_viewModel];
    _orderDetailView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_orderDetailView];
    
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [_orderDetailView updateView];
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onGoRefundPage:(OrderModel *)model{
    [RefundPage show:self orderModel:model];
}


@end

