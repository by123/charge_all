//
//  MainPage.m
//  bus
//
//  Created by by.huang on 2018/9/13.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "MainPage.h"
#import "MainView.h"
#import "MineView.h"
#import "ScanPage.h"
#import "StyleDIY.h"
#import "MerchantPage.h"
#import "AgentPage.h"
#import "SalemanPage.h"
#import "ChainPage.h"
#import "AccountPage.h"
#import "BankPage.h"
#import "ActiveDevicePage.h"
#import "SettingPage.h"
#import "WhiteListPage.h"
#import "ResetPage.h"
#import "TaxiPage.h"
#import "AchievePage.h"
#import "UnBindingPage.h"
#import "OrderView.h"
#import "CapitalView.h"
#import "AchievePage.h"
#import "MsgPage.h"
#import "OrderSearchPage.h"
#import "OrderDetailPage.h"
#import "RefundPage.h"
#import "HelpPage.h"
#import "STUserDefaults.h"
#import "WithdrawPage.h"
#import "WithdrawSuccessPage.h"
#import "WithdrawFailPage.h"
#import "AccountManager.h"
#import "MSSCalendarViewController.h"
#import "MSSCalendarDefine.h"
#import "STTimeUtil.h"
#import "AgentManagePage.h"
#import "CapitalDetailPage.h"
#import "STNetUtil.h"
#import "PerformancePage.h"
#import "BindMerchantPage.h"
#import "STObserverManager.h"
@interface MainPage ()<MainViewDelegate,UIGestureRecognizerDelegate,MSSCalendarViewControllerDelegate,STObserverProtocol>

@property(strong, nonatomic)MainView *mainView;
@property(strong, nonatomic)MineView *mineView;
@property(strong, nonatomic)OrderView *orderView;
@property(strong, nonatomic)CapitalView *capitalView;
@property(strong, nonatomic)MainViewModel *viewModel;


@end

@implementation MainPage{
    NSMutableArray *menuBtns;
    NSUInteger currentTab;
}


+(void)show:(BaseViewController *)controller{
    MainPage *page = [[MainPage alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:page];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initView];
    [self initMenuView];
    
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_NEW_MSG delegate:self];
//    [self getBroadcast];
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_NEW_MSG];
}


//-(void)getBroadcast{
//    NSString *result = [STUserDefaults getKeyValue:CONFIG_BROADCAST];
//    if(!IS_NS_STRING_EMPTY(result)){
//        NSDictionary *dic = [STConvertUtil jsonToDic:result];
//        NSString *imgUrl = [dic objectForKey:@"imgUrl"];
//        NSString *content = [dic objectForKey:@"content"];
//        if(!IS_NS_STRING_EMPTY(imgUrl) && !IS_NS_STRING_EMPTY(content)){
//            [_mainView updateBroadcast:imgUrl content:content];
//            [_capitalView updateBroadcast:imgUrl content:content];
//        }
//    }
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.childViewControllers.count > 1;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_mainView){
        [_mainView updateNewMsg];
    }
    if(currentTab == 2){
        [self setStatuBarBackgroud:c23 style:UIStatusBarStyleDefault];
    }else{
        [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
    }

}


-(void)initView{

    _viewModel = [[MainViewModel alloc]init];
    _viewModel.delegate = self;
    
    [self.view addSubview:[self mainView]];
    [self.view addSubview:[self capitalView]];
    [self.view addSubview:[self orderView]];
    [self.view addSubview:[self mineView]];

    
    _mineView.hidden = YES;
    _capitalView.hidden = YES;
    _orderView.hidden = YES;
    [self setStatuBarBackgroud:c23 style:UIStatusBarStyleDefault];

    [_viewModel getHomeData];

}

-(MainView *)mainView{
    if(_mainView == nil){
        _mainView = [[MainView alloc]initWithViewModel:_viewModel];
        if (@available(iOS 11.0, *)) {
            _mainView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight-HomeIndicatorHeight);
        } else {
            _mainView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight);
        }
    }
    return _mainView;
}

-(MineView *)mineView{
    if(_mineView == nil){
        _mineView = [[MineView alloc]initWithViewModel:_viewModel];
        if (@available(iOS 11.0, *)) {
            _mineView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight-HomeIndicatorHeight);
        } else {
            _mineView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight);
        }
    }
    return _mineView;
}


-(OrderView *)orderView{
    if(_orderView == nil){
        _orderView = [[OrderView alloc]initWithViewModel:_viewModel];
        if (@available(iOS 11.0, *)) {
            _orderView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight-HomeIndicatorHeight);
        } else {
            _orderView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight);
        }
    }
    return _orderView;
}

-(CapitalView *)capitalView{
    if(_capitalView == nil){
        _capitalView = [[CapitalView alloc]initWithViewModel:_viewModel];
        if (@available(iOS 11.0, *)) {
            _capitalView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight-HomeIndicatorHeight);
        } else {
            _capitalView.frame = CGRectMake(0, StatuBarHeight, ScreenWidth, ScreenHeight - StatuBarHeight);
        }
    }
    return _capitalView;
}




-(void)initMenuView{
    
    CGFloat homeHeight = 0;
    if (@available(iOS 11.0, *)) {
        homeHeight = HomeIndicatorHeight;
    } else {
        homeHeight = 0;
    }
    
    menuBtns = [[NSMutableArray alloc]init];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-STHeight(50) + LineHeight - homeHeight, ScreenWidth, LineHeight)];
    lineView.backgroundColor = cline;
    [self.view addSubview:lineView];
    
    //代理商四个tab
    NSArray *titles = @[TAB_HOME,TAB_CAPITAL,TAB_ORDER,TAB_MINE];
    NSArray *imgSrcs = @[IMAGE_HOME_NORMAL,IMAGE_HOME_PRESSED,
                         IMAGE_CAPITAL_NORMAL,IMAGE_CAPITAL_PRESSED,
                         IMAGE_ORDER_NORMAL,IMAGE_ORDER_PRESSED,
                         IMAGE_MINE_NORMAL,IMAGE_MINE_PRESSED];
    
    NSString *setting = [STUserDefaults getKeyValue:UD_SETTING];
    //tester两个tab
    if([setting isEqualToString:LIMIT_CLOSE]){
        titles = @[TAB_HOME,TAB_MINE];
        imgSrcs = @[IMAGE_HOME_NORMAL,IMAGE_HOME_PRESSED,
                    IMAGE_MINE_NORMAL,IMAGE_MINE_PRESSED];
    }
    
    //业务员三个tab
    UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];
    if(userModel.roleType == 2 || userModel.roleType == 3){
        titles = @[TAB_HOME,TAB_ORDER,TAB_MINE];
        imgSrcs = @[IMAGE_HOME_NORMAL,IMAGE_HOME_PRESSED,
                    IMAGE_ORDER_NORMAL,IMAGE_ORDER_PRESSED,
                    IMAGE_MINE_NORMAL,IMAGE_MINE_PRESSED];

    }
    for(int i = 0 ; i < titles.count ; i ++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * ScreenWidth/titles.count, ScreenHeight-STHeight(50) - homeHeight,ScreenWidth/ titles.count , STHeight(50))];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:(i == 0 ? c10 : c05) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:STFont(12)];
        if(i == 0){
            [button setImage:[UIImage imageNamed:imgSrcs[1]] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:imgSrcs[i * 2]] forState:UIControlStateNormal];
        }
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height+STHeight(3) ,-button.imageView.frame.size.width, 0.0,0.0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(-STHeight(10), 0.0,0.0, -button.titleLabel.bounds.size.width)];
        [button addTarget:self action:@selector(onMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [menuBtns addObject:button];
        
    }
}



-(void)onGoScanPage{
    [ScanPage show:self type:ScanType_BIND_MERCHANT mchId:MSG_EMPTY mchName:MSG_EMPTY];
}

-(void)onGoActiveDevice{
    [BindMerchantPage show:self openid:MSG_EMPTY unionid:MSG_EMPTY type:MSG_EMPTY from:MerchantFromType_ACTIVE];
//    [ActiveDevicePage show:self type:DeviceActiveType_Active];
}

-(void)onGoTaxi{
    [TaxiPage show:self];
}

-(void)onGoAddMerchat{
    [MerchantPage show:self];
}

-(void)onGoAddAgent{
    [AgentPage show:self];
}

-(void)onGoAddSaleman{
   [SalemanPage show:self];
}

-(void)onGoAddChain{
    [ChainPage show:self];
}

-(void)onGoAccountDetail{
    [AccountPage show:self];
}

-(void)onGogoBankDetail{
    [BankPage show:self];
}

-(void)onGoAppSettingPage{
    [SettingPage show:self];
}

-(void)onGoWhiteListPage{
    [WhiteListPage show:self];
}

-(void)onGoResetPage{
    [ScanPage show:self type:ScanType_RESET_PSW mchId:MSG_EMPTY mchName:MSG_EMPTY];
}

-(void)onGoArchievePage:(NSInteger)tab{
//    [AchievePage show:self tab:tab];
    [PerformancePage show:self];
}

-(void)onGoMsgPage{
    [STUserDefaults saveKeyValue:UD_NEW_MSG value:@"0"];
    [MsgPage show:self];
}

-(void)onGoOrderSearchPage{
    [OrderSearchPage show:self];
}


-(void)onGoOrderDetailPage:(NSString *)orderId{
    [OrderDetailPage show:self orderId:orderId];
}


-(void)onGoRefundPage:(OrderModel *)model{
    [RefundPage show:self orderModel:model];
}

-(void)onGoHelpPage{
    [HelpPage show:self];
}

-(void)onGoUnBindingPage{
    [UnBindingPage show:self];
}

-(void)onGoWithdrawPage:(CapitalModel *)model{
    [WithdrawPage show:self model:model];
}

-(void)onGoWithdrawSuccessPage:(NSString *)withdrawId{
    [WithdrawSuccessPage show:self withdrawId:withdrawId];
}

-(void)onGoWithdrawFailPage:(NSString *)withdrawId{
    [WithdrawFailPage show:self withdrawId:withdrawId];
}

-(void)onGoAgentManagePage{
    [AgentManagePage show:self];
}

-(void)onGoCapitalDetailPage:(NSString *)date{
    [CapitalDetailPage show:self date:date];
}

-(void)onOpenCalendar{
    MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
    cvc.limitMonth = 12 * 5;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerLastType;
    cvc.beforeTodayCanTouch = YES;// 今天之后的日期是否可以点击
    cvc.afterTodayCanTouch = NO;// 今天之前的日期是否可以点击
    //cvc.startDate = [STTimeUtil getCurrentTimeStamp];// 选中开始时间
    //cvc.endDate = _endDate;// 选中结束时间
    /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
    cvc.showChineseHoliday = YES;// 是否展示农历节日
    cvc.showChineseCalendar = YES;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = YES;// 是否显示提示弹窗
    cvc.delegate = self;
    [self presentViewController:cvc animated:YES completion:nil];
}

- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate
{
    [_orderView updateDate:startDate end:endDate];
}


-(void)onMenuClicked:(id)sender{
    NSInteger tag = ((UIButton *)sender).tag;
    currentTab = tag;
    if(!IS_NS_COLLECTION_EMPTY(menuBtns)){
        NSString *setting = [STUserDefaults getKeyValue:UD_SETTING];
        UIButton *homeBtn;
        UIButton *moneyBtn;
        UIButton *orderBtn;
        UIButton *mineBtn;
        if([setting isEqualToString:LIMIT_OPEN]){
            UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];
            if(userModel.roleType == 2 || userModel.roleType == 3){
                homeBtn = [menuBtns objectAtIndex:0];
                orderBtn = [menuBtns objectAtIndex:1];
                mineBtn = [menuBtns objectAtIndex:2];
            }else{
                homeBtn = [menuBtns objectAtIndex:0];
                moneyBtn = [menuBtns objectAtIndex:1];
                orderBtn = [menuBtns objectAtIndex:2];
                mineBtn = [menuBtns objectAtIndex:3];
            }
        }else{
            homeBtn = [menuBtns objectAtIndex:0];
            mineBtn = [menuBtns objectAtIndex:1];
        }


        if(tag == 0){
            [homeBtn setTitleColor:c10 forState:UIControlStateNormal];
            [homeBtn setImage:[UIImage imageNamed:IMAGE_HOME_PRESSED] forState:UIControlStateNormal];
            
            [moneyBtn setTitleColor:c05 forState:UIControlStateNormal];
            [moneyBtn setImage:[UIImage imageNamed:IMAGE_CAPITAL_NORMAL] forState:UIControlStateNormal];
            
            [orderBtn setTitleColor:c05 forState:UIControlStateNormal];
            [orderBtn setImage:[UIImage imageNamed:IMAGE_ORDER_NORMAL] forState:UIControlStateNormal];
            
            [mineBtn setTitleColor:c05 forState:UIControlStateNormal];
            [mineBtn setImage:[UIImage imageNamed:IMAGE_MINE_NORMAL] forState:UIControlStateNormal];
            
            _mainView.hidden = NO;
            _capitalView.hidden = YES;
            _orderView.hidden = YES;
            _mineView.hidden = YES;

            [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
            
            [_mainView updateView];


        }else if(tag == 1){
            if([setting isEqualToString:LIMIT_OPEN]){
                UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];
                if(userModel.roleType == 2 || userModel.roleType == 3){
                    [homeBtn setTitleColor:c05 forState:UIControlStateNormal];
                    [homeBtn setImage:[UIImage imageNamed:IMAGE_HOME_NORMAL] forState:UIControlStateNormal];
                
                    [orderBtn setTitleColor:c10 forState:UIControlStateNormal];
                    [orderBtn setImage:[UIImage imageNamed:IMAGE_ORDER_PRESSED] forState:UIControlStateNormal];
                    
                    [mineBtn setTitleColor:c05 forState:UIControlStateNormal];
                    [mineBtn setImage:[UIImage imageNamed:IMAGE_MINE_NORMAL] forState:UIControlStateNormal];
                    
                    _mainView.hidden = YES;
                    _orderView.hidden = NO;
                    _mineView.hidden = YES;
                    [self setStatuBarBackgroud:c23 style:UIStatusBarStyleDefault];
                    
                    [_orderView updateView];
                }else{
                    [homeBtn setTitleColor:c05 forState:UIControlStateNormal];
                    [homeBtn setImage:[UIImage imageNamed:IMAGE_HOME_NORMAL] forState:UIControlStateNormal];
                    
                    [moneyBtn setTitleColor:c10 forState:UIControlStateNormal];
                    [moneyBtn setImage:[UIImage imageNamed:IMAGE_CAPITAL_PRESSED] forState:UIControlStateNormal];
                    
                    [orderBtn setTitleColor:c05 forState:UIControlStateNormal];
                    [orderBtn setImage:[UIImage imageNamed:IMAGE_ORDER_NORMAL] forState:UIControlStateNormal];
                    
                    [mineBtn setTitleColor:c05 forState:UIControlStateNormal];
                    [mineBtn setImage:[UIImage imageNamed:IMAGE_MINE_NORMAL] forState:UIControlStateNormal];
                    
                    _mainView.hidden = YES;
                    _capitalView.hidden = NO;
                    _orderView.hidden = YES;
                    _mineView.hidden = YES;
                    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
                    
                    [_capitalView updateView];
                }
               
              
            }else{
             
                [homeBtn setTitleColor:c05 forState:UIControlStateNormal];
                [homeBtn setImage:[UIImage imageNamed:IMAGE_HOME_NORMAL] forState:UIControlStateNormal];
                
                [mineBtn setTitleColor:c10 forState:UIControlStateNormal];
                [mineBtn setImage:[UIImage imageNamed:IMAGE_MINE_PRESSED] forState:UIControlStateNormal];
                
                _mainView.hidden = YES;
                _capitalView.hidden = YES;
                _orderView.hidden = YES;
                _mineView.hidden = NO;
                
                [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
                
                [_mineView updateView];

            }
            
        }else if(tag == 2){
            UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];
            if(userModel.roleType == 2 || userModel.roleType == 3){
                [homeBtn setTitleColor:c05 forState:UIControlStateNormal];
                [homeBtn setImage:[UIImage imageNamed:IMAGE_HOME_NORMAL] forState:UIControlStateNormal];
                
                [orderBtn setTitleColor:c05 forState:UIControlStateNormal];
                [orderBtn setImage:[UIImage imageNamed:IMAGE_ORDER_NORMAL] forState:UIControlStateNormal];
                
                [mineBtn setTitleColor:c10 forState:UIControlStateNormal];
                [mineBtn setImage:[UIImage imageNamed:IMAGE_MINE_PRESSED] forState:UIControlStateNormal];
                
                _mainView.hidden = YES;
                _orderView.hidden = YES;
                _mineView.hidden = NO;
                
                [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
                [_mineView updateView];
            }else{
                [homeBtn setTitleColor:c05 forState:UIControlStateNormal];
                [homeBtn setImage:[UIImage imageNamed:IMAGE_HOME_NORMAL] forState:UIControlStateNormal];
                
                [moneyBtn setTitleColor:c05 forState:UIControlStateNormal];
                [moneyBtn setImage:[UIImage imageNamed:IMAGE_CAPITAL_NORMAL] forState:UIControlStateNormal];
                
                [orderBtn setTitleColor:c10 forState:UIControlStateNormal];
                [orderBtn setImage:[UIImage imageNamed:IMAGE_ORDER_PRESSED] forState:UIControlStateNormal];
                
                [mineBtn setTitleColor:c05 forState:UIControlStateNormal];
                [mineBtn setImage:[UIImage imageNamed:IMAGE_MINE_NORMAL] forState:UIControlStateNormal];
                
                _mainView.hidden = YES;
                _capitalView.hidden = YES;
                _orderView.hidden = NO;
                _mineView.hidden = YES;
                
                [self setStatuBarBackgroud:c23 style:UIStatusBarStyleDefault];
         
                [_orderView updateView];
            }
            
        }else if(tag == 3){
            [homeBtn setTitleColor:c05 forState:UIControlStateNormal];
            [homeBtn setImage:[UIImage imageNamed:IMAGE_HOME_NORMAL] forState:UIControlStateNormal];
            
            [moneyBtn setTitleColor:c05 forState:UIControlStateNormal];
            [moneyBtn setImage:[UIImage imageNamed:IMAGE_CAPITAL_NORMAL] forState:UIControlStateNormal];
            
            [orderBtn setTitleColor:c05 forState:UIControlStateNormal];
            [orderBtn setImage:[UIImage imageNamed:IMAGE_ORDER_NORMAL] forState:UIControlStateNormal];
            
            [mineBtn setTitleColor:c10 forState:UIControlStateNormal];
            [mineBtn setImage:[UIImage imageNamed:IMAGE_MINE_PRESSED] forState:UIControlStateNormal];
            
            _mainView.hidden = YES;
            _capitalView.hidden = YES;
            _orderView.hidden = YES;
            _mineView.hidden = NO;
            
            [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
            
            [_mineView updateView];
            
        }
    }
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if(_mainView){
        [_mainView updateData:data];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}


-(void)onReciveResult:(NSString *)key msg:(id)msg{
    if([key isEqualToString:NOTIFY_NEW_MSG]){
        [_mainView updateNewMsg];
    }
}




@end
