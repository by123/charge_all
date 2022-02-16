//
//  STPriceView.m
//  manage
//
//  Created by by.huang on 2018/11/3.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "STPriceView.h"

@interface STPriceView()<UITextFieldDelegate>

@property(strong, nonatomic)UITextField *priceTF;

@end
@implementation STPriceView

-(instancetype)init{
    if(self == [super init]){
        [self initView];
    }
    return self;
}


-(void)initView{
    self.frame = CGRectMake(0, 0, STWidth(122), STHeight(36));
    self.layer.borderColor = c11.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    
    _priceTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
    _priceTF.frame = CGRectMake(STWidth(10), 0, STWidth(88), STHeight(36));
    _priceTF.textAlignment = NSTextAlignmentLeft;
    _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTF.delegate = self;
    _priceTF.placeholder = @"0";
    [_priceTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_priceTF];
    
    UILabel *perlabel = [[UILabel alloc]initWithFont:STFont(15) text:@"元" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize perSize = [@"元" sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    perlabel.frame = CGRectMake(STWidth(112) - perSize.width, 0, perSize.width, STHeight(36));
    [self addSubview:perlabel];
}


-(UITextField *)getPriceTF{
    return _priceTF;
}


-(void)setPrice:(NSString *)price{
    _priceTF.text = price;
}

- (void)textFieldDidChange:(UITextField *)textField{
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
//    if([content floatValue] < 2){
//        [LCProgressHUD showMessage:@"金额不能低于2元"];
//        _priceTF.text = MSG_EMPTY;
//    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
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

@end
