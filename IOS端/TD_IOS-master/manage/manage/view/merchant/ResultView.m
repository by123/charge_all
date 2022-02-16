//
//  MerchantResultView.m
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ResultView.h"
@interface ResultView()

@property(strong, nonatomic)ResultViewModel *mViewModel;


@end

@implementation ResultView

-(instancetype)initWithViewModel:(ResultViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView *cardView = [[UIView alloc]init];
    cardView.backgroundColor = cwhite;
    cardView.frame = CGRectMake(STWidth(15), STHeight(10), STWidth(345),STHeight(151));
    cardView.layer.shadowOffset = CGSizeMake(1, 1);
    cardView.layer.shadowOpacity = 0.8;
    cardView.layer.shadowColor = c03.CGColor;
    [self addSubview:cardView];
    
    
    NSString *imageSrc = IMAGE_ADD_AGENT_SUCCESS;
    NSString *titleStr = @"代理商登录账号";
    switch (_mViewModel.mType) {
        case 0:
            imageSrc = IMAGE_ADD_MCH_SUCCESS;
            titleStr = @"商户登录账号";
            break;
        case 1:
            imageSrc = IMAGE_ADD_AGENT_SUCCESS;
            titleStr = @"代理商登录账号";
            break;
        case 2:
            imageSrc = IMAGE_ADD_SALEMAN_SUCCESS;
            titleStr = @"业务员登录账号";
            break;
        case 3:
            imageSrc = IMAGE_ADD_AGENT_SUCCESS;
            titleStr = @"连锁门店登录账号";
            break;
            
        default:
            break;
    }
    
    
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [UIImage imageNamed:imageSrc];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.frame = CGRectMake(STWidth(192), STHeight(8),STWidth(153) , STHeight(143));
    [cardView addSubview:bgImageView];
    
    UIView *p1 = [[UIView alloc]init];
    p1.backgroundColor = c22;
    p1.frame = CGRectMake(STWidth(15), STHeight(24), STWidth(6), STWidth(6));
    p1.layer.masksToBounds = YES;
    p1.layer.cornerRadius = STWidth(3);
    [cardView addSubview:p1];
    
    
    UILabel *p1TitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:titleStr textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize p1TitleSize = [titleStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    p1TitleLabel.frame = CGRectMake(STWidth(26), STHeight(18), p1TitleSize.width, STHeight(21));
    [cardView addSubview:p1TitleLabel];
    
    UILabel *p1ContentLabel = [[UILabel alloc]initWithFont:STFont(18) text:_mViewModel.mUserNameStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize p1ContentSize = [_mViewModel.mUserNameStr sizeWithMaxWidth:ScreenWidth font:STFont(18)];
    p1ContentLabel.frame = CGRectMake(STWidth(26), STHeight(44), p1ContentSize.width, STHeight(25));
    [cardView addSubview:p1ContentLabel];
    
    
    UIView *p2 = [[UIView alloc]init];
    p2.backgroundColor = c22;
    p2.frame = CGRectMake(STWidth(15), STHeight(90), STWidth(6), STWidth(6));
    p2.layer.masksToBounds = YES;
    p2.layer.cornerRadius = STWidth(3);
    [cardView addSubview:p2];
    
    UILabel *p2TitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"初始密码" textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize p2TitleSize = [p2TitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    p2TitleLabel.frame = CGRectMake(STWidth(26), STHeight(84), p2TitleSize.width, STHeight(21));
    [cardView addSubview:p2TitleLabel];
    
    
    UILabel *p2ContentLabel = [[UILabel alloc]initWithFont:STFont(18) text:_mViewModel.mPswStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize p2ContentSize = [_mViewModel.mPswStr sizeWithMaxWidth:ScreenWidth font:STFont(18)];
    p2ContentLabel.frame = CGRectMake(STWidth(26), STHeight(110), p2ContentSize.width, STHeight(25));
    [cardView addSubview:p2ContentLabel];
    
    
    UIButton *copyBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"点击复制账号密码" textColor:c11 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    copyBtn.frame = CGRectMake(0, STHeight(200), ScreenWidth, STHeight(43));
    [copyBtn addTarget:self action:@selector(onCopyClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:copyBtn];
    
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"确定" textColor:c_btn_txt_highlight backgroundColor:c01 corner:4 borderWidth:0 borderColor:nil];
    confirmBtn.frame = CGRectMake(STWidth(15), STHeight(439), STWidth(345), STHeight(50));
    [confirmBtn addTarget:self action:@selector(onConfirmClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
}

-(void)onConfirmClicked{
    if(_mViewModel){
        [_mViewModel doConfirm];
    }
}


-(void)onCopyClicked{
    if(_mViewModel){
        [_mViewModel doCopy];
    }
}

@end
