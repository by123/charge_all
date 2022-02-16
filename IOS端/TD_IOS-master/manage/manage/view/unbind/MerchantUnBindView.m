//
//  MerchantUnBindView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MerchantUnBindView.h"

@interface MerchantUnBindView()

@property(strong, nonatomic)MerchantUnBindViewModel *mViewModel;
@property(strong, nonatomic)UILabel *mchNameLabel;
@property(strong, nonatomic)UILabel *mchIdLabel;
@property(strong, nonatomic)UILabel *contactLabel;
@property(strong, nonatomic)UILabel *totalLabel;


@end

@implementation MerchantUnBindView

-(instancetype)initWithViewModel:(MerchantUnBindViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    UILabel *tipsLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_UNBIND_MERCHANT_TIPS textAlignment:NSTextAlignmentLeft textColor:c13 backgroundColor:nil multiLine:YES];
    CGSize tipsSize = [tipsLabel.text sizeWithMaxWidth:STWidth(345) font:STFont(12)];
    tipsLabel.frame = CGRectMake(STWidth(15), STHeight(10), STWidth(345), tipsSize.height);
    [self addSubview:tipsLabel];

    UIView *cardView =  [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(60), STWidth(345), STHeight(161))];
    cardView.backgroundColor = cwhite;
    cardView.layer.shadowOffset = CGSizeMake(1, 1);
    cardView.layer.shadowOpacity = 0.8;
    cardView.layer.shadowColor = c03.CGColor;
    cardView.layer.cornerRadius = 2;
    [self addSubview:cardView];
    
    _mchNameLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"" textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    [_mchNameLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    [cardView addSubview:_mchNameLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(50), STWidth(315), LineHeight)];
    lineView.backgroundColor = cline;
    [cardView addSubview:lineView];
    
    NSArray *titleArray = @[MSG_UNBIND_MERCHANTID,MSG_UNBIND_CONTACT,MSG_UNBIND_TOTAL];
    for(int i = 0; i < titleArray.count ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:titleArray[i] textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [tipsLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(63) + STHeight(31)* i, titleSize.width, STHeight(21));
        [cardView addSubview:titleLabel];
    }
    
    _mchIdLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [cardView addSubview:_mchIdLabel];
    
    _contactLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [cardView addSubview:_contactLabel];
    
    _totalLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [cardView addSubview:_totalLabel];
    
    _mchNameLabel.text = _mViewModel.mchModel.mchName;
    CGSize mchNameSize = [_mchNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_MIDDLE];
    _mchNameLabel.frame = CGRectMake(STWidth(15), STHeight(15), mchNameSize.width, STHeight(21));
    
    _mchIdLabel.text = _mViewModel.mchModel.mchId;
    CGSize mchIdSize = [_mchIdLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _mchIdLabel.frame = CGRectMake(STWidth(330) - mchIdSize.width, STHeight(63), mchIdSize.width, STHeight(21));
    
    _contactLabel.text = _mViewModel.mchModel.contactUser;
    CGSize contactSize = [_contactLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _contactLabel.frame = CGRectMake(STWidth(330) -contactSize.width, STHeight(94), contactSize.width, STHeight(21));
    
    
    UIButton *unBindBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_UNBIND_ALL_BTN textColor:c_btn_txt_highlight backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    unBindBtn.frame = CGRectMake(0,ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [unBindBtn addTarget:self action:@selector(onUnBindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:unBindBtn];

}

-(void)updateView{
    _totalLabel.text = IntStr(_mViewModel.model.total);
    CGSize totalSize = [_totalLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _totalLabel.frame = CGRectMake(STWidth(330) - totalSize.width, STHeight(125), totalSize.width, STHeight(21));
}


-(void)onUnBindBtnClick{
    if(_mViewModel.model.total == 0){
        [LCProgressHUD showMessage:MSG_UNBIND_NO_ACTIVE_DEVICE];
        return;
    }
    if(_mViewModel){
        [_mViewModel openDialog];
    }
}


@end

