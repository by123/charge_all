//
//  CapitalDetailView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "CapitalDetailView.h"
#import "TouchScrollView.h"
#import "STPageView.h"
#import "CapitalDetailProfitView.h"
#import "CapitalDetailDeviceView.h"
#import "STYearMonthDayLayerView.h"
#import "STTimeUtil.h"
#import "AccountManager.h"

@interface CapitalDetailView()<TouchScrollViewDelegate,STPageViewDelegate,STYearMonthDayLayerViewDelegate>

@property(strong, nonatomic)CapitalDetailViewModel *mViewModel;
@property(strong, nonatomic)UILabel *monthLabel;
@property(strong, nonatomic)UIImageView *monthImageView;
@property(strong, nonatomic)TouchScrollView *scrollView;

@property(strong, nonatomic)UILabel *withDrawLabel;
@property(strong, nonatomic)UILabel *cardProfitLabel;
@property(strong, nonatomic)NSMutableArray *contentViews;

@property(assign, nonatomic)NSInteger mCurrent;
@property(strong, nonatomic)CapitalDetailProfitView *profitView;
@property(strong, nonatomic)CapitalDetailDeviceView *deviceView;
@property(strong, nonatomic)STPageView *pageView;
@property(strong, nonatomic)STYearMonthDayLayerView *layerView;

@property(assign, nonatomic)int settement;

@end

@implementation CapitalDetailView

-(instancetype)initWithViewModel:(CapitalDetailViewModel *)viewModel{
    if(self == [super init]){
        _mCurrent = 0;
        _mViewModel = viewModel;
        _contentViews = [[NSMutableArray alloc]init];
        [self initView];
//        [_mViewModel getWithdrawTime];
        [self refreshNew];
        [self updateSettementPeriod];
    }
    return self;
}

-(void)initView{
    [self initMonthView];
    [self initScrollView];

    _layerView = [[STYearMonthDayLayerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _layerView.hidden = YES;
    _layerView.delegate = self;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_layerView];
    
    NSArray *dates = [_mViewModel.date componentsSeparatedByString:@"-"];
    [_layerView setData:dates[0] month:dates[1] day:dates[2]];
}


-(void)initMonthView{
    UIButton *monthBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/3, STHeight(42))];
    [monthBtn addTarget:self action:@selector(onMonthClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:monthBtn];
    
    _monthLabel = [[UILabel alloc]initWithFont:STFont(16) text:_mViewModel.date textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize monthSize = [_monthLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(16) fontName:FONT_MIDDLE];
    _monthLabel.frame = CGRectMake(STWidth(15), 0, monthSize.width, STHeight(42));
    [_monthLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(16)]];
    [monthBtn addSubview:_monthLabel];
    
    _monthImageView = [[UIImageView alloc]initWithFrame:CGRectMake(monthSize.width + STWidth(25), (STHeight(42) - STWidth(13))/2, STWidth(13), STWidth(13))];
    _monthImageView.image = [UIImage imageNamed:IMAGE_REFRESH];
    _monthImageView.contentMode = UIViewContentModeScaleAspectFill;
    [monthBtn addSubview:_monthImageView];
}

-(void)initScrollView{
    
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:self];
    _scrollView.frame = CGRectMake(0, STHeight(42), ScreenWidth, ContentHeight - STHeight(42));
    [_scrollView enableHeader];
    [_scrollView enableFooter];
    [self addSubview:_scrollView];
    
    UIView *cardView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), STHeight(110))];
    if(IS_YELLOW_SKIN){
        cardView.backgroundColor = c14;
    }else{
        [STColorUtil setGradientColor:cardView startColor:c18 endColor:c19 director:Left];
    }
    cardView.layer.masksToBounds = YES;
    cardView.layer.cornerRadius = 2;
    [_scrollView addSubview:cardView];
    
    NSString *cardProfitStr = @"¥0.00";
    _cardProfitLabel = [[UILabel alloc]initWithFont:STFont(30) text:cardProfitStr textAlignment:NSTextAlignmentCenter textColor:c21 backgroundColor:nil multiLine:NO];
    CGSize nameSize = [cardProfitStr sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    [_cardProfitLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    _cardProfitLabel.frame = CGRectMake(STWidth(15), STHeight(22), nameSize.width, STHeight(42));
    [cardView addSubview:_cardProfitLabel];
    
    NSString *titleStr = @"收益金额（元）";
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:titleStr textAlignment:NSTextAlignmentCenter textColor:c21 backgroundColor:nil multiLine:NO];
    CGSize titlSize = [titleStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    titleLabel.frame = CGRectMake(STWidth(15), STHeight(65), titlSize.width, STHeight(21));
    [cardView addSubview:titleLabel];
    
    _withDrawLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c21 backgroundColor:nil multiLine:NO];
    CGSize withDrawSize = [_withDrawLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    _withDrawLabel.frame = CGRectMake(STWidth(345) - STWidth(15) - withDrawSize.width, STHeight(67), withDrawSize.width, STHeight(17));
    [cardView addSubview:_withDrawLabel];
    
    [self initTitleView];
    [self initContentView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(250), ScreenWidth, STHeight(15))];
    lineView.backgroundColor = cbg;
    [_scrollView addSubview:lineView];
    
    _profitView = [[CapitalDetailProfitView alloc]initWithViewModel:_mViewModel];
    _deviceView = [[CapitalDetailDeviceView alloc]initWithViewModel:_mViewModel];
    
    NSMutableArray *views = [[NSMutableArray alloc]init];
    [views addObject:_profitView];
    [views addObject:_deviceView];

    _pageView = [[STPageView alloc]initWithFrame:CGRectMake(0, STHeight(265), ScreenWidth, ContentHeight - STHeight(42) - STHeight(265)) views:views titles:@[@"渠道收入",@"设备使用"] perLine:0.3];
    _pageView.delegate = self;
    [_scrollView addSubview:_pageView];
}

-(void)initTitleView{
    NSArray *titles = @[@"分润收入（元）",@"设备订单率",@"退款扣除（元）",@"设备订单数",@"设备激活数",@"订单金额（元）"];
    for(int i = 0; i < titles.count ; i++){
        NSString *titleStr = titles[i];
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(12) text:titleStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleStr sizeWithMaxWidth:ScreenWidth font:STFont(12)];
        if(i > 1 && i <=3){
           titleLabel.frame = CGRectMake(STWidth(143), STHeight(110) + STHeight(43)  + STHeight(60) * (i -2), titleSize.width, STHeight(17));
        }
        else if(i > 3){
           titleLabel.frame = CGRectMake(STWidth(264), STHeight(110) + STHeight(43)  + STHeight(60) * (i -4), titleSize.width, STHeight(17));
        }else{
           titleLabel.frame = CGRectMake(STWidth(15), STHeight(110) + STHeight(43)  + STHeight(60) * i, titleSize.width, STHeight(17));
        }
        [_scrollView addSubview:titleLabel];
    }
    
    for(int i = 0 ; i < 4 ; i ++){
        UIView *lineView = [[UIView alloc]init];
        if(i > 1){
            lineView.frame = CGRectMake(STWidth(232), STHeight(110) + STHeight(25) + STHeight(60) * (i-2), LineHeight, STHeight(20));

        }else{
             lineView.frame = CGRectMake(STWidth(111), STHeight(110) + STHeight(25) + STHeight(60) * i, LineHeight, STHeight(20));
        }
        lineView.backgroundColor = cline;
        [_scrollView addSubview:lineView];
    }
}

-(void)initContentView{
    NSArray *contents = @[@"0.00",@"0.00%",@"0.00",@"0",@"0",@"0.00"];
    for(int i = 0; i < contents.count ; i++){
        NSString *contentStr = contents[i];
        UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(15) text:contentStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [contentStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        if(i > 1 && i <=3){
            contentLabel.frame = CGRectMake(STWidth(143), STHeight(110) + STHeight(20)  + STHeight(60) * (i -2), titleSize.width, STHeight(21));
        }
        else if(i > 3){
            contentLabel.frame = CGRectMake(STWidth(264), STHeight(110) + STHeight(20)  + STHeight(60) * (i -4), titleSize.width, STHeight(21));
        }else{
            contentLabel.frame = CGRectMake(STWidth(15), STHeight(110) + STHeight(20)  + STHeight(60) * i, titleSize.width, STHeight(21));
        }
        [_contentViews addObject:contentLabel];
        [_scrollView addSubview:contentLabel];
    }
}

-(void)updateContentView:(NSArray *)contents noData:(Boolean)noData{
    for(int i = 0; i < contents.count ; i++){
        NSString *contentStr = contents[i];
        UILabel *contentLabel = [_contentViews objectAtIndex:i];
        contentLabel.text = contentStr;
        CGSize titleSize = [contentLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        if(i > 1 && i <=3){
            contentLabel.frame = CGRectMake(STWidth(143), STHeight(110) + STHeight(20)  + STHeight(60) * (i - 2), titleSize.width, STHeight(21));
        }
        else if(i > 3){
            contentLabel.frame = CGRectMake(STWidth(264), STHeight(110) + STHeight(20)  + STHeight(60) * (i - 4), titleSize.width, STHeight(21));
        }else{
            contentLabel.frame = CGRectMake(STWidth(15), STHeight(110) + STHeight(20)  + STHeight(60) * i, titleSize.width, STHeight(21));
        }
    }
    
    if(noData){
        _cardProfitLabel.text = @"¥0.00";
    }else{
        _cardProfitLabel.text = [NSString stringWithFormat:@"¥%.2f",_mViewModel.detailModel.actualYuan];
    }
    CGSize cardProfitSize = [_cardProfitLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    _cardProfitLabel.frame = CGRectMake(STWidth(15), STHeight(22), cardProfitSize.width, STHeight(42));
}


-(void)refreshNew{
    if(_mViewModel){
        [_mViewModel getDeviceUsing];
        if(_mCurrent == CapitalDetailType_Profit){
            [_mViewModel getChildProfit:YES];
        }else{
            [_mViewModel getChildDeviceUsing:YES];
        }
    }
}

-(void)uploadMore{
    if(_mViewModel){
        if(_mCurrent == CapitalDetailType_Profit){
            [_mViewModel getChildProfit:NO];
        }else{
            [_mViewModel getChildDeviceUsing:NO];
        }
    }
}

-(void)onScrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = _scrollView.mj_offsetY;
    if(offsetY > STHeight(325)){
        [_pageView fastenTopView:offsetY - STHeight(325)];
    }else{
        [_pageView fastenTopView:0];
    }
}

-(void)onPageViewSelect:(NSInteger)position view:(id)view{
    if(_mCurrent == position){
        return;
    }
    _mCurrent = position;
    [self refreshNew];
}


-(void)onMonthClicked{
    _layerView.hidden = NO;
}

-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView yearposition:(int)yearposition monthposition:(int)monthposition daypostion:(int)dayposition{
    
    NSString *selectStr = [NSString stringWithFormat:@"%02d-%02d-%02d",yearposition,monthposition,dayposition];
    long selectTS = [STTimeUtil getTimeStamp:selectStr format:@"yyyy-MM-dd"];
    NSString *currentStr = [STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy-MM-dd"];
    long currentTS = [[STTimeUtil getCurrentTimeStamp] longLongValue] / 1000;
    
    if([selectStr isEqualToString:currentStr]){
        [LCProgressHUD showMessage:@"数据正在统计中，请明日查看"];
        return;
    }
    if(selectTS > currentTS){
        [LCProgressHUD showMessage:@"时间选择不能超过今日"];
    }else{
        [_scrollView hideFooter:NO];
        _monthLabel.text = result;
        CGSize monthSize = [result sizeWithMaxWidth:ScreenWidth font:STFont(16)];
        _monthLabel.frame = CGRectMake(STWidth(15), 0, monthSize.width, STHeight(42));
        _monthImageView.frame = CGRectMake(monthSize.width + STWidth(25), (STHeight(42) - STWidth(13))/2, STWidth(13), STWidth(13));
        
        _mViewModel.date = [NSString stringWithFormat:@"%02d-%02d-%02d",yearposition,monthposition,dayposition];
        [self refreshNew];
        [self updateSettementPeriod];
    }

}


-(void)updateProfitView{
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.profitDatas)){
        [_pageView changeFrame:ContentHeight];
    }else{
        [_pageView changeFrame:STHeight(38) + _mViewModel.profitDatas.count * STHeight(75)];
        _scrollView.contentSize = CGSizeMake(ScreenWidth, STHeight(363)+_mViewModel.profitDatas.count * STHeight(75));
    }
    [_profitView updateView];
}

-(void)updateDeviceView{
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.deviceDatas)){
        [_pageView changeFrame:ContentHeight];
    }else{
        [_pageView changeFrame:STHeight(38) + _mViewModel.deviceDatas.count * STHeight(97)];
        _scrollView.contentSize = CGSizeMake(ScreenWidth, STHeight(363)+_mViewModel.deviceDatas.count * STHeight(97));
    }
    [_deviceView updateView];
}

-(void)updateNoData:(int)type{
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
    if(type == CapitalDetailType_Profit){
        [self updateProfitView];
        if(!IS_NS_COLLECTION_EMPTY(_mViewModel.profitDatas)){
            [_scrollView noMoreData];
        }else{
            [_scrollView hideFooter:YES];
        }
    }else if(type == CapitalDetailType_Device){
        [self updateDeviceView];
        if(!IS_NS_COLLECTION_EMPTY(_mViewModel.deviceDatas)){
            [_scrollView noMoreData];
        }else{
            [_scrollView hideFooter:YES];
        }
    }else if(type == CapitalDetailType_All){
        NSArray *contents = @[@"0.00",@"0.00%",@"0.00",@"0",@"0",@"0.00"];
        [self updateContentView:contents noData:YES];
        [self updateProfitView];
        [self updateDeviceView];

    }
}

-(void)updateFail{
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
}

-(void)updateSettementPeriod{
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    _settement = model.settementPeriod;
    long cuurentTimeStamp = [STTimeUtil getTimeStamp:_mViewModel.date format:@"yyyy-MM-dd"] * 1000;
    cuurentTimeStamp += 3600 * 24 * 1000 * _settement;
    _withDrawLabel.text= [NSString stringWithFormat:@"预计提现日期 %@",[STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",cuurentTimeStamp] format:@"yyyy-MM-dd"]];
    CGSize withDrawSize = [_withDrawLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    _withDrawLabel.frame = CGRectMake(STWidth(345) - STWidth(15) - withDrawSize.width, STHeight(67), withDrawSize.width, STHeight(17));
}

@end

