//
//  ForgetPswView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ForgetPswView.h"
#import "STUserDefaults.h"

@interface ForgetPswView()

@property(strong, nonatomic)ForgetPswViewModel *mViewModel;
@property(strong, nonatomic)UIButton *nextBtn;

@property(strong, nonatomic)UIView *step1View;
@property(strong, nonatomic)UITextField *accountTF;


@property(strong, nonatomic)UIView *step2View;
@property(strong, nonatomic)UITextField *verifyCodeTF;
@property(strong, nonatomic)UILabel *timeLabel;
@property(strong, nonatomic)UIButton *reSendBtn;
@property(strong, nonatomic)UILabel *tipsLabel;

@property(strong, nonatomic)UIView *step3View;
@property(strong, nonatomic)UITextField *pswTF;
@property(strong, nonatomic)UITextField *rePswTF;
@property(strong, nonatomic)UIButton *hidePswBtn;
@property(strong, nonatomic)UIButton *hiderePswBtn;



@end

@implementation ForgetPswView{
    int count;
    int step;
}

-(instancetype)initWithViewModel:(ForgetPswViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        count = 60;
        step = 0;
        [self initView];
    }
    return self;
}

-(void)initView{
    NSString *findPswStr = @"找回密码";
    UILabel *findPswLabel = [[UILabel alloc]initWithFont:STFont(30) text:findPswStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize findPswSize = [findPswStr sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    [findPswLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    findPswLabel.frame = CGRectMake(STWidth(15), STHeight(10), findPswSize.width, STHeight(42));
    [self addSubview:findPswLabel];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:IMAGE_CLOSE] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(ScreenWidth - STWidth(63), STHeight(18), STWidth(30), STWidth(30));
    [closeBtn addTarget:self action:@selector(onCloseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    //步骤1
    [self initStep1];
    
    //步骤2
    [self initStep2];
    
    //步骤3
    [self initStep3];
    
    //下一步
    _nextBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"下一步" textColor:c_btn_txt_highlight backgroundColor:c03 corner:2 borderWidth:0 borderColor:nil];
    [_nextBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    _nextBtn.frame = CGRectMake(STWidth(15), STHeight(287), STWidth(345), STHeight(50));
    [_nextBtn addTarget:self action:@selector(onNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextBtn];
    
    [self changeNextBtnStatu:_accountTF other:nil];
}


-(void)initStep1{
    _step1View = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(72), ScreenWidth, STHeight(50))];
    [self addSubview:_step1View];
    
    _accountTF = [[UITextField alloc]initWithFont:STFont(16) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:STHeight(10)];
    _accountTF.frame = CGRectMake(STWidth(5), 0, ScreenWidth - STWidth(20),  STHeight(42));
    _accountTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_accountTF setPlaceholder:@"输入登录账号"];
    _accountTF.maxLength = @"20";
    [_accountTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_step1View addSubview:_accountTF];
    
    
    NSString *userNameStr = [STUserDefaults getKeyValue:UD_USERNAME];
    if(!IS_NS_STRING_EMPTY(userNameStr)){
        _accountTF.text = userNameStr;
    }
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(42) - LineHeight, ScreenWidth - STWidth(30), LineHeight)];
    lineView.backgroundColor = cline;
    [_step1View addSubview:lineView];
}

-(void)initStep2{
    _step2View = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, STHeight(72), ScreenWidth, STHeight(100))];
    [self addSubview:_step2View];
    
    _tipsLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [_step2View addSubview:_tipsLabel];
    
    _verifyCodeTF = [[UITextField alloc]initWithFont:STFont(16) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:STHeight(10)];
    _verifyCodeTF.frame = CGRectMake(STWidth(5), STHeight(42), ScreenWidth - STWidth(20),  STHeight(42));
    [_verifyCodeTF setPlaceholder:@"输入验证码"];
    _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _verifyCodeTF.maxLength = @"8";
    [_verifyCodeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_step2View addSubview:_verifyCodeTF];
    
    NSString *timeStr = @"60秒";
    _timeLabel = [[UILabel alloc]initWithFont:STFont(16) text:timeStr textAlignment:NSTextAlignmentCenter textColor:c06 backgroundColor:nil multiLine:NO];
    CGSize timeSize = [_timeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(16)];
    _timeLabel.frame = CGRectMake(ScreenWidth - STWidth(15) - timeSize.width, STHeight(52), timeSize.width, STHeight(22));
    [_step2View addSubview:_timeLabel];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(84) - LineHeight, ScreenWidth - STWidth(30), LineHeight)];
    lineView.backgroundColor = cline;
    [_step2View addSubview:lineView];
    
    _reSendBtn = [[UIButton alloc]init];
    _reSendBtn.frame = CGRectMake(ScreenWidth - STWidth(100), STHeight(42), STWidth(100), STHeight(42));
    _reSendBtn.hidden = YES;
    [_reSendBtn addTarget:self action:@selector(onResendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_step2View addSubview:_reSendBtn];
}

-(void)initStep3{
    _step3View = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, STHeight(72), ScreenWidth, STHeight(150))];
    [self addSubview:_step3View];
    
    NSString *step3TitleStr = @"验证通过，请设置您的新密码";
    UILabel *step3TitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:step3TitleStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize step3TitleSize = [step3TitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    step3TitleLabel.frame = CGRectMake(STWidth(15), 0, step3TitleSize.width, STHeight(22));
    [_step3View addSubview:step3TitleLabel];
    
    _pswTF = [[UITextField alloc]initWithFont:STFont(16) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:STHeight(10)];
    _pswTF.frame = CGRectMake(STWidth(5), STHeight(42), ScreenWidth - STWidth(20),  STHeight(42));
    _pswTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _pswTF.secureTextEntry = YES;
    [_pswTF setPlaceholder:@"请输入新密码，不少于六位"];
    _pswTF.maxLength = @"20";
    [_pswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_step3View addSubview:_pswTF];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(84) - LineHeight, ScreenWidth - STWidth(30), LineHeight)];
    lineView.backgroundColor = cline;
    [_step3View addSubview:lineView];
    
    _rePswTF = [[UITextField alloc]initWithFont:STFont(16) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:STHeight(10)];
    _rePswTF.frame = CGRectMake(STWidth(5), STHeight(106), ScreenWidth - STWidth(20),  STHeight(42));
    _rePswTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _rePswTF.secureTextEntry = YES;
    [_rePswTF setPlaceholder:@"请再次输入新密码"];
    _rePswTF.maxLength = @"20";
    [_rePswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_step3View addSubview:_rePswTF];
    
    UIView *lineView2 =[[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(148) - LineHeight, ScreenWidth - STWidth(30), LineHeight)];
    lineView2.backgroundColor = cline;
    [_step3View addSubview:lineView2];
    
    _hidePswBtn = [[UIButton alloc]init];
    _hidePswBtn.frame = CGRectMake(ScreenWidth - STWidth(80) , STHeight(42), STWidth(42), STHeight(42));
    [_hidePswBtn setImage:[STConvertUtil imageResize:[UIImage imageNamed:IMAGE_PSW_VISIBLE] andResizeTo:CGSizeMake(STWidth(18), STWidth(18))] forState:UIControlStateNormal];
    _hidePswBtn.hidden = YES;
    [_hidePswBtn addTarget:self action:@selector(onHideBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_step3View addSubview:_hidePswBtn];
    
    _hiderePswBtn = [[UIButton alloc]init];
    _hiderePswBtn.frame = CGRectMake(ScreenWidth - STWidth(80) , STHeight(106), STWidth(42), STHeight(42));
    [_hiderePswBtn setImage:[STConvertUtil imageResize:[UIImage imageNamed:IMAGE_PSW_VISIBLE] andResizeTo:CGSizeMake(STWidth(18), STWidth(18))] forState:UIControlStateNormal];
    _hiderePswBtn.hidden = YES;
    [_hiderePswBtn addTarget:self action:@selector(onHideBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_step3View addSubview:_hiderePswBtn];
}

-(void)onHideBtnClicked:(id)sender{
    UIButton *btn = sender;
    if(btn == _hidePswBtn){
        if(_pswTF.secureTextEntry){
            _pswTF.secureTextEntry = NO;
            [btn setImage:[STConvertUtil imageResize:[UIImage imageNamed:IMAGE_PSW_HIDDEN] andResizeTo:CGSizeMake(STWidth(18), STWidth(18))] forState:UIControlStateNormal];
            
        }else{
            _pswTF.secureTextEntry = YES;
            [btn setImage:[STConvertUtil imageResize:[UIImage imageNamed:IMAGE_PSW_VISIBLE] andResizeTo:CGSizeMake(STWidth(18), STWidth(18))] forState:UIControlStateNormal];
        }
    }else if(btn == _hiderePswBtn){
        if(_rePswTF.secureTextEntry){
            _rePswTF.secureTextEntry = NO;
            [btn setImage:[STConvertUtil imageResize:[UIImage imageNamed:IMAGE_PSW_HIDDEN] andResizeTo:CGSizeMake(STWidth(18), STWidth(18))] forState:UIControlStateNormal];
            
        }else{
            _rePswTF.secureTextEntry = YES;
            [btn setImage:[STConvertUtil imageResize:[UIImage imageNamed:IMAGE_PSW_VISIBLE] andResizeTo:CGSizeMake(STWidth(18), STWidth(18))] forState:UIControlStateNormal];
        }
    }
 
}


-(void)updateView{
    
}

-(void)updateStep1{
    _tipsLabel.text = [NSString stringWithFormat:@"验证码已发送至账号关联手机（%@）",[STPUtil getSecretPhoneNum:_mViewModel.phoneNum]];
    CGSize tipsSize = [_tipsLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _tipsLabel.frame = CGRectMake(STWidth(15), 0, tipsSize.width, STHeight(22));

    WS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.step1View.frame = CGRectMake(-ScreenWidth, STHeight(72), ScreenWidth, STHeight(50));
        weakSelf.step2View.frame = CGRectMake(0, STHeight(72), ScreenWidth, STHeight(100));
    }];
    [_verifyCodeTF becomeFirstResponder];
    [self changeNextBtnStatu:_verifyCodeTF other:nil];
    [self startCount];
    step ++;
}

-(void)updateStep2{
    WS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.step2View.frame = CGRectMake(-ScreenWidth, STHeight(72), ScreenWidth, STHeight(100));
        weakSelf.step3View.frame = CGRectMake(0, STHeight(72), ScreenWidth, STHeight(150));
    }];
    [self changeNextBtnComplete];
    step ++;
}

-(void)updateStep3{
    if(_mViewModel){
        [_mViewModel closePage];
    }
}

-(void)onCloseBtnClicked{
    if(_mViewModel){
        [_mViewModel closePage];
    }
}

-(void)onNextBtnClick{
    if(step == 0){
        if(_mViewModel){
            [_mViewModel getVerifyCode:_accountTF.text];
        }
    }
    else if(step == 1){
        if(_mViewModel){
            [_mViewModel checkVerifyCode:_verifyCodeTF.text];
        }
    }else{
        if([_pswTF.text isEqualToString:_rePswTF.text]){
            if(_mViewModel){
                [_mViewModel resetPsw:_pswTF.text];
            }
        }else{
            [LCProgressHUD showMessage:@"两次输入密码不一致，请重新输入"];
        }

    }

}

- (void)textFieldDidChange:(UITextField *)textField{
    if(textField == _accountTF){
        [self changeNextBtnStatu:_accountTF other:nil];
    }else if(textField == _verifyCodeTF){
        [self changeNextBtnStatu:_verifyCodeTF other:nil];
    }else if(textField == _pswTF || textField == _rePswTF){
        if(textField == _pswTF){
            _hidePswBtn.hidden = IS_NS_STRING_EMPTY(textField.text) ? YES : NO;
        }else if(textField == _rePswTF){
            _hiderePswBtn.hidden = IS_NS_STRING_EMPTY(textField.text) ? YES : NO;;
        }
        
        [self changeNextBtnStatu:_pswTF other:_rePswTF];
    }
}

-(void)changeNextBtnStatu:(UITextField *)textField other:(UITextField *)textField2{
    if(textField2 == nil){
        if(!IS_NS_STRING_EMPTY(textField.text)){
            [self enableNextBtn];
            return;
        }
    }else{
        if(!IS_NS_STRING_EMPTY(textField.text) && !IS_NS_STRING_EMPTY(textField2.text)){
            [self enableNextBtn];
            return;
        }
    }
    [self disabledNextBtn];
}


-(void)enableNextBtn{
    [_nextBtn setBackgroundColor:c01 forState:UIControlStateNormal];
    _nextBtn.enabled = YES;
    [_nextBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
}

-(void)disabledNextBtn{
    [_nextBtn setBackgroundColor:c03 forState:UIControlStateNormal];
    _nextBtn.enabled = NO;
    [_nextBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
}

-(void)changeNextBtnComplete{
    [_nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self disabledNextBtn];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_accountTF resignFirstResponder];
    [_verifyCodeTF resignFirstResponder];
    [_rePswTF resignFirstResponder];
    [_pswTF resignFirstResponder];
}

-(void)onResendBtnClick{
    if(_mViewModel){
        [_mViewModel getVerifyCode:_accountTF.text];
    }
}

-(void)startCount{
    [self updateCountLabel];
}

-(void)updateCountLabel{
    count --;
    if(count <= 0){
        _timeLabel.text = @"重新获取";
        CGSize timeSize = [_timeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(16)];
        _timeLabel.frame = CGRectMake(ScreenWidth - STWidth(15) - timeSize.width, STHeight(52), timeSize.width, STHeight(22));
        _reSendBtn.hidden = NO;
        count = 60;
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%d秒",count];
        CGSize timeSize = [_timeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(16)];
        _timeLabel.frame = CGRectMake(ScreenWidth - STWidth(15) - timeSize.width, STHeight(52), timeSize.width, STHeight(22));
        [self performSelector:@selector(updateCountLabel) withObject:self afterDelay:1.0f];
    }
}

@end

