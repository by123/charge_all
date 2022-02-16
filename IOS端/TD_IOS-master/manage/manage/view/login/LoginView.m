//
//  LoginView.m
//  manage
//
//  Created by by.huang on 2018/10/25.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "LoginView.h"
#import "STUserDefaults.h"
#import "STConvertUtil.h"

@interface LoginView()

@property(strong, nonatomic)LoginViewModel *mViewModel;
@property(strong, nonatomic)UITextField *userNameTF;
@property(strong, nonatomic)UITextField *pswTF;
@property(strong, nonatomic)UIButton *loginBtn;
@property(strong, nonatomic)UIButton *forgetBtn;
@property(strong, nonatomic)UIButton *hideBtn;
@property(strong, nonatomic)UIButton  *selectImageView;

@property(strong, nonatomic)UILabel *welcomeLabel;
@property(strong, nonatomic)UILabel *welcome2Label;
@property(strong, nonatomic)UIView *contentView;

@end

@implementation LoginView{
    Boolean isSelect;
}

-(instancetype)initWithViewModel:(LoginViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        isSelect = YES;
        [self initView];
        //监听当键将要弹出时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //监听当键将要退出时
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    WS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.welcomeLabel.alpha = 0;
        weakSelf.welcome2Label.text = @"登录";
        CGSize welcome2Size = [weakSelf.welcome2Label.text sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
        weakSelf.welcome2Label.frame = CGRectMake(STWidth(15), StatuBarHeight + STHeight(10), welcome2Size.width, STHeight(42));
        weakSelf.contentView.frame = CGRectMake(0, STHeight(140), ScreenWidth, STHeight(500));
    }];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
    WS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.welcomeLabel.alpha = 1.0;
        weakSelf.welcome2Label.text = MSG_WELCOME;
        CGSize welcome2Size = [weakSelf.welcome2Label.text sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
        weakSelf.welcome2Label.frame = CGRectMake(STWidth(15), StatuBarHeight + STHeight(72), welcome2Size.width, STHeight(42));
        weakSelf.contentView.frame = CGRectMake(0, STHeight(200), ScreenWidth, STHeight(500));
    }];
}


-(void)initView{
    
    NSString *welcomeStr = @"您好，";
    _welcomeLabel = [[UILabel alloc]initWithFont:STFont(30) text:welcomeStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize welcomeSize = [welcomeStr sizeWithMaxWidth:ScreenWidth font:STFont(30)];
    _welcomeLabel.frame = CGRectMake(STWidth(15), StatuBarHeight +  STHeight(25), welcomeSize.width, STHeight(42));
    [self addSubview:_welcomeLabel];
    
    NSString *welcome2Str = MSG_WELCOME;
    _welcome2Label = [[UILabel alloc]initWithFont:STFont(30) text:welcome2Str textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize welcome2Size = [welcome2Str sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    [_welcome2Label setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    _welcome2Label.frame = CGRectMake(STWidth(15), StatuBarHeight + STHeight(72), welcome2Size.width, STHeight(42));
    [self addSubview:_welcome2Label];
    
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(200), ScreenWidth, STHeight(500))];
    [self addSubview:_contentView];
    
    _userNameTF = [[UITextField alloc]initWithFont:STFont(16) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:STHeight(10)];
    _userNameTF.frame = CGRectMake(STWidth(5), 0, ScreenWidth - STWidth(20),  STHeight(42));
    _userNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_userNameTF setPlaceholder:@"输入账户"];
    [_userNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_contentView addSubview:_userNameTF];
    
    NSString *userNameStr = [STUserDefaults getKeyValue:UD_USERNAME];
    if(!IS_NS_STRING_EMPTY(userNameStr)){
        _userNameTF.text = userNameStr;
    }

    
    UIView *userlineView =[[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(42) - LineHeight, ScreenWidth - STWidth(30), LineHeight)];
    userlineView.backgroundColor = cline;
    [_contentView addSubview:userlineView];
    
    _pswTF = [[UITextField alloc]initWithFont:STFont(16) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:STHeight(10)];
    _pswTF.frame = CGRectMake(STWidth(5), STHeight(74), ScreenWidth - STWidth(20),  STHeight(42));
    _pswTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _pswTF.secureTextEntry = YES;
    [_pswTF setPlaceholder:@"输入密码"];
    _pswTF.maxLength = @"20";
    [_pswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_contentView addSubview:_pswTF];
    
    UIView *pswlineView =[[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(116) - LineHeight, ScreenWidth - STWidth(30), LineHeight)];
    pswlineView.backgroundColor = cline;
    [_contentView addSubview:pswlineView];
    
    _hideBtn = [[UIButton alloc]init];
    _hideBtn.frame = CGRectMake(ScreenWidth - STWidth(80) , STHeight(74), STWidth(42), STHeight(42));
    [_hideBtn setImage:[STConvertUtil imageResize:[UIImage imageNamed:IMAGE_PSW_VISIBLE] andResizeTo:CGSizeMake(STWidth(18), STWidth(18))] forState:UIControlStateNormal];
    _hideBtn.hidden = YES;
    [_hideBtn addTarget:self action:@selector(onHideBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_hideBtn];

    
    _loginBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"登录" textColor:c_btn_txt_normal backgroundColor:c03 corner:0 borderWidth:0 borderColor:nil];
    [_loginBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    _loginBtn.frame = CGRectMake(STWidth(15), STHeight(148) + StatuBarHeight, ScreenWidth - STWidth(30),  STHeight(50));
    [_loginBtn addTarget:self action:@selector(onLoginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_loginBtn];
    
    
    _forgetBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"忘记密码" textColor:c06 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    CGSize forgetSize = [_forgetBtn.titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _forgetBtn.frame = CGRectMake(ScreenWidth - forgetSize.width - STWidth(15), STHeight(218) + StatuBarHeight, forgetSize.width,  STHeight(21));
    [_forgetBtn addTarget:self action:@selector(onForgetBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_forgetBtn];
    

    
    _selectImageView = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(15),StatuBarHeight + STHeight(218) +(STHeight(21) - STWidth(16))/2 , STWidth(16), STWidth(16))];
    [_selectImageView setSelected:isSelect];
    [_selectImageView setImage:[UIImage imageNamed:IMAGE_AGREE_NORMAL] forState:UIControlStateNormal];
    [_selectImageView setImage:[UIImage imageNamed:IMAGE_AGREE_PRESSED] forState:UIControlStateSelected];
    _selectImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_selectImageView addTarget:self action:@selector(onSelectClicked) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_selectImageView];
    
    UIButton *agreeBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"已同意用户协议" textColor:c11 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    CGSize agreeSize = [agreeBtn.titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    agreeBtn.frame = CGRectMake(STWidth(36), STHeight(218) + StatuBarHeight, agreeSize.width, STHeight(21));
    [agreeBtn addTarget:self action:@selector(onAgreeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:agreeBtn];

    [self changeLoginBtnStatu];
   
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_userNameTF resignFirstResponder];
    [_pswTF resignFirstResponder];
}


- (void)textFieldDidChange:(UITextField *)textField{
    if(textField == _pswTF){
        _hideBtn.hidden = IS_NS_STRING_EMPTY(textField.text) ? YES : NO;
    }
    
    [self changeLoginBtnStatu];
}

-(void)changeLoginBtnStatu{
    if(!IS_NS_STRING_EMPTY(_userNameTF.text) && !IS_NS_STRING_EMPTY(_pswTF.text) && isSelect && _pswTF.text.length >= 6){
        [_loginBtn setBackgroundColor:c01 forState:UIControlStateNormal];
        _loginBtn.enabled = YES;
        [_loginBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
    }else{
        [_loginBtn setBackgroundColor:c03 forState:UIControlStateNormal];
        _loginBtn.enabled = NO;
        [_loginBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
    }
}


-(void)onLoginBtnClicked{
    if(_mViewModel){
        [_mViewModel doLogin:_userNameTF.text psw:_pswTF.text];
    }

}

-(void)onForgetBtnClicked{
    if(_mViewModel){
        [_mViewModel goForgetPswPage];
    }
}


-(void)onHideBtnClicked{
    if(_pswTF.secureTextEntry){
        _pswTF.secureTextEntry = NO;
        [_hideBtn setImage:[STConvertUtil imageResize:[UIImage imageNamed:IMAGE_PSW_HIDDEN] andResizeTo:CGSizeMake(STWidth(18), STWidth(18))] forState:UIControlStateNormal];
     
    }else{
        _pswTF.secureTextEntry = YES;
        [_hideBtn setImage:[STConvertUtil imageResize:[UIImage imageNamed:IMAGE_PSW_VISIBLE] andResizeTo:CGSizeMake(STWidth(18), STWidth(18))] forState:UIControlStateNormal];
    }
}

-(void)onSelectClicked{
    isSelect = !isSelect;
    [self changeLoginBtnStatu];
    [_selectImageView setSelected:isSelect];
}

-(void)onAgreeBtnClicked{
    if(_mViewModel){
        [_mViewModel goAgreementPage];
    }
}



@end
