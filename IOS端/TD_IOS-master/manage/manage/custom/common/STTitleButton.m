//
//  STTitleButton.m
//  manage
//
//  Created by by.huang on 2018/10/26.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "STTitleButton.h"

@interface STTitleButton()

@property(copy, nonatomic)NSString *mTitle;
@property(copy, nonatomic)NSString *mContent;
@property(strong, nonatomic)UILabel *mainLabel;
@property(strong, nonatomic)UILabel *subLabel;

@end

@implementation STTitleButton

-(instancetype)initWithTitle:(NSString *)title content:(NSString *)content width:(CGFloat)width height:(CGFloat)height{
    if(self == [super init]){
        _mTitle = title;
        _mContent = content;
        self.frame = CGRectMake(0, 0, width,height);
        [self initView];
    }
    return self;
}

-(void)initView{
    _mainLabel = [[UILabel alloc]initWithFont:STFont(20) text:_mTitle textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [_mainLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    _mainLabel.frame = CGRectMake(0, STHeight(7), self.frame.size.width, STHeight(28));
    [self addSubview:_mainLabel];
    
    _subLabel = [[UILabel alloc]initWithFont:STFont(12) text:_mContent textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _subLabel.frame = CGRectMake(0, STHeight(36), self.frame.size.width, STHeight(17));
    [self addSubview:_subLabel];
}

-(void)setMainTitle:(NSString *)title{
    if([title containsString:@"¥"]){
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:title];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_REGULAR size:STFont(12)] range:NSMakeRange(0, 1)];
        [_mainLabel setAttributedText:noteStr];

    }else{
        _mainLabel.text = title;
    }
}

@end
