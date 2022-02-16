//
//  MerchantUnBindResultView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MerchantUnBindResultView.h"

@interface MerchantUnBindResultView()

@property(strong, nonatomic)MerchantUnBindResultViewModel *mViewModel;

@end

@implementation MerchantUnBindResultView

-(instancetype)initWithViewModel:(MerchantUnBindResultViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2,STHeight(72), STWidth(100), STWidth(100))];
    iconImageView.image = [UIImage imageNamed:_mViewModel.isSuccess ? IMAGE_COMPELTE : IMAGE_UNBIND_FAIL];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:iconImageView];
    
    UILabel *resultLabel = [[UILabel alloc]initWithFont:STFont(16) text:_mViewModel.isSuccess ? MSG_UNBIND_SUCCESS : MSG_UNBIND_FAIL textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    resultLabel.frame = CGRectMake(0, STHeight(72)+STWidth(100)+STHeight(13), ScreenWidth, STHeight(22));
    [self addSubview:resultLabel];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFont:STFont(15) text:[NSString stringWithFormat:_mViewModel.isSuccess ? MSG_UNBIND_SUCCESS_COUNT : MSG_UNBIND_FAIL_COUNT,_mViewModel.count] textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [tipLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    tipLabel.frame = CGRectMake(0, STHeight(72)+STWidth(100)+STHeight(13) + STHeight(32),ScreenWidth, STHeight(21));
    [self addSubview:tipLabel];
    
    UIButton *backBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_UNBIND_BACK_HOME textColor:c_btn_txt_highlight backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    backBtn.frame = CGRectMake(0,ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [backBtn addTarget:self action:@selector(onBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
}

-(void)updateView{
    
}

-(void)onBackBtnClick{
    if(_mViewModel){
        [_mViewModel bankHome];
    }
}
@end

