//
//  STProfitView.m
//  manage
//
//  Created by by.huang on 2019/7/12.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STProfitView.h"

@interface STProfitView()<UITextFieldDelegate>

@property(strong, nonatomic)UIView *absoluteView;
@property(strong, nonatomic)UIView *relativeView;
@property(strong, nonatomic)UILabel *cutLabel;
@property(strong, nonatomic)UIButton *cutBtn;

//绝对
@property(strong, nonatomic)UITextField *profitPercentTF;

@property(strong, nonatomic)UITextField *profitPoolPercentTF;
@property(strong, nonatomic)UITextField *profitPercentInPoolTF;

@property(strong, nonatomic)UILabel *absoluteLabel;
@property(strong, nonatomic)UILabel *relativeLabel;



@property(assign, nonatomic)CGFloat totalPercent;
@property(assign, nonatomic)CGFloat allocPercent;


@end

@implementation STProfitView

-(instancetype)initWithFrame:(CGRect)frame totalPercent:(CGFloat)totalPercent allocPercent:(CGFloat)allocPercent{
    if(self == [super initWithFrame:frame]){
        _totalPercent = totalPercent;
        _allocPercent = allocPercent;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    [self initTitleView];
    [self initAbsoluteView];
    [self initRelativeView];
}

-(void)initTitleView{
    UILabel *infoLabel = [[UILabel alloc]initWithFont:STFont(14) text:@"商户分润" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize infoSize = [infoLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    infoLabel.frame = CGRectMake(STWidth(15), 0, infoSize.width, STHeight(50));
    [self addSubview:infoLabel];
    
    _cutBtn = [[UIButton alloc]init];
    [_cutBtn addTarget:self action:@selector(onCutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cutBtn];
    
    _cutLabel = [[UILabel alloc]initWithFont:STFont(14) text:@"按相对分润比例" textAlignment:NSTextAlignmentCenter textColor:c06 backgroundColor:nil multiLine:NO];
    CGSize cutSize = [_cutLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _cutLabel.frame = CGRectMake(0, 0, cutSize.width, STHeight(50));
    [_cutBtn addSubview:_cutLabel];
    
    UIImageView *cutImageView = [[UIImageView alloc]initWithFrame:CGRectMake(cutSize.width+STWidth(5), (STHeight(50) - STWidth(14))/2, STWidth(14), STWidth(14))];
    cutImageView.image = [UIImage imageNamed:IMAGE_CUT];
    cutImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_cutBtn addSubview:cutImageView];
    
    _cutBtn.frame = CGRectMake(ScreenWidth - (cutSize.width + STWidth(34)), 0, cutSize.width + STWidth(34), STHeight(50));
}


-(void)hiddenRelative:(Boolean)hidden{
    _cutBtn.hidden = hidden;
}

-(void)initAbsoluteView{
    _absoluteView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(50), ScreenWidth, STHeight(100))];
    _absoluteView.backgroundColor = cwhite;
    [self addSubview:_absoluteView];
    
    _profitPercentTF = [self buildItem:_absoluteView title:@"设置商户分润比例" height:0 enable:YES showLine:YES];
    _absoluteLabel = [self buildTipsView:_absoluteView height:STHeight(50)];
    
}

-(void)initRelativeView{
    
    _relativeView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(50), ScreenWidth, STHeight(192))];
    _relativeView.backgroundColor = cwhite;
    _relativeView.hidden = YES;
    [self addSubview:_relativeView];
    
    _profitPoolPercentTF = [self buildItem:_relativeView title:@"设置分润池" height:0 enable:YES showLine:YES];
    _profitPoolPercentTF.text = IntStr((int)_totalPercent);
    
    _profitPercentInPoolTF = [self buildItem:_relativeView title:@"设置商户相对分润比例" height:STHeight(50) enable:YES showLine:YES];
    _realPercentTF = [self buildItem:_relativeView title:@"实际分润比例" height:STHeight(100) enable:NO showLine:NO];

    _relativeLabel = [self buildTipsView:_relativeView height:STHeight(142)];
    

}


-(UITextField *)buildItem:(UIView *)view title:(NSString *)title height:(CGFloat)height enable:(Boolean)enable showLine:(Boolean)showLine{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:title textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize labelSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    titleLabel.frame = CGRectMake(STWidth(15), height, labelSize.width, STHeight(50));
    [view addSubview:titleLabel];

    UITextField *textField = [[UITextField alloc]initWithFont:STFont(20) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    textField.textAlignment = NSTextAlignmentRight;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    if(enable){
        textField.maxLength = @"2";
    }
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    textField.frame = CGRectMake(STWidth(90), height, STWidth(250),STHeight(50));
    textField.delegate = self;
    textField.enabled = enable;
    [view addSubview:textField];

    UILabel *profitLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"%" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    profitLabel.frame = CGRectMake(ScreenWidth -  STWidth(30), height, STWidth(15), STHeight(50));
    [view addSubview:profitLabel];
    
    if(showLine){
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15),  height + STHeight(50) - LineHeight, STWidth(345), LineHeight)];
        lineView.backgroundColor = cline;
        [view addSubview:lineView];
    }
    return textField;
}

-(UILabel *)buildTipsView:(UIView *)view height:(CGFloat)height{
    UIImageView *tipImageView = [[UIImageView alloc]init];
    tipImageView.image = [UIImage imageNamed:IMAGE_TIPS];
    tipImageView.contentMode = UIViewContentModeScaleAspectFill;
    tipImageView.frame = CGRectMake(STWidth(15), height + (STHeight(50) - STWidth(14))/2 ,STWidth(14) , STWidth(14));
    [view addSubview:tipImageView];


    UILabel *profitLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:profitLabel];
    [self updateTipsView:_allocPercent height:height label:profitLabel];
    return profitLabel;

}

-(void)updateTipsView:(CGFloat)percent height:(CGFloat)height label:(UILabel *)lable{
    NSString *profitStr= [NSString stringWithFormat:MSG_PROFIT_TOTAL,_totalPercent,_totalPercent-percent];
    CGSize profitSize = [profitStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    if(profitSize.width  + STWidth(34-15)> STWidth(345)){
        [lable setFont:[UIFont systemFontOfSize:STFont(13)]];
        profitSize = [profitStr sizeWithMaxWidth:ScreenWidth font:STFont(13)];
    }
    lable.frame = CGRectMake(STWidth(34), height, profitSize.width, STHeight(50));
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:profitStr];
    NSRange range1=[[hintString string]rangeOfString:MSG_PROFIT_RANGE1];
    [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range1];
    
    NSRange range2=[[hintString string]rangeOfString:MSG_PROFIT_RANGE2];
    [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range2];
    
    lable.attributedText=hintString;
}

-(void)updateTips:(CGFloat)totalPercent allocPercent:(CGFloat)allocPercent{
    _totalPercent = totalPercent;
    _allocPercent = allocPercent;
    if(_isRelative){
        [self updateTipsView:_allocPercent height:STHeight(142) label:_relativeLabel];
    }else{
        [self updateTipsView:_allocPercent height:STHeight(50) label:_absoluteLabel];
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
    if(textField == _profitPercentTF){
        if(_totalPercent < [_profitPercentTF.text doubleValue]){
            [LCProgressHUD showMessage:@"不能超过您可分配的分润比例"];
            return;
        }
        [self updateTipsView:[textField.text doubleValue] height:STHeight(50) label:_absoluteLabel];
    }else if(textField == _profitPoolPercentTF){
        if(_totalPercent < [_profitPoolPercentTF.text doubleValue]){
            [LCProgressHUD showMessage:@"不能超过您可分配的分润比例"];
            return;
        }
        if(!IS_NS_STRING_EMPTY(_profitPercentInPoolTF.text)){
            [self updateRealPercent];
        }
    }else if(textField == _profitPercentInPoolTF){
        if(!IS_NS_STRING_EMPTY(_profitPoolPercentTF.text)){
            [self updateRealPercent];
        }
    }
    if(_delegate){
        [_delegate onProfitTextFieldDidChange];
    }
}

-(void)updateRealPercent{
    _realPercentTF.text = DoubleStr([_profitPoolPercentTF.text doubleValue] * [_profitPercentInPoolTF.text doubleValue] / 100);
    [self updateTipsView: [_realPercentTF.text doubleValue] height:STHeight(142) label:_relativeLabel];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_profitPercentTF resignFirstResponder];
    [_profitPoolPercentTF resignFirstResponder];
    [_profitPercentInPoolTF resignFirstResponder];
    [_realPercentTF resignFirstResponder];
}

-(void)changeAbsoluteProfitView{
    _isRelative = NO;
    _relativeView.hidden = !_isRelative;
    _absoluteView.hidden = _isRelative;
    _cutLabel.text = _isRelative ? @"按绝对分润比例" : @"按相对分润比例";
    
    if(_delegate){
        [_delegate onChangeProfitView:_isRelative];
    }
}

-(void)onCutBtnClick{
    _isRelative = !_isRelative;
    _relativeView.hidden = !_isRelative;
    _absoluteView.hidden = _isRelative;
    _cutLabel.text = _isRelative ? @"按绝对分润比例" : @"按相对分润比例";
    
    if(_delegate){
        [_delegate onChangeProfitView:_isRelative];
    }
}


-(NSString *)getProfitPercent{
    if(_isRelative){
        return IS_NS_STRING_EMPTY(_realPercentTF.text) ? MSG_EMPTY : _realPercentTF.text;
    }else{
        return IS_NS_STRING_EMPTY(_profitPercentTF.text) ? MSG_EMPTY : _profitPercentTF.text;
    }
}

-(NSString *)getProfitPool{
    return IS_NS_STRING_EMPTY(_profitPoolPercentTF.text) ? MSG_EMPTY : _profitPoolPercentTF.text;

}

-(NSString *)getProfitPercentInPool{
    return IS_NS_STRING_EMPTY(_profitPercentInPoolTF.text) ? MSG_EMPTY : _profitPercentInPoolTF.text;
}

-(void)setProfitPercent:(NSString *)percentStr{
    _profitPercentTF.text = percentStr;
}


-(void)resignFirstResponder{
    [_profitPercentTF resignFirstResponder];
    [_profitPoolPercentTF resignFirstResponder];
    [_profitPercentInPoolTF resignFirstResponder];
    [_realPercentTF resignFirstResponder];
}

-(Boolean)isProfitFill{
    if(_isRelative){
        if(!IS_NS_STRING_EMPTY(_profitPoolPercentTF.text)  && !IS_NS_STRING_EMPTY(_profitPercentInPoolTF.text)){
            return YES;
        }
        return NO;
    }else{
        if(!IS_NS_STRING_EMPTY(_profitPercentTF.text)){
            return YES;
        }
        return NO;
    }
}

@end
