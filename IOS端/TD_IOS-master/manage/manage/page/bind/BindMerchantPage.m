//
//  BindMerchatPage.m
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BindMerchantPage.h"
#import "BindMerchantView.h"
#import "MainPage.h"
#import "STAlertUtil.h"
#import "ScanPage.h"
#import "MerchantUnBindPage.h"

@interface BindMerchantPage ()<BindMerchantViewDelegate>

@property(copy, nonatomic)NSString *mOpenid;
@property(copy, nonatomic)NSString *mUnionid;
@property(copy, nonatomic)NSString *mType;
@property(assign, nonatomic)MerchantFromType mFrom;
@property(strong, nonatomic)BindMerchantViewModel *viewModel;
@property(strong, nonatomic)BindMerchantView *bindMerchantView;


@end

@implementation BindMerchantPage

+(void)show:(UIViewController *)controller openid:(NSString *)openid unionid:(NSString *)unionid type:(NSString *)type from:(MerchantFromType)from{
    BindMerchantPage *page = [[BindMerchantPage alloc]init];
    page.mOpenid = openid;
    page.mUnionid = unionid;
    page.mType = type;
    page.mFrom = from;
    [controller.navigationController pushViewController:page animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = MSG_TITLE_BIND_MERCHANT;
    if(_mFrom == MerchantFromType_ACTIVE){
        title = MENU_ACTIVE;
    }else if(_mFrom == MerchantFromType_UNBIND){
        title = MENU_UNBINDING;
    }
    [self showSTNavigationBar:title needback:YES];
    [self initView];
}

-(void)initView{
    
    _viewModel = [[BindMerchantViewModel alloc]init];
    _viewModel.delegate = self;
    _viewModel.openid = _mOpenid;
    _viewModel.unionid = _mUnionid;
    _viewModel.type = _mType;
    _viewModel.from = _mFrom;
    
    _bindMerchantView = [[BindMerchantView alloc]initWithViewModel:_viewModel];
    _bindMerchantView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_bindMerchantView];
    
    [_viewModel getMechantDatas:MSG_EMPTY refreshNew:YES];
}


-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl isEqualToString:URL_QUERY_All_AGENT_AND_MERCHANT]){
        [_bindMerchantView updateView];
    }else if([respondModel.requestUrl isEqualToString:URL_BIND_MERCHANT]){
        [self backLastPage];
        [LCProgressHUD showSuccess:MSG_BIND_MERCHANT_SUCCESS];
    }
}

-(void)onRequestFail:(NSString *)msg{
    [_bindMerchantView onRequestFail:msg];
}

-(void)onRequestNoData:(Boolean)hasDatas{
    [_bindMerchantView onRequestNoData:hasDatas];
}

-(void)backLastPage{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MainPage class]]) {
            MainPage *page =(MainPage *)controller;
            [self.navigationController popToViewController:page animated:YES];
        }
    }
}


-(void)onBindMerchant:(MerchantModel *)model{
    WS(weakSelf)
    NSString *content = [NSString stringWithFormat:MSG_BIND_MERCHANT_CONTENT,model.mchName,model.contactUser];
    [STAlertUtil showAlertController:MSG_TITLE_BIND_MERCHANT content:content controller:self confirm:^{
        [weakSelf.viewModel bindMerchant:model];
    }];

}

-(void)onScanDevice:(NSString *)mchId mchName:(NSString *)mchName{
    [ScanPage show:self type:ScanType_ACTIVE_DEVICE mchId:mchId mchName:mchName];
}

-(void)onGoMerchantUnBindPage:(MerchantModel *)model{
    [MerchantUnBindPage show:self model:model];
}

@end
