//
//  WithdrawSuccessView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawSuccessView.h"
#import "STLineDashView.h"
#import "STTimeUtil.h"
#import "ZScrollLabel.h"

@interface WithdrawSuccessView()

@property(strong, nonatomic)WithdrawSuccessViewModel *mViewModel;
@property(strong, nonatomic)UIView *cardView;
@property(strong, nonatomic)UILabel *cardNumLabel;
@property(strong, nonatomic)UILabel *accountLabel;
@property(strong, nonatomic)UILabel *withdrawMoneyLabel;
@property(strong, nonatomic)UILabel *auxiliaryMoneyLabel;
@property(strong, nonatomic)UILabel *auxiliaryPayMoneyLabel;
@property(strong, nonatomic)UILabel *auxiliaryShuiMoneyLabel;
@property(strong, nonatomic)UILabel *actualMoneyLabel;
@property(strong, nonatomic)UILabel *applyTimeLabel;
@property(strong, nonatomic)UILabel *statementLabel;

@property(strong, nonatomic)UILabel *stateTitleLabel;

//
@property(strong, nonatomic)UILabel *step2Label;
@property(strong, nonatomic)UILabel *step3Label;
@property(strong, nonatomic)UIImageView *step3ImageView;
@property(strong, nonatomic)UIImageView *step2ImageView;

@end

@implementation WithdrawSuccessView

-(instancetype)initWithViewModel:(WithdrawSuccessViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView *step1ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(34), STHeight(14), STWidth(40), STWidth(40))];
    step1ImageView.image = [UIImage imageNamed:IMAGE_APPLY_SUCCESS];
    step1ImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:step1ImageView];
    
    NSString *step1Str = @"申请成功";
    UILabel *step1Label = [[UILabel alloc]initWithFont:STFont(15) text:step1Str textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize step1Size = [step1Str sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    step1Label.frame = CGRectMake(STWidth(34) + (STWidth(40) - step1Size.width)/2, STHeight(59), step1Size.width, STHeight(21));
    [self addSubview:step1Label];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(STWidth(93), STHeight(31), STWidth(55), LineHeight)];
    lineView1.backgroundColor = cline;
    [self addSubview:lineView1];
    
    _step2ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(168), STHeight(14), STWidth(40), STWidth(40))];
    _step2ImageView.image = [UIImage imageNamed:IMAGE_APPLYING];
    _step2ImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_step2ImageView];
    
    NSString *step2Str = MSG_BK_HANDING;
    _step2Label = [[UILabel alloc]initWithFont:STFont(15) text:step2Str textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize step2Size = [step2Str sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _step2Label.frame = CGRectMake(STWidth(168) + (STWidth(40) - step2Size.width)/2, STHeight(59), step2Size.width, STHeight(21));
    [self addSubview:_step2Label];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(STWidth(227), STHeight(31), STWidth(55), LineHeight)];
    lineView2.backgroundColor = cline;
    [self addSubview:lineView2];
    
    _step3ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(302), STHeight(14), STWidth(40), STWidth(40))];
    _step3ImageView.image = [UIImage imageNamed:IMAGE_NO_APPLY];
    _step3ImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_step3ImageView];
    
    NSString *step3Str = MSG_DAOZHANG_SUCCESS;
    _step3Label = [[UILabel alloc]initWithFont:STFont(15) text:step3Str textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize step3Size = [step3Str sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _step3Label.frame = CGRectMake(STWidth(302) + (STWidth(40) - step3Size.width)/2, STHeight(59), step3Size.width, STHeight(21));
    [self addSubview:_step3Label];
    
    [self initCardView];
}

-(void)initCardView{
    _cardView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(101), STWidth(345), ContentHeight - STHeight(101))];
    _cardView.backgroundColor = cwhite;
    _cardView.layer.shadowOffset = CGSizeMake(1, 1);
    _cardView.layer.shadowOpacity = 0.8;
    _cardView.layer.shadowColor = c03.CGColor;
    [self addSubview:_cardView];
    
    STLineDashView *lineView = [[STLineDashView alloc] initWithFrame:CGRectMake(STWidth(15), STHeight(56), STWidth(315), LineHeight)
                                                     lineDashPattern:@[@2, @2]
                                                           endOffset:0.495];
    lineView.backgroundColor = cline;
    [_cardView addSubview:lineView];
    
    CGFloat radius = STWidth(20);
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(5), STHeight(157) - radius/2, radius, radius)];
    leftView.backgroundColor = cbg;
    leftView.layer.masksToBounds = YES;
    leftView.layer.cornerRadius = STWidth(10);
    [self addSubview:leftView];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(25), STHeight(157) - radius/2, radius, radius)];
    rightView.backgroundColor = cbg;
    rightView.layer.masksToBounds = YES;
    rightView.layer.cornerRadius = STWidth(10);
    [self addSubview:rightView];
    
    NSString *titleStr = MSG_WITHDRAW_INFO;
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(16) text:titleStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(16)]];
    titleLabel.frame = CGRectMake(0, STHeight(16), STWidth(345), STHeight(22));
    [_cardView addSubview:titleLabel];
    
    
    _cardNumLabel = [self buildLabel];
    [_cardView addSubview:_cardNumLabel];
    
    _accountLabel = [self buildLabel];
    [_cardView addSubview:_accountLabel];
    
    _withdrawMoneyLabel = [self buildLabel];
    [_cardView addSubview:_withdrawMoneyLabel];
    
    _auxiliaryMoneyLabel = [self buildLabel];
    [_cardView addSubview:_auxiliaryMoneyLabel];
    
    _auxiliaryPayMoneyLabel = [self buildLabel];
    [_cardView addSubview:_auxiliaryPayMoneyLabel];
    
    _auxiliaryShuiMoneyLabel = [self buildLabel];
    [_cardView addSubview:_auxiliaryShuiMoneyLabel];

    _actualMoneyLabel = [self buildLabel];
    [_cardView addSubview:_actualMoneyLabel];
    
    _applyTimeLabel = [self buildLabel];
    [_cardView addSubview:_applyTimeLabel];
    
    _statementLabel = [self buildLabel];
    [_cardView addSubview:_statementLabel];
    
    UIButton *histroyBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(104), STHeight(360), STWidth(140), STHeight(35))];
    [histroyBtn addTarget:self action:@selector(onHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cardView addSubview:histroyBtn];
    
    NSString *historyStr = MSG_TX_HISTORY;
    UILabel *historyLabel = [[UILabel alloc]initWithFont:STFont(15) text:historyStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize historySize = [historyStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    historyLabel.frame = CGRectMake(0, 0, historySize.width, STHeight(35));
    [histroyBtn addSubview:historyLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake((STWidth(140) -historySize.width)/2 + historySize.width, (STHeight(35) - STWidth(13))/2, STWidth(13), STWidth(13))];
    arrowImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    [histroyBtn addSubview:arrowImageView];
    
    
}

-(UILabel *)buildLabel{
    return [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
}

-(void)setContentLabel:(UILabel *)label text:(NSString *)text height:(CGFloat)height{
    label.text = text;
    CGSize labelSize = [label.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    label.frame = CGRectMake(STWidth(330)-labelSize.width, height, labelSize.width, STHeight(21));
}

-(void)updateView{
    
    NSArray *titles;
    if(_mViewModel.model.isPublic == 2){
        titles = @[MSG_WITHDRAW_STYLE,MSG_WITHDRAW_NICKNAME,MSG_WITHDRAW_MONEY,MSG_SX_MONEY,MSG_SX_PAY_MONEY,MSG_SHUI_MONEY,MSG_SJDZ_MONEY,MSG_APPLY_TIME,MSG_LIUSHUI];

        [self setContentLabel:_cardNumLabel text:MSG_BK_WECHAT_TYPE height:STHeight(73)];
        [self setContentLabel:_accountLabel text:_mViewModel.model.accountName height:STHeight(104)];
        [self setContentLabel:_withdrawMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.withdrawMoneyTotalYuan] height:STHeight(135)];
        [self setContentLabel:_auxiliaryMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.auxiliaryExpensesYuan] height:STHeight(166)];
        [self setContentLabel:_auxiliaryPayMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.payExpensesYuan] height:STHeight(197)];
            [self setContentLabel:_auxiliaryShuiMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.taxYuan] height:STHeight(228)];
        [self setContentLabel:_actualMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.withdrawMoneyYuan] height:STHeight(259)];
        [self setContentLabel:_applyTimeLabel text:[STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",_mViewModel.model.createTime] format:MSG_TIME_FORMAT] height:STHeight(290)];
        
    }else{
        titles = @[MSG_CARDNUM_BK,MSG_ACCOUNT_NAME,MSG_TX_MONEY,MSG_SX_MONEY,MSG_SX_PAY_MONEY,MSG_SHUI_MONEY,MSG_SJDZ_MONEY,MSG_APPLY_TIME,MSG_LIUSHUI];

        [self setContentLabel:_cardNumLabel text:_mViewModel.model.bankId height:STHeight(73)];
        [self setContentLabel:_accountLabel text:_mViewModel.model.accountName height:STHeight(104)];
        [self setContentLabel:_withdrawMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.withdrawMoneyTotalYuan] height:STHeight(135)];
        [self setContentLabel:_auxiliaryMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.auxiliaryExpensesYuan] height:STHeight(166)];
          [self setContentLabel:_auxiliaryPayMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.payExpensesYuan] height:STHeight(197)];
          [self setContentLabel:_auxiliaryShuiMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.taxYuan] height:STHeight(228)];
        [self setContentLabel:_actualMoneyLabel text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.withdrawMoneyYuan] height:STHeight(259)];
        [self setContentLabel:_applyTimeLabel text:[STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",_mViewModel.model.createTime] format:MSG_TIME_FORMAT] height:STHeight(290)];
        
    }
    
    for(int i = 0 ; i < titles.count ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:titles[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize nameSize = [titles[i] sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(73) + STHeight(31) * i, nameSize.width, STHeight(21));
        [_cardView addSubview:titleLabel];
        
        if(i + 1 == titles.count){
            _stateTitleLabel = titleLabel;
        }
    }

    if(IS_NS_STRING_EMPTY(_mViewModel.model.bankOrderid)){
        _stateTitleLabel.hidden = YES;
    }else{
        _stateTitleLabel.hidden = NO;
        ZScrollLabel *contentLabel = [[ZScrollLabel alloc] init];
        contentLabel.text = _mViewModel.model.bankOrderid;
        contentLabel.frame = CGRectMake(STWidth(130), STHeight(321), STWidth(200), STHeight(21));
        contentLabel.textColor = c10;
        contentLabel.labelAlignment = ZScrollLabelAlignmentRight;
        contentLabel.font = [UIFont systemFontOfSize:STFont(15)];
        [_cardView addSubview:contentLabel];
    }

    if(_mViewModel.model.withdrawState == 2){
        _step2Label.textColor = c11;
        _step3Label.textColor = c10;
        _step3ImageView.image = [UIImage imageNamed:IMAGE_APPLY_SUCCESS];
        _step2ImageView.image = [UIImage imageNamed:IMAGE_APPLY_SUCCESS];
    }
}


-(void)onHistoryBtnClick{
    if(_mViewModel){
        [_mViewModel backHomePage];
    }
}

@end

