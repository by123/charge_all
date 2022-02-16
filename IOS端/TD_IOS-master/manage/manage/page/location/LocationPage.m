////
////  LocationPage.m
////  manage
////
////  Created by by.huang on 2018/11/14.
////  Copyright © 2018 by.huang. All rights reserved.
////
//
//#import "LocationPage.h"
//#import "LocationView.h"
//#import "STObserverManager.h"
//@interface LocationPage()<LocationViewDelegate>
//
//@property(strong, nonatomic)LocationView *locationView;
//@property(strong, nonatomic)LocationViewModel *viewModel;
//
//@end
//
//@implementation LocationPage
//
//+(void)show:(BaseViewController *)controller{
//    LocationPage *page = [[LocationPage alloc]init];
//    [controller pushPage:page];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self showSTNavigationBar:MSG_LOCATION needback:YES];
//    [self initView];
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
//}
//
//-(void)initView{
//    _viewModel = [[LocationViewModel alloc]init];
//    _viewModel.delegate = self;
//    
//    _locationView =[[LocationView alloc]initWithViewModel:_viewModel];
//    _locationView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
//    [self.view addSubview:_locationView];
//    
//    UIButton *confirmBtn = [[UIButton alloc]initWithFont:STFont(14) text:MSG_CONFIRM textColor:c10 backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
//    confirmBtn.frame = CGRectMake(ScreenWidth - STWidth(15) - STWidth(56), StatuNavHeight-STHeight(38), STWidth(56), STHeight(30));
//    [confirmBtn addTarget:self action:@selector(onConfrimBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:confirmBtn];
//}
//
//-(void)onRequestBegin{
//    
//}
//
//-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
//    
//}
//
//-(void)onRequestFail:(NSString *)msg{
//    
//}
//
//-(void)onConfrimBtnClick{
//    if(!IS_NS_COLLECTION_EMPTY(_viewModel.datas)){
//        for(LocationModel *model in _viewModel.datas){
//            if(model.isSelect){
//                [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_POSITION msg:model.poi];
//                break;
//            }
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//       [LCProgressHUD showMessage:@"请选中一个位置"];
//    }
//}
//
//@end
//
