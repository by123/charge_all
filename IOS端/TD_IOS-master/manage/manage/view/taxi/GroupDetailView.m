//
//  GroupDetailView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "GroupDetailView.h"
#import "STSelectLayerButton.h"
#import "TouchScrollView.h"
#import "AccountManager.h"
#import "STAddressPickerLayerView.h"
#import "STSelectInView.h"
#import "STSinglePickerLayerView.h"

@interface GroupDetailView()<UITextFieldDelegate>

@property(strong, nonatomic)GroupDetailViewModel *mViewModel;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)UIButton *editBtn;


@property(strong, nonatomic)UILabel *groupNameLabel;
@property(strong, nonatomic)UILabel *saleLabel;

@property(strong, nonatomic)UILabel *priceLabel;
@property(strong, nonatomic)UILabel *profitLabel;
@property(strong, nonatomic)UILabel *freezeLabel;

@property(strong, nonatomic)UILabel *preSaleNameLabel;
@property(strong, nonatomic)UILabel *preSaleNumberLabel;
@property(strong, nonatomic)UILabel *preAddressLabel;
@property(strong, nonatomic)UILabel *preSaleAddressDetailLabel;

@property(strong, nonatomic)UILabel *afterSaleNameLabel;
@property(strong, nonatomic)UILabel *afterSaleNumberLabel;
@property(strong, nonatomic)UILabel *afterAddressLabel;
@property(strong, nonatomic)UILabel *afterSaleAddressDetailLabel;

@property(strong, nonatomic)UILabel *profitTipsLabel;


@end

@implementation GroupDetailView

-(instancetype)initWithViewModel:(GroupDetailViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}


-(void)initView{
    
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:nil];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    [self addSubview:_scrollView];
    
    _editBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"编辑" textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    _editBtn.frame = CGRectMake(0, ContentHeight -  STHeight(50), ScreenWidth, STHeight(50));
    [_editBtn addTarget:self action:@selector(onEditBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_editBtn];
    
    [self initPart1];
    [self initPart2];
    [self initPart3];
    [self initPart4];
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(970))];

}

-(void)initPart1{
    NSArray *titles = @[@"分组名称",@"关联业务员"];
    UIView *contentView = [self buildTitleAndLine:titles top:STHeight(15) height:STHeight(100)];
    [_scrollView addSubview:contentView];
    
    _groupNameLabel = [self buildContentLabel:_mViewModel.groupModel.groupName parentView:contentView height:0];
    _saleLabel = [self buildContentLabel:_mViewModel.groupModel.salesName parentView:contentView height:STHeight(50)];

}

-(void)initPart2{
    NSArray *titles = @[@"设备计费规则",@"司机分润比例"];
    NSMutableArray *scales = [STConvertUtil jsonToDic:_mViewModel.groupModel.service];
    if(!IS_NS_COLLECTION_EMPTY(scales)){
        NSDictionary *dic = [scales objectAtIndex:0];
        NSString *price = DoubleStr([[dic objectForKey:@"price"] doubleValue] / 100);
        NSString *time = IntStr([[dic objectForKey:@"time"] intValue] / 60);
        UIView *contentView = [self buildTitleAndLine:titles top:STHeight(130) height:STHeight(247)];
        [_scrollView addSubview:contentView];
        [self buildProfitTips:contentView height:STHeight(100)];
        
        _priceLabel = [self buildContentLabel:[NSString stringWithFormat:@"%@元%@小时",price,time] parentView:contentView height:0];
        _profitLabel = [self buildContentLabel:[NSString stringWithFormat:@"%.f%%",_mViewModel.groupModel.profitPercentTaxi] parentView:contentView height:STHeight(50)];
        
        _freezeLabel = [self buildContentLabel: [NSString stringWithFormat:@"%.f元", [_mViewModel.groupModel.deposit doubleValue] / 100] parentView:contentView height:STHeight(135)];
        
        //
        UILabel *freezeTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"设备冻结款" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize freezeTitleSize = [freezeTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        freezeTitleLabel.frame = CGRectMake(STWidth(15), STHeight(135), freezeTitleSize.width, STHeight(50));
        [contentView addSubview:freezeTitleLabel];
        
//        _freezeTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
//        _freezeTF.frame = CGRectMake(STWidth(90), STHeight(135), STWidth(250),STHeight(50));
//        _freezeTF.textAlignment = NSTextAlignmentRight;
//        _freezeTF.keyboardType = UIKeyboardTypeDecimalPad;
//        _freezeTF.maxLength = @"2";
//        _freezeTF.delegate = self;
//        [_freezeTF setPlaceholder:MSG_INPUT color:c03 fontSize:STFont(15)];
//        [_freezeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//        [contentView addSubview:_freezeTF];
        
        //
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(185) - LineHeight, STWidth(345), LineHeight)];
        lineView.backgroundColor = cline;
        [contentView addSubview:lineView];
        
        [self buildTips:@"设备冻结款是指从司机账户中冻结的设备成本费用，后期将转入代理商账户。如无需冻结，可设为0" parentView:contentView height:STHeight(185)];
    }
    

    
  
}

-(void)initPart3{
    NSArray *titles = @[@"售前联系人姓名",@"售前联系电话",@"售前联系地址",@"详细地址"];
    NSString *address;
    if(IS_NS_STRING_EMPTY(_mViewModel.groupModel.presaleProvince) &&
       IS_NS_STRING_EMPTY(_mViewModel.groupModel.presaleCity) &&
       IS_NS_STRING_EMPTY(_mViewModel.groupModel.presaleArea)){
        address = @"无";
    }else{
        address = [NSString stringWithFormat:@"%@-%@-%@",_mViewModel.groupModel.presaleProvince,_mViewModel.groupModel.presaleCity,_mViewModel.groupModel.presaleArea];
    }

    UIView *contentView = [self buildTitleAndLine:titles top:STHeight(392) height:STHeight(250)];
    [_scrollView addSubview:contentView];
    [self buildTips:@"售前信息⽤于对接司机的售前咨询，例如购买咨询" parentView:contentView height:STHeight(200)];
    
    _preSaleNameLabel = [self buildContentLabel:_mViewModel.groupModel.presaleContactName parentView:contentView height:0];
    _preSaleNumberLabel = [self buildContentLabel:_mViewModel.groupModel.presaleContactTel parentView:contentView height:STHeight(50)];
    _preAddressLabel  = [self buildContentLabel:address parentView:contentView height:STHeight(100)];
    _preSaleAddressDetailLabel = [self buildContentLabel:_mViewModel.groupModel.presaleDetailAddr parentView:contentView height:STHeight(150)];
    
}

-(void)initPart4{
    NSArray *titles = @[@"售后联系人姓名",@"售后联系电话",@"售后联系地址",@"详细地址"];
    NSString *address;
    if(IS_NS_STRING_EMPTY(_mViewModel.groupModel.aftersaleProvince) &&
       IS_NS_STRING_EMPTY(_mViewModel.groupModel.aftersaleCity) &&
       IS_NS_STRING_EMPTY(_mViewModel.groupModel.aftersaleArea)){
        address = @"无";
    }else{
        address = [NSString stringWithFormat:@"%@-%@-%@",_mViewModel.groupModel.aftersaleProvince,_mViewModel.groupModel.aftersaleCity,_mViewModel.groupModel.aftersaleArea];
    }
    
    UIView *contentView = [self buildTitleAndLine:titles top:STHeight(657) height:STHeight(250)];
    [_scrollView addSubview:contentView];
    [self buildTips:@"售后信息用于对接司机的售后问题，例如更换设备" parentView:contentView height:STHeight(200)];
    
    _afterSaleNameLabel = [self buildContentLabel:_mViewModel.groupModel.aftersaleContactName parentView:contentView height:0];
    _afterSaleNumberLabel = [self buildContentLabel:_mViewModel.groupModel.aftersaleContactTel parentView:contentView height:STHeight(50)];
    _afterAddressLabel  = [self buildContentLabel:address parentView:contentView height:STHeight(100)];
    _afterSaleAddressDetailLabel = [self buildContentLabel:_mViewModel.groupModel.aftersaleDetailAddr parentView:contentView height:STHeight(150)];

}



-(UIView *)buildTitleAndLine:(NSArray *)titles top:(CGFloat)top height:(CGFloat)height{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, top, ScreenWidth, height)];
    contentView.backgroundColor = cwhite;
    for(int i = 0 ; i < titles.count ; i ++){
        NSString *labelStr = titles[i];
        UILabel *label = [[UILabel alloc]initWithFont:STFont(15) text:labelStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize labelSize = [labelStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        label.frame = CGRectMake(STWidth(15), i * STHeight(50), labelSize.width, STHeight(50));
        [contentView addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), (i + 1) *  STHeight(50) - LineHeight, STWidth(345), LineHeight)];
        lineView.backgroundColor = cline;
        [contentView addSubview:lineView];
        //隐藏part1的分割线
        if(top == STHeight(15) && i == 1){
            lineView.hidden = YES;
        }
    }
    return contentView;
}


-(UILabel *)buildContentLabel:(NSString *)content parentView:(UIView *)contentView height:(CGFloat)height{
    if(IS_NS_STRING_EMPTY(content)){
        content = @"无";
    }
    UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(15) text:content textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize contentSize = [content sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    contentLabel.frame = CGRectMake(ScreenWidth -  STWidth(15) - contentSize.width, height, contentSize.width, STHeight(50));
    [contentView addSubview:contentLabel];
    return contentLabel;
}



-(void)buildTips:(NSString *)tipsStr parentView:(UIView *)parentView height:(CGFloat)height{
    UIImageView *tipImageView = [[UIImageView alloc]init];
    tipImageView.image = [UIImage imageNamed:IMAGE_TIPS];
    tipImageView.contentMode = UIViewContentModeScaleAspectFill;
    tipImageView.frame = CGRectMake(STWidth(15), height + (STHeight(50) - STWidth(14))/2 ,STWidth(14) , STWidth(14));
    [parentView addSubview:tipImageView];
    
    UILabel *label = [[UILabel alloc]initWithFont:STFont(14) text:tipsStr textAlignment:NSTextAlignmentCenter textColor:c05 backgroundColor:nil multiLine:YES];
    CGSize labelSize = [label.text sizeWithMaxWidth:ScreenWidth - STWidth(49) font:STFont(14)];
    label.frame = CGRectMake(STWidth(34),tipImageView.frame.origin.y-STHeight(3), labelSize.width, labelSize.height);
    [parentView addSubview:label];
}

-(void)buildProfitTips:(UIView *)parentView height:(CGFloat)height{
    
    UIImageView *tipImageView = [[UIImageView alloc]init];
    tipImageView.image = [UIImage imageNamed:IMAGE_TIPS];
    tipImageView.contentMode = UIViewContentModeScaleAspectFill;
    tipImageView.frame = CGRectMake(STWidth(15), height + (STHeight(35) - STWidth(14))/2 ,STWidth(14) , STWidth(14));
    [parentView addSubview:tipImageView];
    
    
    _profitTipsLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:YES];
    _profitTipsLabel.frame = CGRectMake(STWidth(34), height + (STHeight(32) - STWidth(14))/2, ScreenWidth - STWidth(49), 0);
    [parentView addSubview:_profitTipsLabel];
    
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    [self updateProfit:model.totalPercent leftProfit:model.totalPercent - _mViewModel.groupModel.profitPercentTaxi];

}




-(void)onEditBtnClicked{
    if(_mViewModel){
        [_mViewModel goGroupEditPage];
    }
}

-(void)updateView{
    [self resetUILabel:_groupNameLabel content:_mViewModel.groupModel.groupName];
    [self resetUILabel:_saleLabel content:_mViewModel.groupModel.salesName];

    NSMutableArray *scales = [STConvertUtil jsonToDic:_mViewModel.groupModel.service];
    NSString *price;
    NSString *time;
    if(!IS_NS_COLLECTION_EMPTY(scales)){
        NSDictionary *dic = [scales objectAtIndex:0];
        price = DoubleStr([[dic objectForKey:@"price"] doubleValue] / 100);
        time = IntStr([[dic objectForKey:@"time"] intValue] / 60);
    }
    [self resetUILabel:_priceLabel content:[NSString stringWithFormat:@"%@元%@小时",price,time]];
    [self resetUILabel:_profitLabel content:[NSString stringWithFormat:@"%.f%%",_mViewModel.groupModel.profitPercentTaxi]];
    [self resetUILabel:_freezeLabel content:[NSString stringWithFormat:@"%.f元", [_mViewModel.groupModel.deposit doubleValue] / 100]];


    
    NSString *preAddress;
    if(IS_NS_STRING_EMPTY(_mViewModel.groupModel.presaleProvince) &&
       IS_NS_STRING_EMPTY(_mViewModel.groupModel.presaleCity) &&
       IS_NS_STRING_EMPTY(_mViewModel.groupModel.presaleArea)){
        preAddress = @"无";
    }else{
        preAddress = [NSString stringWithFormat:@"%@-%@-%@",_mViewModel.groupModel.presaleProvince,_mViewModel.groupModel.presaleCity,_mViewModel.groupModel.presaleArea];
    }
    [self resetUILabel:_preSaleNameLabel content:_mViewModel.groupModel.presaleContactName];
    [self resetUILabel:_preSaleNumberLabel content:_mViewModel.groupModel.presaleContactTel];
    [self resetUILabel:_preAddressLabel content:preAddress];
    [self resetUILabel:_preSaleAddressDetailLabel content:_mViewModel.groupModel.presaleDetailAddr];

    
    NSString *afterAddress;
    if(IS_NS_STRING_EMPTY(_mViewModel.groupModel.aftersaleProvince) &&
       IS_NS_STRING_EMPTY(_mViewModel.groupModel.aftersaleCity) &&
       IS_NS_STRING_EMPTY(_mViewModel.groupModel.aftersaleArea)){
        afterAddress = @"无";
    }else{
        afterAddress = [NSString stringWithFormat:@"%@-%@-%@",_mViewModel.groupModel.aftersaleProvince,_mViewModel.groupModel.aftersaleCity,_mViewModel.groupModel.aftersaleArea];
    }
    
    [self resetUILabel:_afterSaleNameLabel content:_mViewModel.groupModel.aftersaleContactName];
    [self resetUILabel:_afterSaleNumberLabel content:_mViewModel.groupModel.aftersaleContactTel];
    [self resetUILabel:_afterAddressLabel content:afterAddress];
    [self resetUILabel:_afterSaleAddressDetailLabel content:_mViewModel.groupModel.aftersaleDetailAddr];

    
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    
    [self updateProfit:model.totalPercent leftProfit:model.totalPercent - _mViewModel.groupModel.profitPercentTaxi];
}

    
-(void)updateProfit:(double)totalProfit leftProfit:(double)leftProfit{
    
    NSString *profitStr= [NSString stringWithFormat:MSG_PROFIT_TOTAL,totalProfit,leftProfit];
    CGSize profitSize = [profitStr sizeWithMaxWidth:ScreenWidth - STWidth(49) font:STFont(14)];
    _profitTipsLabel.frame = CGRectMake(STWidth(34), _profitTipsLabel.frame.origin.y , ScreenWidth - STWidth(49), profitSize.height);
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:profitStr];
    NSRange range1=[[hintString string]rangeOfString:MSG_PROFIT_RANGE1];
    [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range1];
    
    NSRange range2=[[hintString string]rangeOfString:MSG_PROFIT_RANGE2];
    [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range2];
    
    _profitTipsLabel.attributedText=hintString;
}


-(void)resetUILabel:(UILabel *)contentLabel content:(NSString *)content{
    if(IS_NS_STRING_EMPTY(content)){
        content = @"无";
    }
    contentLabel.text = content;
    CGSize contentSize = [content sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    contentLabel.frame = CGRectMake(ScreenWidth -  STWidth(15) - contentSize.width, contentLabel.mj_y, contentSize.width, STHeight(50));
}

@end


