//
//  OrderView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderView.h"
#import "STYearMonthLayerView.h"
#import "OrderViewModel.h"
#import "STPageView.h"
#import "OrderContentView.h"
#import "STObserverManager.h"
#import "TouchScrollView.h"
#import "STSinglePickerLayerView.h"
#import "MerchantModel.h"
#import "STNumUtil.h"

@interface OrderView()<STPageViewDelegate,OrderViewDelegate,STObserverProtocol,TouchScrollViewDelegate,STSinglePickerLayerViewDelegate>
//STYearMonthLayerViewDelegate
@property(strong, nonatomic)UILabel *monthLabel;
@property(strong, nonatomic)UIImageView *monthImageView;
@property(strong, nonatomic)UILabel *totalOrderLabel;
@property(strong, nonatomic)UILabel *totalMoneyLabel;
@property(strong, nonatomic)UILabel *moneyLabel;

//
@property(strong, nonatomic)OrderViewModel *viewModel;
@property(strong, nonatomic)NSMutableArray *mViews;
@property(strong, nonatomic)OrderContentView *mCurrentView;
@property(strong, nonatomic)MainViewModel *mMainViewModel;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(assign, nonatomic)NSInteger mCurrent;
@property(strong, nonatomic)STPageView *pageView;
@property(strong, nonatomic)UIView *titlebgView;
@property(strong, nonatomic)UIView *bgView;

//
@property(strong, nonatomic)UILabel *startLabel;
@property(strong, nonatomic)UILabel *endLabel;

@property(strong, nonatomic)UILabel *agentLabel;
@property(strong, nonatomic)STSinglePickerLayerView *layerView;
@property(strong, nonatomic)NSMutableArray *layerDatas;

@property(assign, nonatomic)NSInteger currentPosition;
@property(strong, nonatomic)UILabel *homeLabel;

@end

@implementation OrderView{
    CGFloat homeHeight;
    CGFloat bodyHeight;
}

-(instancetype)initWithViewModel:(MainViewModel *)mainViewModel{
    if(self == [super init]){
        _mMainViewModel = mainViewModel;
        _viewModel = [[OrderViewModel alloc]init];
        _viewModel.delegate = self;
        _mCurrent  = OrderType_All;
        if (@available(iOS 11.0, *)) {
            homeHeight = HomeIndicatorHeight;
        } else {
            homeHeight = 0;
        }
        bodyHeight = ScreenHeight - StatuBarHeight - STHeight(50) - homeHeight;
        [self initView];
        
        [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_ORDER delegate:self];
    }
    return self;
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_ORDER];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    [self updateView];
}


-(void)initView{
    [self initTitleView];
    
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:self];
    _scrollView.frame = CGRectMake(0, STHeight(52), ScreenWidth, bodyHeight - STHeight(52));
    _scrollView.userInteractionEnabled = YES;
    [_scrollView enableHeader];
    [_scrollView enableFooter];
    _scrollView.mj_footer.backgroundColor = cbg;
    [self addSubview:_scrollView];
    
    [self initTopView];
    
    _homeLabel = [[UILabel alloc]initWithFont:STFont(30) text:TAB_ORDER textAlignment:NSTextAlignmentLeft textColor:c21 backgroundColor:nil multiLine:NO];
    CGSize findPswSize = [TAB_ORDER sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    [_homeLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    _homeLabel.frame = CGRectMake(STWidth(15), STHeight(10), findPswSize.width, STHeight(42));
    [self addSubview:_homeLabel];
    
    [self initListView];
    
    _layerView = [[STSinglePickerLayerView alloc]initWithDatas:nil];
    _layerView.hidden = YES;
    _layerView.delegate = self;
    [self addSubview:_layerView];
    
    [self refreshNew];
}

-(void)initTitleView{
    _titlebgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(208))];
    _titlebgView.backgroundColor = c23;
    [self addSubview:_titlebgView];
}

-(void)initTopView{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(156))];
    if(IS_YELLOW_SKIN){
        _bgView.backgroundColor = c02;
    }else{
        [STColorUtil setGradientColor:_bgView startColor:c18 endColor:c19 director:Top];
    }
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(340), STHeight(8), STWidth(20), STWidth(20))];
    [searchBtn setImage:[UIImage imageNamed:IMAGE_SEARCH] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(onSearchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:searchBtn];
    //日期选择
    UIButton *dateBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(10), STWidth(220), STHeight(30))];
    [dateBtn addTarget:self action:@selector(onDateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:dateBtn];
    
    _startLabel = [[UILabel alloc]initWithFont:STFont(12) text:_viewModel.startDateStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:cwhite multiLine:NO];
    _startLabel.frame = CGRectMake(0, 0, STWidth(100), STHeight(30));
    [dateBtn addSubview:_startLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(105), STHeight(15)-LineHeight, STWidth(10), LineHeight)];
    lineView.backgroundColor = c_btn_txt_highlight;
    [dateBtn addSubview:lineView];
    
    _endLabel = [[UILabel alloc]initWithFont:STFont(12) text:_viewModel.endDateStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:cwhite multiLine:NO];
    _endLabel.frame = CGRectMake(STWidth(120), 0, STWidth(100), STHeight(30));
    [dateBtn addSubview:_endLabel];
    
    //代理商选择
    UIButton *agentBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(50), STWidth(220), STHeight(30))];
    agentBtn.backgroundColor = cwhite;
    [agentBtn addTarget:self action:@selector(onAgentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:agentBtn];
    
    //    [_viewModel queryAgentAndMerchant];
    
    _agentLabel = [[UILabel alloc]initWithFont:STFont(12) text:@"全部" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:cwhite multiLine:NO];
    CGSize agentSize = [_agentLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    _agentLabel.frame = CGRectMake(STWidth(7), 0, agentSize.width, STHeight(30));
    [agentBtn addSubview:_agentLabel];
    
    //
    _totalOrderLabel = [[UILabel alloc]initWithFont:STFont(18) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c21 backgroundColor:nil multiLine:NO];
    CGSize totalSize = [_totalOrderLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(18)];
    _totalOrderLabel.frame = CGRectMake(STWidth(15), STHeight(95), totalSize.width, STHeight(25));
    [_bgView addSubview:_totalOrderLabel];
    
    UILabel *orderLabel = [[UILabel alloc]initWithFont:STFont(14) text:TAB_ORDER textAlignment:NSTextAlignmentLeft textColor:c21 backgroundColor:nil multiLine:NO];
    CGSize orderSize = [TAB_ORDER sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    orderLabel.frame = CGRectMake(STWidth(15), STHeight(121), orderSize.width, STHeight(20));
    [_bgView addSubview:orderLabel];
    
    //
    _totalMoneyLabel = [[UILabel alloc]initWithFont:STFont(18) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c21 backgroundColor:nil multiLine:NO];
    CGSize totalMoneySize = [_totalMoneyLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(18)];
    _totalMoneyLabel.frame = CGRectMake(STWidth(94), STHeight(95), totalMoneySize.width, STHeight(25));
    [_bgView addSubview:_totalMoneyLabel];
    
    NSString *moneyStr = @"订单金额";
    _moneyLabel = [[UILabel alloc]initWithFont:STFont(14) text:moneyStr textAlignment:NSTextAlignmentLeft textColor:c21 backgroundColor:nil multiLine:NO];
    CGSize moneySize = [moneyStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _moneyLabel.frame = CGRectMake(STWidth(94), STHeight(121), moneySize.width, STHeight(20));
    [_bgView addSubview:_moneyLabel];
    
    [_scrollView addSubview:_bgView];
}


-(void)initListView{
    
    _mViews = [[NSMutableArray alloc]init];
    
    
    CGRect rect = CGRectMake(0, STHeight(38), ScreenWidth, bodyHeight - STHeight(208) - STHeight(38));
    
    OrderContentView *allView =[[OrderContentView alloc]initWithType:OrderType_All viewModel:_viewModel];
    allView.frame = rect;
    [_mViews addObject:allView];
    
    OrderContentView *waitPayView =[[OrderContentView alloc]initWithType:OrderType_WaitPay viewModel:_viewModel];
    waitPayView.frame = rect;
    [_mViews addObject:waitPayView];
    
    OrderContentView *paidView =[[OrderContentView alloc]initWithType:OrderType_Paid viewModel:_viewModel];
    paidView.frame = rect;
    [_mViews addObject:paidView];
    
    OrderContentView *completedView =[[OrderContentView alloc]initWithType:OrderType_Completed viewModel:_viewModel];
    completedView.frame = rect;
    [_mViews addObject:completedView];
    
    OrderContentView *cancelView =[[OrderContentView alloc]initWithType:OrderType_Cancel viewModel:_viewModel];
    cancelView.frame = rect;
    [_mViews addObject:cancelView];
    
    OrderContentView *refundingView =[[OrderContentView alloc]initWithType:OrderType_Refunding viewModel:_viewModel];
    refundingView.frame = rect;
    [_mViews addObject:refundingView];
    
    OrderContentView *refundedView =[[OrderContentView alloc]initWithType:OrderType_Refunded viewModel:_viewModel];
    refundedView.frame = rect;
    [_mViews addObject:refundedView];
    
    _mCurrentView = allView;
    
    NSArray *titles = @[@"全部",@"待支付",@"已支付",@"已完成",@"已取消",@"退款中",@"已退款"];
    
    _pageView = [[STPageView alloc]initWithFrame:CGRectMake(0, STHeight(156), ScreenWidth, bodyHeight - STHeight(208)) views:_mViews titles:titles];
    _pageView.delegate = self;
    [_scrollView addSubview:_pageView];
    
    [_pageView setCurrentTab:_mCurrent];
}


-(void)updateView{
    [_viewModel queryAgentAndMerchant];
    [_mCurrentView updateView];
}

-(void)onUpdateTotalStr:(NSString *)orderCount profit:(NSString *)profit{
    _totalOrderLabel.text = [NSString stringWithFormat:@"%@笔",[STNumUtil formatNumWithInt2P:[orderCount doubleValue]]];
    CGSize totalSize = [_totalOrderLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(18)];
    _totalOrderLabel.frame = CGRectMake(STWidth(15), STHeight(95), totalSize.width, STHeight(25));
    
    _totalMoneyLabel.text = [NSString stringWithFormat:@"%@元",[STNumUtil formatNumWith2P:[profit doubleValue]]];
    CGSize totalMoneySize = [_totalMoneyLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(18)];
    _totalMoneyLabel.frame = CGRectMake(STWidth(30)+totalSize.width, STHeight(95), totalMoneySize.width, STHeight(25));
    
    CGSize moneySize = [_moneyLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _moneyLabel.frame = CGRectMake(STWidth(30)+totalSize.width, STHeight(121), moneySize.width, STHeight(20));
    
}


-(void)onSearchBtnClicked{
    if(_mMainViewModel){
        [_mMainViewModel goOrderSearchPage];
    }
}

-(void)onGoOrderDetailPage:(NSString *)orderId{
    if(_mMainViewModel){
        [_mMainViewModel goOrderDetailPage:orderId];
    }
}

-(void)onGoRefundPage:(OrderModel *)model{
    if(_mMainViewModel){
        [_mMainViewModel goRefundPage:model];
    }
}

-(void)refreshNew{
    NSLog(@"上拉");
    [_mCurrentView updateCondition:_viewModel.startDate end:_viewModel.endDate model:_viewModel.model];
    [_mCurrentView refreshNew];
}



-(void)uploadMore{
    NSLog(@"下拉");
    [_mCurrentView updateCondition:_viewModel.startDate end:_viewModel.endDate model:_viewModel.model];
    [_mCurrentView uploadMore];
}


-(void)onUpdateUI:(int)type datas:(NSMutableArray *)datas{
    NSInteger count = [datas count];
    if(count == 0){
        [_pageView changeFrame:bodyHeight - STHeight(208)];
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, bodyHeight - STHeight(52))];
        return;
    }
    
    CGFloat height = 0;
    if(_mCurrent == OrderType_All){
        for(OrderModel *model in datas){
            if(model.orderStateWeb == OrderType_Paid || model.orderStateWeb == OrderType_Completed){
                //                height +=  STHeight(328);
                //            }else if(model.orderStateWeb == OrderType_Completed){
                height +=  STHeight(372);
            }else{
                height +=  STHeight(297);
            }
        }
    }else if(_mCurrent == OrderType_Paid || _mCurrent == OrderType_Completed){
        //        height = STHeight(328) * count;
        //    }else if(_mCurrent == OrderType_Completed){
        height = STHeight(372) * count;
    }else{
        height = STHeight(297) * count;
    }
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(156) + STHeight(38) + height + STHeight(15))];
    [_pageView changeFrame:STHeight(38) + height + STHeight(15)];
}

-(void)onScrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = self.scrollView.mj_offsetY;
    [STLog print:[NSString stringWithFormat:@"%.f",offsetY]];
    if(offsetY > STHeight(156)){
        [_pageView fastenTopView:offsetY - STHeight(156)];
        _bgView.alpha = 0.0f;
        _titlebgView.alpha = 0.0f;
        if(IS_RED_SKIN){
            _homeLabel.textColor = c10;
        }
        [self setStatuBarBgColor:[c23 colorWithAlphaComponent:0]];
        
    }else{
        [_pageView fastenTopView:0];
        CGFloat alpha = (STHeight(156) - offsetY)/STHeight(156);
        _bgView.alpha = alpha;
        _titlebgView.alpha = alpha;
        if(IS_RED_SKIN){
            _homeLabel.textColor = cwhite;
        }
        [self setStatuBarBgColor:[c23 colorWithAlphaComponent:alpha]];
    }
    //    NSLog(@"%.f",offsetY);
}


-(void)setStatuBarBgColor:(UIColor *)color{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIView *statusBar;
    if (@available(iOS 13.0, *)) {
        // iOS 13  弃用keyWindow属性  从所有windowl数组中取
        UIWindow *keyWindow = [UIApplication sharedApplication].windows[0];
        statusBar = [[UIView alloc] initWithFrame:keyWindow.windowScene.statusBarManager.statusBarFrame];
        [keyWindow addSubview:statusBar];
    } else {
        statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


-(void)onPageViewSelect:(NSInteger)position view:(id)view{
    if(_mCurrent == position){
        return;
    }
    _mCurrent = position;
    _mCurrentView = view;
    [self refreshNew];
}

-(void)onRefreshEnd{
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
}

-(void)noMoreData{
    [_scrollView noMoreData];
}

-(void)onDateBtnClick{
    [_mMainViewModel.delegate onOpenCalendar];
    [STLog print:@"日期选择"];
}

-(void)onAgentBtnClick{
    [STLog print:@"代理商选择"];
    _layerView.hidden = NO;
}

-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView position:(NSInteger)position{
    _currentPosition = position;
    _agentLabel.text = result;
    CGSize agentSize = [result sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    CGFloat width = agentSize.width;
    if(width > STWidth(206-14)){
        width = STWidth(206);
    }
    
    _agentLabel.frame = CGRectMake(STWidth(7), 0, width, STHeight(30));
    
    if(position == 0){
        _viewModel.model = [[MerchantModel alloc]init];
    }else{
        _viewModel.model = [_viewModel.queryDatas objectAtIndex:position-1];
    }
    [self updateView];
}

-(void)updateDate:(NSInteger)startDate end:(NSInteger)endDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
    NSString *startDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startDate]];
    NSString *endDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endDate]];
    _startLabel.text = startDateStr;
    _endLabel.text = endDateStr;
    _viewModel.startDateStr = startDateStr;
    _viewModel.endDateStr = endDateStr;
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    _viewModel.startDate = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startDate]];
    _viewModel.endDate = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endDate]];
    
    [self updateView];
}

-(void)onRequestBegin{}
-(void)onRequestFail:(NSString *)msg{}
-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if(!IS_NS_COLLECTION_EMPTY(_viewModel.queryDatas)){
        _layerDatas = [[NSMutableArray alloc]init];
        [_layerDatas addObject:@"全部"];
        for(MerchantModel *model in _viewModel.queryDatas){
            [_layerDatas addObject:model.mchName];
        }
        [_layerView updateDatas:_layerDatas];
    }
    
    _agentLabel.text = [_layerDatas objectAtIndex:_currentPosition];
    CGSize agentSize = [_agentLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    CGFloat width = agentSize.width;
    if(width > STWidth(206-14)){
        width = STWidth(206);
    }
    
    _agentLabel.frame = CGRectMake(STWidth(7), 0, width, STHeight(30));
}


@end

