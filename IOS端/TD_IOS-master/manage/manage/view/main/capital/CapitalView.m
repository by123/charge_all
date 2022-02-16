//
//  CapitalView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "CapitalView.h"
#import "CapitalContentView.h"
#import "WithdrawContentView.h"
#import "STRightPageView.h"
#import "CapitalViewModel.h"
#import "STUserDefaults.h"
#import "TouchScrollView.h"
#import "STNumUtil.h"
#import "ZScrollLabel.h"
#import "STYearMonthLayerView.h"
#import "NewYearView.h"
#import "STTimeUtil.h"
#import "BubbleLayer.h"
#import "STEdgeLabel.h"


@interface CapitalView()<CapitalViewDelegate,TouchScrollViewDelegate,STRightPageViewDelegate,STYearMonthLayerViewDelegate,NewYearViewDelegate>

@property(strong, nonatomic)CapitalViewModel *mViewModel;
@property(strong, nonatomic)UILabel *withdrawLabel;
@property(strong, nonatomic)UILabel *balanceLabel;
@property(strong, nonatomic)UILabel *totalLabel;

@property(strong, nonatomic)CapitalContentView *profitView;
@property(strong, nonatomic)WithdrawContentView *withdrawView;
@property(strong, nonatomic)MainViewModel *mainViewModel;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)STRightPageView *pageView;
@property(assign, nonatomic)NSInteger mCurrent;
@property(strong, nonatomic)UILabel *monthLabel;
@property(strong, nonatomic)UIImageView *monthImageView;
@property(strong, nonatomic)STYearMonthLayerView *layerView;
@property(strong, nonatomic)UIButton *monthBtn;
@property(strong, nonatomic)STEdgeLabel *freezeTipsLabel;
@property(strong, nonatomic)UIButton *freezeBtn;

@property(strong, nonatomic)NewYearView *mNewYearView;
@property(assign, nonatomic)CGFloat newYearHeight;


@end

@implementation CapitalView

-(instancetype)initWithViewModel:(MainViewModel *)mainViewModel{
    if(self == [super init]){
        _mainViewModel = mainViewModel;
        _mViewModel = [[CapitalViewModel alloc]init];
        _mViewModel.mainViewModel = mainViewModel;
        _mViewModel.delegate = self;
        _mCurrent  = CapitalType_Profit;
        _newYearHeight = 0;
        [self initView];
        [_mViewModel reqeustCapitalList:YES];
    }
    return self;
}

-(void)initView{
    NSString *homeStr = TAB_CAPITAL;
    UILabel *homeLabel = [[UILabel alloc]initWithFont:STFont(30) text:homeStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize findPswSize = [homeStr sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    [homeLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    homeLabel.frame = CGRectMake(STWidth(15), 0, findPswSize.width, STHeight(62));
    [self addSubview:homeLabel];
    
    
    UIButton *helpBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(283-15), STHeight(10), STWidth(92), STHeight(42))];
    [helpBtn addTarget:self action:@selector(onHelpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:helpBtn];
    
    UILabel *helpLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"资金帮助" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize helpSize = [helpLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    helpLabel.frame = CGRectMake(STWidth(92)-STWidth(12.4)-STWidth(4)-helpSize.width, 0, helpSize.width, STHeight(42));
    [helpBtn addSubview:helpLabel];
    
    UIImageView *helpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(92)-  STWidth(12.4), (STHeight(42) - STWidth(7.2))/2, STWidth(12.4), STWidth(7.2))];
    helpImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    helpImageView.contentMode = UIViewContentModeScaleAspectFill;
    [helpBtn addSubview:helpImageView];
    
    
    CGFloat homeHeight = 0;
    if (@available(iOS 11.0, *)) {
        homeHeight = HomeIndicatorHeight;
    } else {
        homeHeight = 0;
    }
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:self];
    _scrollView.frame = CGRectMake(0, STHeight(62), ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(62) - STHeight(50) - homeHeight);
    [_scrollView enableHeader];
    [_scrollView enableFooter];
    [self addSubview:_scrollView];

    [self initTopView];
    [self initFestivalView];
    [self initBody];
    
    _layerView = [[STYearMonthLayerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _layerView.hidden = YES;
    _layerView.delegate = self;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_layerView];
    [_layerView setData:[NSString stringWithFormat:@"%d",_mViewModel.year] month:[NSString stringWithFormat:@"%d",_mViewModel.month]];
}


-(void)initTopView{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), STHeight(175))];
    topView.layer.cornerRadius = 2;
    if(IS_RED_SKIN){
        [STColorUtil setGradientColor:topView startColor:c16 endColor:c17 director:Left];
    }else{
        topView.backgroundColor = c02;
        topView.layer.shadowRadius = 8;
        topView.layer.shadowOffset = CGSizeMake(0, 8);
        topView.layer.shadowOpacity = 0.8;
        topView.layer.shadowColor = c02.CGColor;
    }
    [_scrollView addSubview:topView];
    
    UILabel *withdrawTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_CAN_TX textAlignment:NSTextAlignmentLeft textColor:IS_YELLOW_SKIN ? c10 : cwhite backgroundColor:nil multiLine:NO];
    CGSize topTitleSize = [withdrawTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_REGULAR];
    [withdrawTitleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:STFont(15)]];
    withdrawTitleLabel.frame = CGRectMake(STWidth(15), STHeight(20), topTitleSize.width, STHeight(21));
    [topView addSubview:withdrawTitleLabel];

    
    _withdrawLabel = [[UILabel alloc]initWithFont:STFont(30) text:@"0.00" textAlignment:NSTextAlignmentLeft textColor:IS_YELLOW_SKIN ? c10 : cwhite backgroundColor:nil multiLine:NO];
    CGSize withdrawSize = [_withdrawLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    [_withdrawLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    _withdrawLabel.frame = CGRectMake(STWidth(15), STHeight(42), withdrawSize.width, STHeight(42));
    [topView addSubview:_withdrawLabel];
    
    _freezeBtn = [[UIButton alloc]init];
    _freezeBtn.frame = CGRectMake(STWidth(25)+withdrawSize.width, STHeight(60), STWidth(16), STHeight(16));
    [_freezeBtn setImage:[UIImage imageNamed:@"ic_冻结提示"] forState:UIControlStateNormal];
    _freezeBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_freezeBtn addTarget:self action:@selector(onFreezeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_freezeBtn];
    
    
    
    _freezeTipsLabel = [[STEdgeLabel alloc]initWithFont:STFont(12) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:cwhite backgroundColor:[c11 colorWithAlphaComponent:0.5f] multiLine:NO];
    _freezeTipsLabel.hidden = YES;
    [topView addSubview:_freezeTipsLabel];
    
   

    
    UILabel *balanceTitleLabel =  [[UILabel alloc]initWithFont:STFont(15) text:@"账户余额" textAlignment:NSTextAlignmentLeft textColor:IS_YELLOW_SKIN ? c10 : cwhite backgroundColor:nil multiLine:NO];
    CGSize balanceTitleSize = [balanceTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_REGULAR];
    [balanceTitleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:STFont(15)]];
    balanceTitleLabel.frame = CGRectMake(STWidth(15), STHeight(98), balanceTitleSize.width, STHeight(21));
    [topView addSubview:balanceTitleLabel];
    
    _balanceLabel = [[UILabel alloc]initWithFont:STFont(20) text:@"0.00" textAlignment:NSTextAlignmentLeft textColor:IS_YELLOW_SKIN ? c10 : cwhite backgroundColor:nil multiLine:NO];
    CGSize balanceSize = [_balanceLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(20) fontName:FONT_MIDDLE];
    [_balanceLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    _balanceLabel.frame = CGRectMake(STWidth(15), STHeight(120), balanceSize.width, STHeight(28));
    [topView addSubview:_balanceLabel];
    
    UILabel *totalTitleLabel =  [[UILabel alloc]initWithFont:STFont(15) text:@"累计收益" textAlignment:NSTextAlignmentLeft textColor:IS_YELLOW_SKIN ? c10 : cwhite backgroundColor:nil multiLine:NO];
    CGSize totalTitleSize = [totalTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_REGULAR];
    [totalTitleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:STFont(15)]];
    totalTitleLabel.frame = CGRectMake(STWidth(135), STHeight(98), totalTitleSize.width, STHeight(21));
    [topView addSubview:totalTitleLabel];
    
    _totalLabel = [[UILabel alloc]initWithFont:STFont(20) text:@"0.00" textAlignment:NSTextAlignmentLeft textColor:IS_YELLOW_SKIN ? c10 : cwhite backgroundColor:nil multiLine:NO];
    CGSize totalSize = [_totalLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(20) fontName:FONT_MIDDLE];
    [_totalLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    _totalLabel.frame = CGRectMake(STWidth(135), STHeight(120), totalSize.width, STHeight(28));
    [topView addSubview:_totalLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(104), STHeight(115), LineHeight, STHeight(18))];
    lineView.backgroundColor = IS_YELLOW_SKIN ? c10 : cwhite;
    [topView addSubview:lineView];
    

    UIButton *withdrawBtn = [[UIButton alloc]initWithFont:STFont(16) text:MSG_TX textColor:IS_YELLOW_SKIN ? c10 : c20 backgroundColor:cwhite corner:2 borderWidth:0 borderColor:nil];
    withdrawBtn.layer.shadowRadius = 1;
    withdrawBtn.layer.shadowOffset = CGSizeMake(1, 1);
    withdrawBtn.layer.shadowOpacity = 0.8;
    withdrawBtn.layer.shadowColor = c01.CGColor;
    withdrawBtn.frame = CGRectMake(STWidth(230), STHeight(35), STWidth(100), STHeight(40));
    [withdrawBtn addTarget:self action:@selector(onWithdrawClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:withdrawBtn];


    
    UIImageView *bagImageView= [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(259), STHeight(105), STWidth(86), STWidth(41))];
    bagImageView.image = [UIImage imageNamed:IMAGE_BAG];
    bagImageView.contentMode = UIViewContentModeScaleAspectFill;
    [topView addSubview:bagImageView];
}



-(void)initFestivalView{
    _mNewYearView = [[NewYearView alloc]init];
    _mNewYearView.delegate = self;
    _mNewYearView.frame = CGRectMake(STWidth(23), STHeight(190), STWidth(330), _newYearHeight);
    _mNewYearView.hidden = YES;
    [_scrollView addSubview:_mNewYearView];
}

-(void)initBody{
    
    _profitView = [[CapitalContentView alloc]initWithViewModel:_mViewModel];
    _profitView.frame = CGRectMake(0, STHeight(38), ScreenWidth, 0);
    
    _withdrawView = [[WithdrawContentView alloc]initWithViewModel:_mViewModel];
    _withdrawView.frame = CGRectMake(0, STHeight(38), ScreenWidth,0);
    
    NSMutableArray *views = [[NSMutableArray alloc]init];
    [views addObject:_profitView];
    [views addObject:_withdrawView];
    
    //隐藏功能
    NSArray *titles = @[MSG_SY_DETAIL,MSG_TX_DETAIL];

    CGFloat homeHeight = 0;
    if (@available(iOS 11.0, *)) {
        homeHeight = HomeIndicatorHeight;
    } else {
        homeHeight = 0;
    }
    
    _pageView = [[STRightPageView alloc]initWithFrame:CGRectMake(0, STHeight(205) + _newYearHeight, ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(62)-STHeight(175)-STHeight(30) - STHeight(50) - homeHeight -_newYearHeight) views:views titles:titles perLine:0.8];
    _pageView.delegate = self;
    [_scrollView addSubview:_pageView];
    
    
    [self initMonthView];

    [_pageView setCurrentTab:0];

    

}

-(void)initMonthView{
    _monthBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, STHeight(205) + _newYearHeight, ScreenWidth/3, STHeight(38))];
    [_monthBtn addTarget:self action:@selector(onMonthClicked) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_monthBtn];
    
    _monthLabel = [[UILabel alloc]initWithFont:STFont(16) text:[STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy年MM月"] textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize monthSize = [_monthLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(16) fontName:FONT_MIDDLE];
    _monthLabel.frame = CGRectMake(STWidth(15), 0, monthSize.width, STHeight(38));
    [_monthLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(16)]];
    [_monthBtn addSubview:_monthLabel];
    
    _monthImageView = [[UIImageView alloc]initWithFrame:CGRectMake(monthSize.width + STWidth(25), (STHeight(38) - STWidth(13))/2, STWidth(13), STWidth(13))];
    _monthImageView.image = [UIImage imageNamed:IMAGE_REFRESH];
    _monthImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_monthBtn addSubview:_monthImageView];
}


-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_CAPITAL_LIST]){
        _withdrawLabel.text = [NSString stringWithFormat:@"%@",[STNumUtil formatNumWith2P:_mViewModel.model.canWithdrawNum]];
        CGSize withdrawSize = [_withdrawLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
       _withdrawLabel.frame = CGRectMake(STWidth(15), STHeight(42), withdrawSize.width, STHeight(42));
        _freezeBtn.frame = CGRectMake(STWidth(25)+withdrawSize.width, STHeight(60), STWidth(16), STHeight(16));

        _balanceLabel.text = [NSString stringWithFormat:@"%@",[STNumUtil formatNumWith2P:_mViewModel.model.balanceAmount]];
        CGSize balanceSize = [_balanceLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(20) fontName:FONT_MIDDLE];
        _balanceLabel.frame = CGRectMake(STWidth(15), STHeight(120), balanceSize.width, STHeight(28));
        
        _totalLabel.text = [NSString stringWithFormat:@"%@",[STNumUtil formatNumWith2P:_mViewModel.model.total]];
        CGSize totalSize = [_totalLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(20) fontName:FONT_MIDDLE];
        _totalLabel.frame = CGRectMake(STWidth(135), STHeight(120), totalSize.width, STHeight(28));
        
        if(_mViewModel.model.frozenMoney <= 0){
            _freezeBtn.hidden = YES;
            _freezeTipsLabel.hidden = YES;
        }else{
            _freezeBtn.hidden = NO;
            _freezeTipsLabel.text = [NSString stringWithFormat:@"冻结金额：%.2f",_mViewModel.model.frozenMoney];
            CGSize nameSize = [_freezeTipsLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
            CGFloat bgWidth = STWidth(30) + nameSize.width;
            _freezeTipsLabel.frame = CGRectMake(STWidth(50), STHeight(17), bgWidth, STHeight(40));
            _freezeTipsLabel.backgroundColor = [c10 colorWithAlphaComponent:0.5f];
            BubbleLayer *bbLayer = [[BubbleLayer alloc]initWithSize:_freezeTipsLabel.bounds.size];
            // 矩形框的圆角半径
            bbLayer.cornerRadius = 2;
            // 凸起那部分暂且称之为“箭头”，下面的参数设置它的形状
            bbLayer.arrowDirection = ArrowDirectionBottom;
            bbLayer.arrowHeight = 6;   // 箭头的高度（长度）
            bbLayer.arrowWidth = STWidth(8);    // 箭头的宽度
            CGFloat arrowWidth =  STWidth(25)+withdrawSize.width  +STWidth(8) - STWidth(50);
            bbLayer.arrowPosition = arrowWidth/bgWidth;// 箭头的相对位置
            bbLayer.arrowRadius = 2;    // 箭头处的圆角半径
            [_freezeTipsLabel.layer setMask:[bbLayer layer]];
        }
        
    }else if([respondModel.requestUrl containsString:URL_PROFIT_LIST]){
        [_profitView updateSuccessData:data];
        [_scrollView endRefreshNew];
    }else if([respondModel.requestUrl containsString:URL_WITHDRAW_LIST]){
        [_withdrawView updateSuccessData:data];
        [_scrollView endRefreshNew];
    }
}

-(void)onRequestFail:(NSString *)msg{
    [_scrollView endRefreshNew];
}


//列表接口调用
- (void)onRequestNoData:(int)type{
    if(type == CapitalType_Profit){
        [_profitView updateNoData:type];
        if(!IS_NS_COLLECTION_EMPTY(_mViewModel.profitDatas)){
            [_scrollView noMoreData];
        }else{
            [_scrollView hideFooter:YES];
        }
    }else if(type == CapitalType_Withdraw){
        [_withdrawView updateNoData:type];
        if(!IS_NS_COLLECTION_EMPTY(_mViewModel.withdrawDatas)){
            [_scrollView noMoreData];
        }else{
            [_scrollView hideFooter:YES];
        }
    }
}

//点击TX
-(void)onWithdrawClicked{
    if(_mViewModel.model.canWithdrawNum <= 0){
        [LCProgressHUD showMessage:MSG_NO_TX_MONEY];
    }
    else if(_mViewModel.model.canWithdrawNum <= _mViewModel.model.frozenMoney){
        [LCProgressHUD showMessage:[NSString stringWithFormat:MSG_NO_TX_FREEZE,_mViewModel.model.frozenMoney]];
        _freezeTipsLabel.hidden = NO;
        _freezeBtn.hidden = NO;
    }
    else{
        if(_mainViewModel){
            [_mainViewModel goWithdrawPage:_mViewModel.model];
        }
    }
}


//切换tab更新
-(void)updateView{
    [self refreshNew];
}

-(void)refreshNew{
    NSLog(@"上拉");
    [_mViewModel requestCapitalData];
    if(_mCurrent == CapitalType_Profit){
        [_profitView refreshNew];
    }else{
        [_withdrawView refreshNew];
    }
}



-(void)uploadMore{
    NSLog(@"下拉");
    if(_mCurrent == CapitalType_Profit){
        [_profitView uploadMore];
    }else{
        [_withdrawView uploadMore];
    }
}

-(void)onUpdateUI:(int)type count:(NSInteger)count{
    if(count == 0){
        [_pageView changeFrame:ScreenHeight - STHeight(307) - StatuBarHeight];
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight - STHeight(50) - STHeight(52) - StatuBarHeight)];
        return;
    }
    if(type == CapitalType_Profit){
        [_pageView changeFrame:STHeight(38) + STHeight(52.5) * count];
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(38) + STHeight(52.5) * count + STHeight(205) + _newYearHeight)];
    }else{
        [_pageView changeFrame:STHeight(38) + STHeight(238) * count + STHeight(15)];
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(38) + STHeight(238) * count + STHeight(205) + _newYearHeight+ STHeight(15))];
    }
}

-(void)onScrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = self.scrollView.mj_offsetY;
    if(offsetY > STHeight(205) + _newYearHeight){
        [_pageView fastenTopView:offsetY - STHeight(205) - _newYearHeight];
        _monthBtn.frame = CGRectMake(0, offsetY, ScreenWidth/3, STHeight(38));
    }else{
        [_pageView fastenTopView:0];
        _monthBtn.frame = CGRectMake(0, STHeight(205) + _newYearHeight, ScreenWidth/3, STHeight(38));

    }
}

-(void)onPageViewSelect:(NSInteger)position view:(id)view{
    if(_mCurrent == position){
        return;
    }
    _mCurrent = position;
    [_scrollView hideFooter:NO];
    [self refreshNew];
}

-(void)onRefreshEnd{
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
}

-(void)onHelpBtnClick{
    if(_mainViewModel){
        [_mainViewModel goHelpPage];
    }
}

//选择月份
-(void)onMonthClicked{
    [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:_layerView];
    _layerView.hidden = NO;
}

-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView yearposition:(int)yearposition monthposition:(int)monthposition{
    [_scrollView hideFooter:NO];
    CGSize monthSize = [result sizeWithMaxWidth:ScreenWidth font:STFont(16)];
    _monthLabel.frame = CGRectMake(STWidth(15), 0, monthSize.width, STHeight(38));
    _monthLabel.text = result;
    
    _monthImageView.frame = CGRectMake(monthSize.width + STWidth(25), (STHeight(38) - STWidth(13))/2, STWidth(13), STWidth(13));
    
    _mViewModel.year = yearposition;
    _mViewModel.month = monthposition;
    CapitalContentView *currentView = (CapitalContentView *)[_pageView getCurrentView];
    [currentView refreshNew];
}


-(void)onCloseNewYearView{
    _newYearHeight = 0;
    _mNewYearView.hidden = YES;
    [self updateNewYearView];
   
}

-(void)updateNewYearView{
    CGFloat homeHeight = 0;
    if (@available(iOS 11.0, *)) {
        homeHeight = HomeIndicatorHeight;
    } else {
        homeHeight = 0;
    }
    WS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.pageView.frame = CGRectMake(0, STHeight(205) + weakSelf.newYearHeight, ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(62)-STHeight(175)-STHeight(30) - STHeight(50) - homeHeight);
        weakSelf.monthBtn.frame = CGRectMake(0, STHeight(205) + weakSelf.newYearHeight, ScreenWidth/3, STHeight(38));
    }];
    if(_mCurrent == CapitalType_Profit){
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(38) + STHeight(52.5) * _mViewModel.profitDatas.count + STHeight(205) + weakSelf.newYearHeight)];
    }else{
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(38) + STHeight(238) * _mViewModel.withdrawDatas.count + STHeight(205) + STHeight(15) + weakSelf.newYearHeight)];
    }
}

-(void)updateBroadcast:(NSString *)imgUrl content:(NSString *)content{
    _newYearHeight = STHeight(40);
    _mNewYearView.hidden = NO;
    _mNewYearView.frame = CGRectMake(STWidth(23), STHeight(190), STWidth(330), _newYearHeight);
    [_mNewYearView setImgUrl:imgUrl];
    [_mNewYearView setText:content];
    [self updateNewYearView];
}

-(void)onFreezeBtnClick{
    _freezeTipsLabel.hidden = !_freezeTipsLabel.hidden;
}


@end

