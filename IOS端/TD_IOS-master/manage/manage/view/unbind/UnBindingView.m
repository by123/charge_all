//
//  UnBindingView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "UnBindingView.h"

@interface UnBindingView()

@property(strong, nonatomic)UnBindingViewModel *mViewModel;

@end

@implementation UnBindingView

-(instancetype)initWithViewModel:(UnBindingViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{

    UIButton *scanBindBtn = [self buildItemBtn:MSG_SCAN_BIND content:MSG_SCAN_BIND_CONTENT imageRes:IMAGE_SCAN_BIND height:STHeight(30)];
    [scanBindBtn addTarget:self action:@selector(onScanBindClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scanBindBtn];
    
    UIButton *merchantBindBtn = [self buildItemBtn:MSG_MERCHANT_BIND content:MSG_MERCHANT_BIND_CONTENT imageRes:IMAGE_MERCHANT_BIND height:STHeight(127)];
    [merchantBindBtn addTarget:self action:@selector(onMerchantBindClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:merchantBindBtn];
    
}

-(UIButton *)buildItemBtn:(NSString *)title content:(NSString *)content imageRes:(NSString *)imageRes height:(CGFloat)height{
    UIButton *button  = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(15), height, STWidth(345), STHeight(82))];
    button.backgroundColor = cwhite;
    button.layer.shadowOffset = CGSizeMake(1, 1);
    button.layer.shadowOpacity = 0.8;
    button.layer.shadowColor = c03.CGColor;
    button.layer.cornerRadius = 2;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(20), (STHeight(82) - STWidth(20))/2, STWidth(20), STWidth(20))];
    imageView.image = [UIImage imageNamed:imageRes];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [button addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:title textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [title sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:@"PingFangSC-Medium"];
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:STFont(15)]];
    titleLabel.frame = CGRectMake(STWidth(50), STHeight(22), titleSize.width, STHeight(21));
    [button addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(12) text:content textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize contentSize = [content sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    contentLabel.frame = CGRectMake(STWidth(50), STHeight(43), contentSize.width, STHeight(17));
    [button addSubview:contentLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(345 - 14 - 20), (STHeight(82) - STWidth(20))/2, STWidth(14), STWidth(14))];
    arrowImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    [button addSubview:arrowImageView];
    
    return button;
}

-(void)onScanBindClicked{
    if(_mViewModel){
        [_mViewModel goScanBindPage];
    }
}

-(void)onMerchantBindClicked{
    if(_mViewModel){
        [_mViewModel goMerchantBindPage];
    }
}


-(void)updateView{
    
}

@end

