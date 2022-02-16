//
//  ResetSuccessView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ResetSuccessView.h"

@interface ResetSuccessView()

@property(strong, nonatomic)ResetSuccessViewModel *mViewModel;

@end

@implementation ResetSuccessView

-(instancetype)initWithViewModel:(ResetSuccessViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(82))/2, STHeight(72), STWidth(82), STWidth(100))];
    imageView.image = [UIImage imageNamed:IMAGE_COMPELTE];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFont:STFont(16) text:@"重置密码操作已完成" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    tipsLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    [self addSubview:tipsLabel];
    
    NSString *deviceSNStr = [NSString stringWithFormat:@"设备 %@",_mViewModel.deviceSNStr];
    UILabel *deviceLabel = [[UILabel alloc]initWithFont:STFont(16) text:deviceSNStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    deviceLabel.frame = CGRectMake(0, STHeight(222), ScreenWidth, STHeight(22));
    [self addSubview:deviceLabel];
    
    
    
    UILabel *contactLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"若设备输入充电密码仍然无法充电，\n请再次尝试设备密码重置操作，或联系平台客服" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:YES];
    [UILabel changeLineSpaceForLabel:contactLabel WithSpace:STHeight(10)];
    contactLabel.frame = CGRectMake(0, STHeight(326), ScreenWidth, STHeight(50));
    contactLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contactLabel];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:contactLabel.text];
    NSRange range = NSMakeRange(32, contactLabel.text.length - 32);
    [noteStr addAttribute:NSForegroundColorAttributeName value:c12 range:range];
    [contactLabel setAttributedText:noteStr];
    
    UIButton *contactBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(268), STHeight(351), STWidth(60), STHeight(25))];
    [contactBtn addTarget:self action:@selector(onContactClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:contactBtn];
}

-(void)updateView{
    
}

-(void)onContactClicked{
    if(_mViewModel){
        [_mViewModel doCall];
    }
}

@end

