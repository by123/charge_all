//
//  WithdrawView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawView.h"

@interface WithdrawView()

@property(strong, nonatomic)WithdrawViewModel *mViewModel;


@property(strong, nonatomic)UIView *wechatView;
@property(strong, nonatomic)UIView *bankView;
@property(strong, nonatomic)UIView *withdrawView;
@property(strong, nonatomic)UILabel *canWithdrawLabel;
@property(strong, nonatomic)UITextField *moneyTF;
@property(strong, nonatomic)UILabel *tips;
@property(strong, nonatomic)UILabel *tips2;
@property(strong, nonatomic)UIImageView *tipsImageView;
@property(strong, nonatomic)UIImageView *tips2ImageView;

@property(strong, nonatomic)UIImageView *bankImageView;
@property(strong, nonatomic)UILabel *bankNameLabel;
@property(strong, nonatomic)UILabel *bankIdLabel;
@property(strong, nonatomic)UIImageView *headImageView;

@property(strong, nonatomic)UILabel *tx1Label;
@property(strong, nonatomic)UILabel *tx2Label;

@property(strong, nonatomic)UIButton *withdrawBtn;
@property(assign, nonatomic)Boolean isWeChat;

@end

@implementation WithdrawView{
    Boolean hasClickBtnAll;
}

-(instancetype)initWithViewModel:(WithdrawViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self initNoBindWeChatView];
    [self initBankView];
    [self initWithDrawView];
}


-(void)initNoBindWeChatView{
    _wechatView = [[UIView alloc]init];
    _wechatView.backgroundColor = cbg;
    _wechatView.layer.cornerRadius = 2;
    _wechatView.layer.masksToBounds = YES;
    _wechatView.hidden = YES;
    [self addSubview:_wechatView];
    
    UIImageView *wechatImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(16), (STHeight(70) - STHeight(28))/2, STWidth(36), STHeight(28))];
    wechatImageView.image = [UIImage imageNamed:IMAGE_WITHDRAW_WECHAT];
    wechatImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_wechatView addSubview:wechatImageView];
    
    UILabel *wechatLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_BK_WECHAT_TYPE textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize wechatSize = [wechatLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    wechatLabel.frame = CGRectMake(STWidth(63), STHeight(16), wechatSize.width, STHeight(21));
    [_wechatView addSubview:wechatLabel];
    
    int start = [[STUserDefaults getKeyValue:CONFIG_WITHDRAW_START] intValue]/100;
    UILabel *wechatTipsLabel = [[UILabel alloc]initWithFont:STFont(12) text:[NSString stringWithFormat:@"%d元起提 实时到账",start]  textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize wechatTipsSize = [wechatTipsLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    wechatTipsLabel.frame = CGRectMake(STWidth(63), STHeight(37), wechatTipsSize.width, STHeight(17));
    [_wechatView addSubview:wechatTipsLabel];
    
    UIButton *bindWeChatBtn = [[UIButton alloc]initWithFont:STFont(10) text:MSG_BIND_WECHAT_BTN textColor:c10 backgroundColor:cclear corner:2 borderWidth:LineHeight borderColor:c10];
    bindWeChatBtn.frame = CGRectMake(STWidth(280), STHeight(25), STWidth(50), STHeight(20));
    [bindWeChatBtn addTarget:self action:@selector(onBindWeChatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_wechatView addSubview:bindWeChatBtn];
    
}

-(void)initBankView{
    _bankView = [[UIView alloc]init];
    _bankView.hidden = YES;
    [self addSubview:_bankView];
    
    UILabel *withdrawLabel = [[UILabel alloc]initWithFont:STFont(18) text:MSG_WITHDRAW_SELECT textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize withdrawSize = [withdrawLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(18)];
    withdrawLabel.frame = CGRectMake(STWidth(15), STHeight(20), withdrawSize.width, STHeight(25));
    [_bankView addSubview:withdrawLabel];
    
    _bankImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(88), STHeight(23), STWidth(20), STWidth(20))];
    _bankImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_bankView addSubview:_bankImageView];
    
    UIButton *bankBtn = [[UIButton alloc]init];
    bankBtn.frame = CGRectMake(STWidth(116), STHeight(20), ScreenWidth - STWidth(116), STHeight(25));
    [bankBtn addTarget:self action:@selector(onBankSelectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bankView addSubview:bankBtn];
    
    _bankNameLabel = [[UILabel alloc]initWithFont:STFont(18) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [bankBtn addSubview:_bankNameLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(116)-STWidth(12.4)-STWidth(15), (STHeight(25) - STWidth(12.4))/2, STWidth(12.4), STWidth(12.4))];
    arrowImageView.image = [UIImage imageNamed:IMAGE_DARK_NEXT];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bankBtn addSubview:arrowImageView];
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(88), STHeight(51), STWidth(20), STWidth(20))];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.hidden = YES;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = STWidth(10);
    [_bankView addSubview:_headImageView];
    
    _bankIdLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [_bankView addSubview:_bankIdLabel];
    
    _tx1Label = [[UILabel alloc]initWithFont:STFont(11) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize tx1Size = [_tx1Label.text sizeWithMaxWidth:ScreenWidth font:STFont(11)];
    _tx1Label.frame = CGRectMake(STWidth(15), STHeight(91), tx1Size.width, STHeight(16));
    [_bankView addSubview:_tx1Label];
    
    _tx2Label = [[UILabel alloc]initWithFont:STFont(11) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize tx2Size = [_tx2Label.text sizeWithMaxWidth:ScreenWidth font:STFont(11)];
    _tx2Label.frame = CGRectMake(STWidth(15), STHeight(91) +STHeight(18), tx2Size.width, STHeight(16));
    [_bankView addSubview:_tx2Label];
}


-(void)initWithDrawView{
    
    _withdrawView = [[UIView alloc]init];
    _withdrawView.userInteractionEnabled = YES;
    _withdrawView.hidden = YES;
    [self addSubview:_withdrawView];

    _canWithdrawLabel = [[UILabel alloc]initWithFont:STFont(15) text:[NSString stringWithFormat:MSG_CAN_TX_MONEY,_mViewModel.capitalModel.canWithdrawNum] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize canWithdrawSize = [_canWithdrawLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _canWithdrawLabel.frame = CGRectMake(STWidth(15), STHeight(30), canWithdrawSize.width, STHeight(21));
    [_withdrawView addSubview:_canWithdrawLabel];
    
    NSString *perStr = @"¥";
    UILabel *perLabel = [[UILabel alloc]initWithFont:STFont(30) text:perStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize perSize = [perStr sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    [perLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    perLabel.frame = CGRectMake(STWidth(15), STHeight(66), perSize.width, STHeight(42));
    [_withdrawView addSubview:perLabel];
    
    _moneyTF = [[UITextField alloc]initWithFont:STFont(30) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
    _moneyTF.textAlignment = NSTextAlignmentLeft;
    _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    [_moneyTF setPlaceholder:MSG_BLANK_TX_MONEY color:c05 fontSize:STFont(14)];
    _moneyTF.frame = CGRectMake(STWidth(42), STHeight(66), ScreenWidth - STWidth(140), STHeight(42));
    [_moneyTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_withdrawView addSubview:_moneyTF];
    
    _tipsImageView = [[UIImageView alloc]init];
    _tipsImageView.image = [UIImage imageNamed:IMAGE_TIPS];
    _tipsImageView.contentMode = UIViewContentModeScaleAspectFill;
    _tipsImageView.frame = CGRectMake(STWidth(15), STHeight(120) ,STWidth(14) , STWidth(14));
    [_withdrawView addSubview:_tipsImageView];
    
    _tips = [[UILabel alloc]initWithFont:STFont(12) text:MSG_EMPTY textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    [_withdrawView addSubview:_tips];
    
    _tips2ImageView = [[UIImageView alloc]init];
    _tips2ImageView.image = [UIImage imageNamed:IMAGE_TIPS];
    _tips2ImageView.contentMode = UIViewContentModeScaleAspectFill;
    _tips2ImageView.frame = CGRectMake(STWidth(15), STHeight(145) ,STWidth(14) , STWidth(14));
    [_withdrawView addSubview:_tips2ImageView];
    
    _tips2 = [[UILabel alloc]initWithFont:STFont(12) text:MSG_EMPTY textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    [_withdrawView addSubview:_tips2];
    
    [self textFieldDidChange:_moneyTF];

    
    UIButton *allBtn = [[UIButton alloc]initWithFont:STFont(12) text:MSG_TX_ALL textColor:c10 backgroundColor:nil corner:2 borderWidth:LineHeight borderColor:c10];
    allBtn.frame = CGRectMake(STWidth(293), STHeight(30), STWidth(67), STHeight(30));
    [allBtn addTarget:self action:@selector(onAllBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_withdrawView addSubview:allBtn];
    
    
    UIView *toplineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, ScreenWidth - STWidth(30), LineHeight)];
    toplineView.backgroundColor = cline;
    [_withdrawView addSubview:toplineView];
    
    UIView *bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(107)-LineHeight, ScreenWidth - STWidth(30), LineHeight)];
    bottomlineView.backgroundColor = cline;
    [_withdrawView addSubview:bottomlineView];
    
    
    _withdrawBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_LIJI_TX textColor:c_btn_txt_normal backgroundColor:c05 corner:2 borderWidth:0 borderColor:nil];
    _withdrawBtn.frame = CGRectMake((ScreenWidth - STWidth(120))/2, STHeight(198), STWidth(120), STHeight(42));
    [_withdrawBtn addTarget:self action:@selector(onWithdrawBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _withdrawBtn.enabled = NO;
    [_withdrawView addSubview:_withdrawBtn];
}

//点击全部tixian
-(void)onAllBtnClick{
    _moneyTF.text = [NSString stringWithFormat:@"%.2f",_mViewModel.capitalModel.canWithdrawNum -_mViewModel.capitalModel.frozenMoney];
    [_mViewModel requestRule:[_moneyTF.text doubleValue]];
//    [self updateAuxiliary];
}


//点击tixian
-(void)onWithdrawBtnClick{
    if(_mViewModel){
        [_mViewModel doWithdraw:_moneyTF.text];
    }
}

-(void)updateBankView{
    
    NSMutableArray *datas = _mViewModel.banks;
    Boolean hasBindWeChat = NO;
    for(BankModel *model in datas){
        if(model.isPublic == 2){
            hasBindWeChat = YES;
            break;
        }
    }
    
    if(IS_RED_SKIN){
        hasBindWeChat = YES;
    }
    
    BankModel *model = _mViewModel.defaultModel;
    if(hasBindWeChat){
        //微信已绑定
        _wechatView.hidden = YES;
        _bankView.hidden = NO;
        _withdrawView.hidden = NO;
        _bankView.frame = CGRectMake(0, 0, ScreenWidth, STHeight(145));
        _withdrawView.frame = CGRectMake(0, STHeight(145), ScreenWidth, STHeight(250));
        
        if(model.isPublic == 2){
            _bankImageView.image = [UIImage imageNamed:IMAGE_WITHDRAW_WECHAT];
            _bankNameLabel.text = MSG_BK_WECHAT_TYPE;
            _bankIdLabel.text = model.accountName;
            
            _headImageView.hidden = NO;
            if(!IS_NS_STRING_EMPTY(model.headUrl)){
                [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
            }
        }else{
            _bankImageView.image = [UIImage imageNamed:IMAGE_WITHDRAW_BANK];
            _bankNameLabel.text = model.bankName;
            if(model.bankId && model.bankId.length > 4){
                if(model.isPublic == 1){
                    _bankIdLabel.text = [NSString stringWithFormat:MSG_WITHDRAW_DUIGONG,[model.bankId substringWithRange:NSMakeRange(model.bankId.length - 4, 4)]];
                }else{
                    _bankIdLabel.text = [NSString stringWithFormat:MSG_WITHDRAW_GEREN,[model.bankId substringWithRange:NSMakeRange(model.bankId.length - 4, 4)]];
                }
            }else{
                _bankIdLabel.text = MSG_WITHDRAW_BANKID_ERROR;
            }
            _headImageView.hidden = YES;
        }

        
    }else{
         //微信未绑定
        _wechatView.hidden = NO;
        _bankView.hidden = NO;
        _withdrawView.hidden = NO;
        _wechatView.frame = CGRectMake(STWidth(15), STHeight(10), STWidth(345), STHeight(70));
        _bankView.frame = CGRectMake(0, STHeight(88), ScreenWidth, STHeight(145));
        _withdrawView.frame = CGRectMake(0, STHeight(233), ScreenWidth, STHeight(250));
        
        _bankImageView.image = [UIImage imageNamed:IMAGE_WITHDRAW_BANK];
        _bankNameLabel.text = model.bankName;
        if(model.bankId && model.bankId.length > 4){
            if(model.isPublic == 1){
                _bankIdLabel.text = [NSString stringWithFormat:MSG_WITHDRAW_DUIGONG,[model.bankId substringWithRange:NSMakeRange(model.bankId.length - 4, 4)]];
            }else{
               _bankIdLabel.text = [NSString stringWithFormat:MSG_WITHDRAW_GEREN,[model.bankId substringWithRange:NSMakeRange(model.bankId.length - 4, 4)]];
            }
        }else{
            _bankIdLabel.text = MSG_WITHDRAW_BANKID_ERROR;
        }

        _headImageView.hidden = YES;

    }
    
    CGSize bankNameSize = [_bankNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(18)];
    _bankNameLabel.frame = CGRectMake(0, 0, bankNameSize.width, STHeight(25));
    
    CGSize bankIdSize = [_bankIdLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14) ];
    _bankIdLabel.frame = CGRectMake(STWidth(116), STHeight(51), bankIdSize.width, STHeight(20));
}

-(void)updateRuleView:(Boolean)isWechat{
    _isWeChat = isWechat;
    int start = [[STUserDefaults getKeyValue:CONFIG_WITHDRAW_START] intValue] / 100;
    int wxMax = [[STUserDefaults getKeyValue:CONFIG_WITHDRAW_MAX_WX] intValue] / 100;
    if(isWechat){
        _tx1Label.text = [NSString stringWithFormat:MSG_WITHDRAW_RULE_WECAHT,start,wxMax];
        _tx2Label.text = [NSString stringWithFormat:MSG_WITHDRAW_RULE_TIME,1];

    }else{
        _tx1Label.text = [NSString stringWithFormat:MSG_WITHDRAW_RULE_BANK,start];
        _tx2Label.text = [NSString stringWithFormat:MSG_WITHDRAW_BANK_RULE_TIME,3];
    }
    CGSize tip1Size = [_tx1Label.text sizeWithMaxWidth:ScreenWidth font:STFont(11)];
    _tx1Label.frame = CGRectMake(STWidth(15), STHeight(91), tip1Size.width, STHeight(16));
    CGSize tip2Size = [_tx2Label.text sizeWithMaxWidth:ScreenWidth font:STFont(11)];
    _tx2Label.frame = CGRectMake(STWidth(15), STHeight(91) +STHeight(18), tip2Size.width, STHeight(16));
    
}

-(void)updateAuxiliary{
    WithdrawModel *model = _mViewModel.withDrawModel;
    _tipsImageView.hidden = NO;
    _tips.text = [NSString stringWithFormat:@"冻结金额：%.2f元",_mViewModel.capitalModel.frozenMoney];
    CGSize tipsSize = [_tips.text sizeWithMaxWidth:ScreenWidth - STWidth(34+15) font:STFont(12)];
      _tips.frame = CGRectMake(STWidth(34), STHeight(120),ScreenWidth - STWidth(34+15), tipsSize.height);

    NSString *tips2Str = MSG_EMPTY;
    if(IS_NS_STRING_EMPTY(_moneyTF.text) || model.withdrawRealYuan <= 0){
        [_withdrawBtn setBackgroundColor:c05 forState:UIControlStateNormal];
        [_withdrawBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
        _withdrawBtn.enabled = NO;
        _tips2.hidden = YES;
        _tips2ImageView.hidden = YES;
   
    }else{
        _tips2.hidden = NO;
        _tips2ImageView.hidden = NO;
        tips2Str = [NSString stringWithFormat:MSG_TX_TIPS,model.auxiliaryExpensesYuan,model.payExpensesYuan,model.taxYuan,model.withdrawRealYuan];

            [_withdrawBtn setBackgroundColor:c01 forState:UIControlStateNormal];
            [_withdrawBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
            _withdrawBtn.enabled = YES;
    }
    _tips2.text = tips2Str;
    CGSize tips2Size = [_tips2.text sizeWithMaxWidth:ScreenWidth - STWidth(34+15) font:STFont(12)];
    _tips2.frame = CGRectMake(STWidth(34), STHeight(145),ScreenWidth - STWidth(34+15), tips2Size.height);
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_moneyTF resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if(textField == _moneyTF){
        hasClickBtnAll = NO;
        NSString *content = textField.text;
        if([content containsString:@"."]){
            NSArray *datas = [content componentsSeparatedByString:@"."];
            NSString *intValue = datas[0];
            NSString *pointValue = datas[1];
            if(pointValue.length > 2){
                pointValue = [pointValue substringWithRange:NSMakeRange(0, 2)];
            }
            textField.text = [NSString stringWithFormat:@"%@.%@",intValue,pointValue];
        }
        if(!IS_NS_STRING_EMPTY(_moneyTF.text)){
            WS(weakSelf)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.mViewModel requestRule:[weakSelf.moneyTF.text doubleValue]];
            });
        }
    }
    NSString *input = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];

    [self updateAuxiliary];
    int wxMax = [[STUserDefaults getKeyValue:CONFIG_WITHDRAW_MAX_WX] intValue] / 100;
    if(_isWeChat){
        if([input doubleValue] > (wxMax + _mViewModel.capitalModel.frozenMoney)){
            [LCProgressHUD showMessage:MSG_MAX_TX_WECHAT_MONEY];
            return;
        }
    }
    if([input doubleValue] > _mViewModel.capitalModel.canWithdrawNum){
        [LCProgressHUD showMessage:MSG_MAX_TX_MONEY];
        return;
    }

}

-(void)onBindWeChatBtnClick{
    [_mViewModel goBindWeChat];
}

-(void)onBankSelectBtnClick{
    [_mViewModel goSelectBank];
}

@end

