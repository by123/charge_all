//
//  WithdrawFailView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawFailView.h"

@interface WithdrawFailView()

@property(strong, nonatomic)WithdrawFailViewModel *mViewModel;
@property(strong, nonatomic)UILabel *failReasonLabel;

@end

@implementation WithdrawFailView

-(instancetype)initWithViewModel:(WithdrawFailViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView *failImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(70), STWidth(100), STWidth(100))];
    failImageView.image = [UIImage imageNamed:IMAGE_WITHDRAW_FAIL];
    failImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:failImageView];
    
    NSString *failStr = MSG_TX_FAIL;
    UILabel *failLabel = [[UILabel alloc]initWithFont:STFont(16) text:failStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    failLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    [self addSubview:failLabel];
    
    _failReasonLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _failReasonLabel.frame = CGRectMake(0, STHeight(207) ,ScreenWidth, STHeight(20));
    [self addSubview:_failReasonLabel];
    
    UIButton *contactBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(134), STHeight(460), STWidth(106), STHeight(37))];
    [contactBtn addTarget:self action:@selector(onContactBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:contactBtn];
    
    NSString *contactStr = @"联系平台客服";
    UILabel *historyLabel = [[UILabel alloc]initWithFont:STFont(15) text:contactStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize historySize = [contactStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    historyLabel.frame = CGRectMake(0, 0, historySize.width, STHeight(37));
    [contactBtn addSubview:historyLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(historySize.width + STWidth(5), (STHeight(37) - STWidth(13))/2, STWidth(13), STWidth(13))];
    arrowImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    [contactBtn addSubview:arrowImageView];
    
}

-(void)updateView{
    _failReasonLabel.text =[NSString stringWithFormat:@"失败原因：%@",_mViewModel.errorMsg];

}

-(void)onContactBtnClick{
    NSString *callPhone = IS_YELLOW_SKIN ? [NSString stringWithFormat:@"telprompt://%@",@"4008818319"] : [NSString stringWithFormat:@"telprompt://%@",@"4008915518"];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}

@end

