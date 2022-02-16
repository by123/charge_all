//
//  SalemanView.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "SalemanView.h"
#import "TouchScrollView.h"

@interface SalemanView()<UITextFieldDelegate>

@property(strong, nonatomic)SalemanViewModel *mViewModel;
@property(strong, nonatomic)UIButton *addBtn;
@property(strong, nonatomic)UITextField *nameTF;
@property(strong, nonatomic)UITextField *phoneTF;
@property(strong, nonatomic)TouchScrollView *scrollView;

@end

@implementation SalemanView

-(instancetype)initWithViewModel:(SalemanViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:nil];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    [self addSubview:_scrollView];
    [self initTop];
    
    _addBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_SAVE textColor:c_btn_txt_normal backgroundColor:c05 corner:0 borderWidth:0 borderColor:nil];
    _addBtn.frame = CGRectMake(0, ContentHeight -  STHeight(50), ScreenWidth, STHeight(50));
    _addBtn.enabled = NO;
    [_addBtn addTarget:self action:@selector(onAddBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
}

-(void)initTop{
    
    NSString *infoStr = @"业务员信息";
    UILabel *infoLabel = [[UILabel alloc]initWithFont:STFont(14) text:infoStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize infoSize = [infoStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    infoLabel.frame = CGRectMake(STWidth(15), STHeight(20), infoSize.width, STHeight(20));
    [_scrollView addSubview:infoLabel];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(50), ScreenWidth, STHeight(100))];
    topView.backgroundColor = cwhite;
    [self buildTitleAndLine:topView];
    
    [_scrollView addSubview:topView];
    
    _nameTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _nameTF.textAlignment = NSTextAlignmentRight;
    _nameTF.placeholder = @"请输入业务员姓名";
    _nameTF.frame = CGRectMake(STWidth(160), 0, STWidth(200),STHeight(50));
    [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [topView addSubview:_nameTF];
    
    _phoneTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _phoneTF.textAlignment = NSTextAlignmentRight;
    _phoneTF.placeholder = @"请输入业务员手机号";
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.delegate = self;
    _phoneTF.maxLength = @"11";
    _phoneTF.frame = CGRectMake(STWidth(160), STHeight(50), STWidth(200),STHeight(50));
    [_phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [topView addSubview:_phoneTF];
    
    
}


-(void)buildTitleAndLine:(UIView *)topView{
    NSArray *titles = @[@"业务员姓名",@"业务员手机"];
    for(int i = 0 ; i < titles.count ; i ++){
        NSString *labelStr = titles[i];
        UILabel *label = [[UILabel alloc]initWithFont:STFont(15) text:labelStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize labelSize = [labelStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        label.frame = CGRectMake(STWidth(15), i * STHeight(50), labelSize.width, STHeight(50));
        [topView addSubview:label];
        
        if(titles.count != i + 1){
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), (i + 1) *  STHeight(50) - LineHeight, STWidth(345), LineHeight)];
            lineView.backgroundColor = cline;
            [topView addSubview:lineView];
        }
    }
    
    
}


- (void)textFieldDidChange:(UITextField *)textField{
    [self changeAddBtnStatu];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


-(void)changeAddBtnStatu{
    if(!IS_NS_STRING_EMPTY(_nameTF.text) &&
       !IS_NS_STRING_EMPTY(_phoneTF.text)){
        [_addBtn setBackgroundColor:c01 forState:UIControlStateNormal];
        _addBtn.enabled = YES;
        [_addBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
    }else{
        [_addBtn setBackgroundColor:c05 forState:UIControlStateNormal];
        _addBtn.enabled = NO;
        [_addBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
    }
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nameTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
    
}




-(void)onAddBtnClicked{
    
    _mViewModel.model.name = _nameTF.text;
    _mViewModel.model.mobile = _phoneTF.text;

    if(_phoneTF.text.length !=11){
        [LCProgressHUD showMessage:@"手机号码输入有误"];
        return;
    }
    if(_mViewModel){
        [_mViewModel addSaleman];
    }
}


@end
