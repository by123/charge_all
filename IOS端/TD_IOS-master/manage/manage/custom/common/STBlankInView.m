//
//  STBlankInView.m
//  manage
//
//  Created by by.huang on 2018/11/30.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "STBlankInView.h"

@interface STBlankInView ()<UITextFieldDelegate>

@property(copy, nonatomic)NSString *title;
@property(copy, nonatomic)NSString *placeHolder;
@property(strong, nonatomic)UITextField *contentTF;

@end

@implementation STBlankInView


-(instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder{
    if(self == [super init]){
        self.title = title;
        self.placeHolder = placeHolder;
        [self initView];
    }
    return self;
}

-(void)inputNumber{
    if(_contentTF){
        _contentTF.keyboardType = UIKeyboardTypeNumberPad;
        _contentTF.delegate = self;
    }
}


-(void)initView{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, STHeight(50));
    self.backgroundColor = cwhite;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:_title textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [_title sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    titleLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(50));
    [self addSubview:titleLabel];
    
    _contentTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _contentTF.textAlignment = NSTextAlignmentRight;
    [_contentTF setPlaceholder:_placeHolder color:c03 fontSize:STFont(15)];
    _contentTF.returnKeyType = UIReturnKeyNext;
    _contentTF.frame = CGRectMake(STWidth(110), 0, STWidth(250),STHeight(50));
    [_contentTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_contentTF];
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string format:@"0123456789"];
}

- (BOOL)validateNumber:(NSString*)number format:(NSString *)formatStr{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:formatStr];
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

-(void)setContent:(NSString *)content{
    _contentTF.text = content;
}

-(NSString *)getContent{
    return _contentTF.text;
}


- (void)textFieldDidChange:(UITextField *)textField{
    if(_delegate){
        [_delegate onTextFieldDidChange:textField];
    }
}

-(BOOL)resign{
    return [_contentTF resignFirstResponder];
}

@end
