//
//  BindWeChatView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BindWeChatView.h"

@interface BindWeChatView()

@property(strong, nonatomic)BindWeChatViewModel *mViewModel;

@end

@implementation BindWeChatView

-(instancetype)initWithViewModel:(BindWeChatViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(32), STHeight(42), STWidth(311), STHeight(154))];
    bgImageView.image = [UIImage imageNamed:IMAGE_BIND_WECHAT_BG];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:bgImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(17) text:MSG_WITHDRAW_WECHAT textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:YES];
    [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(17)]];
    titleLabel.frame = CGRectMake(STWidth(20), STHeight(44), STWidth(110), STHeight(50));
    [bgImageView addSubview:titleLabel];
    
    int start = [[STUserDefaults getKeyValue:CONFIG_WITHDRAW_START] intValue]/100;
    UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(14) text:[NSString stringWithFormat:@"%d元起提 实时到账",start] textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize contentSize = [contentLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    contentLabel.frame = CGRectMake(STWidth(20), STHeight(114), contentSize.width, STHeight(20));
    [bgImageView addSubview:contentLabel];
    
    
    UIButton *bindBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_BIND_WECHAT_TITLE textColor:c_btn_txt_highlight backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    bindBtn.frame = CGRectMake(STWidth(32),ContentHeight - STHeight(130) , STWidth(311), STHeight(50));
    [bindBtn addTarget:self action:@selector(onBindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bindBtn];
}


-(void)onBindBtnClick{
    if(_mViewModel){
        [_mViewModel doWeChatAuth];
    }
}

-(void)updateView{
    
}

@end

