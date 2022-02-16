//
//  HelpView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "HelpView.h"

@interface HelpView()

@property(strong, nonatomic)HelpViewModel *mViewModel;
@property(strong, nonatomic)UILabel *label1;

@end

@implementation HelpView

-(instancetype)initWithViewModel:(HelpViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    _label1 = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
  
    [self addSubview:_label1];
    
    [self updateView];
}

-(void)updateView{
    
    NSString *helpStr = [STUserDefaults getKeyValue:CONFIG_CAPITAL_HELP];
    _label1.text =helpStr;
    CGSize label1Size = [_label1.text sizeWithMaxWidth:STWidth(319)  font:STFont(15)];
    _label1.frame = CGRectMake(STWidth(28), STHeight(20), STWidth(319), label1Size.height);
}

@end

