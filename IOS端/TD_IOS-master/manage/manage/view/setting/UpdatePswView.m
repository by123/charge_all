//
//  UpdatePswView.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "UpdatePswView.h"

@interface UpdatePswView ()

@property(strong, nonatomic)UpdatePswViewModel *mViewModel;
@property(strong, nonatomic)UITextField *mOldPswTF;
@property(strong, nonatomic)UITextField *mNewPswTF;
@property(strong, nonatomic)UITextField *mReNewPswTF;
@property(strong, nonatomic)UIButton *saveBtn;


@end

@implementation UpdatePswView

-(instancetype)initWithModel:(UpdatePswViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    
     //旧密码
    UIView *oldView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(15), ScreenWidth, STHeight(50))];
    oldView.backgroundColor = cwhite;
    [self addSubview:oldView];
    
    UILabel *oldLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"当前密码" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize oldSize = [oldLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    oldLabel.frame = CGRectMake(STWidth(15), 0, oldSize.width, STHeight(50));
    [oldView addSubview:oldLabel];
    
    _mOldPswTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
    _mOldPswTF.placeholder = @"请输入当前密码";
    _mOldPswTF.textAlignment = NSTextAlignmentRight;
    _mOldPswTF.frame = CGRectMake(ScreenWidth/2 - STWidth(15), 0, ScreenWidth/2, STHeight(50));
    [_mOldPswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _mOldPswTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _mOldPswTF.secureTextEntry = YES;
    [oldView addSubview:_mOldPswTF];

    
    
    //新密码
    UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(80), ScreenWidth, STHeight(50))];
    newView.backgroundColor = cwhite;
    [self addSubview:newView];
    
    UILabel *newLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"新密码" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize newSize = [newLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    newLabel.frame = CGRectMake(STWidth(15), 0, newSize.width, STHeight(50));
    [newView addSubview:newLabel];
    
    _mNewPswTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
    _mNewPswTF.placeholder = @"请输入新密码";
    _mNewPswTF.textAlignment = NSTextAlignmentRight;
    _mNewPswTF.frame = CGRectMake(ScreenWidth/2 - STWidth(15), 0, ScreenWidth/2, STHeight(50));
    [_mNewPswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _mNewPswTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _mNewPswTF.secureTextEntry = YES;
    
    [newView addSubview:_mNewPswTF];

    
    

    //重复新密码
    UIView *reNewView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(130), ScreenWidth, STHeight(50))];
    reNewView.backgroundColor = cwhite;
    [self addSubview:reNewView];
    
    UILabel *reNewLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"确认新密码" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize reNewSize = [reNewLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    reNewLabel.frame = CGRectMake(STWidth(15), 0, reNewSize.width, STHeight(50));
    [reNewView addSubview:reNewLabel];
    
    _mReNewPswTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
    _mReNewPswTF.placeholder = @"请再次输入确认新密码";
    _mReNewPswTF.textAlignment = NSTextAlignmentRight;
    _mReNewPswTF.frame = CGRectMake(ScreenWidth/2 - STWidth(15), 0, ScreenWidth/2, STHeight(50));
    [_mReNewPswTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _mReNewPswTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _mReNewPswTF.secureTextEntry = YES;
    [reNewView addSubview:_mReNewPswTF];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(130), ScreenWidth, LineHeight)];
    lineView.backgroundColor = cline;
    [self addSubview:lineView];
    
    
    _saveBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_SAVE textColor:c_btn_txt_normal backgroundColor:c03 corner:0 borderWidth:0 borderColor:nil];
    [_saveBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    _saveBtn.frame = CGRectMake(STWidth(15), ContentHeight - STHeight(140), ScreenWidth - STWidth(30),  STHeight(50));
    [_saveBtn addTarget:self action:@selector(onSaveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveBtn];
    
}


- (void)textFieldDidChange:(UITextField *)textField{
    [self changeLoginBtnStatu];
}

-(void)changeLoginBtnStatu{
    if(!IS_NS_STRING_EMPTY(_mNewPswTF.text) && !IS_NS_STRING_EMPTY(_mOldPswTF.text) && !IS_NS_STRING_EMPTY(_mReNewPswTF.text)){
        [_saveBtn setBackgroundColor:c01 forState:UIControlStateNormal];
        _saveBtn.enabled = YES;
        [_saveBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
    }else{
        [_saveBtn setBackgroundColor:c03 forState:UIControlStateNormal];
        _saveBtn.enabled = NO;
        [_saveBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
    }
}


-(void)onSaveBtnClicked{
    if(![_mNewPswTF.text isEqualToString:_mReNewPswTF.text]){
        [LCProgressHUD showFailure:@"两次输入密码不一致，请重新输入"];
        return;
    }
    if(_mViewModel){
        [_mViewModel updatePsw:_mOldPswTF.text newPsw:_mNewPswTF.text reNewPsw:_mReNewPswTF.text];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_mOldPswTF resignFirstResponder];
    [_mNewPswTF resignFirstResponder];
    [_mReNewPswTF resignFirstResponder];

}


@end
