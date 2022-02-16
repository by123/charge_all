////
////  ActiveDevicePage.m
////  manage
////
////  Created by by.huang on 2018/10/27.
////  Copyright © 2018年 by.huang. All rights reserved.
////
//
//#import "ActiveDevicePage.h"
//#import "ActiveDeviceView.h"
//#import "ScanPage.h"
//#import "MerchantUnBindPage.h"
//
//@interface ActiveDevicePage ()<ActiveDeviceViewDelegate>
//
//@property(strong, nonatomic)ActiveDeviceView *activeDeviceView;
//@property(assign, nonatomic)DeviceActiveType type;
//
//@end
//
//@implementation ActiveDevicePage
//
//+(void)show:(BaseViewController *)controller type:(DeviceActiveType)type{
//    ActiveDevicePage *page = [[ActiveDevicePage alloc]init];
//    page.type = type;
//    [controller pushPage:page];
//}
//
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self initView];
//}
//
//-(void)initView{
//    
//    [self showSTNavigationBar: _type == DeviceActiveType_Active  ? MENU_ACTIVE : MSG_TITLE_MERCHANT_BIND needback:YES];
//    
//    ActiveDeviceViewModel *viewModel = [[ActiveDeviceViewModel alloc]init];
//    viewModel.type = _type;
//    viewModel.delegate = self;
//
//    _activeDeviceView = [[ActiveDeviceView alloc]initWithViewModel:viewModel];
//    _activeDeviceView.backgroundColor = cwhite;
//    _activeDeviceView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
//    [self.view addSubview:_activeDeviceView];
//
//    
//}
//
//-(void)onRequestBegin{
//    
//}
//
//-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
//    if(_activeDeviceView){
//        [_activeDeviceView updateDatas:data];
//    }
//}
//
//-(void)onRequestFail:(NSString *)msg{
//    
//}
//
//-(void)onScanDevice:(NSString *)mchId mchName:(NSString *)mchName{
//    [ScanPage show:self type:ScanType_ACTIVE_DEVICE mchId:mchId mchName:mchName];
//}
//
//-(void)onGoMerchantBindPage:(MerchantModel *)model{
//    [MerchantUnBindPage show:self model:model];
//}
//
//@end
