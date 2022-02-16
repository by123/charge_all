//
//  OrderSearchPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderSearchPage.h"
#import "OrderSearchView.h"
#import "RefundPage.h"
#import "OrderDetailPage.h"

@interface OrderSearchPage()<OrderSearchViewDelegate>

@property(strong, nonatomic)OrderSearchView *orderSearchView;
@property(strong, nonatomic)OrderSearchViewModel *viewModel;

@end

@implementation OrderSearchPage

+(void)show:(BaseViewController *)controller{
    OrderSearchPage *page = [[OrderSearchPage alloc]init];
    [controller pushPage:page];
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
    _viewModel = [[OrderSearchViewModel alloc]init];
    _viewModel.delegate = self;
    
    _orderSearchView =[[OrderSearchView alloc]initWithViewModel:_viewModel];
    _orderSearchView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight);
    [self.view addSubview:_orderSearchView];
    
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if(_orderSearchView){
        [_orderSearchView onRequestSuccess:respondModel data:data];
    }
}

-(void)onRequestFail:(NSString *)msg{
    if(_orderSearchView){
        [_orderSearchView onRequestFail:msg];
    }
}

-(void)onRequestNoData{
    if(_orderSearchView){
        [_orderSearchView onRequestNoData];
    }
}

-(void)onRequestNoData:(Boolean)hasDatas{
    if(_orderSearchView){
        [_orderSearchView onRequestNoData:hasDatas];
    }
}

-(void)onClosePage{
    [self backLastPage];
}


-(void)onGoRefundPage:(OrderModel *)orderModel{
    [RefundPage show:self orderModel:orderModel];
}

-(void)onGoOrderDetailPage:(NSString *)orderId{
    [OrderDetailPage show:self orderId:orderId];
}


@end

