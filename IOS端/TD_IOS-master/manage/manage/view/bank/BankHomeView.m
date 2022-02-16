//
//  BankHomeView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BankHomeView.h"
#import "BankModel.h"
#import "AccountManager.h"

@interface BankHomeView()

@property(strong, nonatomic)BankHomeViewModel *mViewModel;
@property(strong, nonatomic)NSMutableArray *selectImageViews;
@property(strong, nonatomic)NSMutableDictionary *labelDic;
@property(strong, nonatomic)UIButton *wechatBtn;
@property(strong, nonatomic)UIButton *corporateBtn;
@property(strong, nonatomic)UIButton *personalBtn;

@end

@implementation BankHomeView{
    Boolean hasAddWechat;
    Boolean hasAddPersonal;
    Boolean hasAddCorporate;
    NSInteger tag;
    CGFloat height;
    NSInteger current;
}

-(instancetype)initWithViewModel:(BankHomeViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        _selectImageViews = [[NSMutableArray alloc]init];
        _labelDic = [[NSMutableDictionary alloc]init];
        height = STHeight(30);
        if(!IS_NS_COLLECTION_EMPTY(_mViewModel.banks)){
            for(BankModel *model in _mViewModel.banks){
                if(model.isPublic == 2){
                    hasAddWechat = YES;
                }
                if(model.isPublic == 0){
                    hasAddPersonal = YES;
                }
                if(model.isPublic == 1){
                    hasAddCorporate = YES;
                }
    
            }
        }
        if(IS_RED_SKIN){
            hasAddWechat = YES;
        }
        [self initView];
    }
    return self;
}

-(void)initView{
    if(!hasAddWechat){
        current = WeChat;
        [self addWeChatBtn:height select:YES];
        if(!hasAddCorporate){
            [self addTagAndHeight];
            [self addCorporateBtn:height select:NO];
            if(!hasAddPersonal){
                [self addTagAndHeight];
                [self addPersonalBtn:height select:NO];
            }
        }else{
            if(!hasAddPersonal){
                [self addTagAndHeight];
                [self addPersonalBtn:height select:NO];
            }
        }
    }else{
        if(!hasAddCorporate){
            current = Corporate;
            [self addCorporateBtn:height select:YES];
            if(!hasAddPersonal){
                [self addTagAndHeight];
                [self addPersonalBtn:height select:NO];
            }
        }else{
            if(!hasAddPersonal){
                current = Personal;
                [self addPersonalBtn:height select:YES];
            }
        }
    }

    
    UIButton *nextBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"下一步" textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    [nextBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    nextBtn.frame = CGRectMake(STWidth(15), ContentHeight - STHeight(130), STWidth(345), STHeight(50));
    [nextBtn addTarget:self action:@selector(onNextClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
}

-(void)addTagAndHeight{
    tag ++;
    height +=STHeight(97);
}

-(void)addWeChatBtn:(CGFloat)height select:(Boolean)select{
    _wechatBtn = [self buildItemView:IMAGE_WECHAT title:MSG_BK_WECHAT_TYPE tips:MSG_EMPTY select:select top:height];
    _wechatBtn.tag = tag;
    _wechatBtn.tag2 = [NSString stringWithFormat:@"%d",WeChat];
    [self addSubview:_wechatBtn];
}

-(void)addCorporateBtn:(CGFloat)height select:(Boolean)select{
    _corporateBtn = [self buildItemView:IMAGE_DUIGONG title:MSG_BK_DUIGONG_TYPE tips:MSG_EMPTY select:select top:height];
    _corporateBtn.tag = tag;
    _corporateBtn.tag2 = [NSString stringWithFormat:@"%d",Corporate];
    [self addSubview:_corporateBtn];
}

-(void)addPersonalBtn:(CGFloat)height select:(Boolean)select{
    _personalBtn = [self buildItemView:IMAGE_GEREN title:MSG_BK_GEREN_TYPE tips:MSG_EMPTY select:select top:height];
    _personalBtn.tag = tag;
    _personalBtn.tag2 = [NSString stringWithFormat:@"%d",Personal];
    [self addSubview:_personalBtn];
}



-(UIButton *)buildItemView:(NSString *)imgRes title:(NSString *)title tips:(NSString *)tips select:(Boolean)select top:(CGFloat)top{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(15), top, STWidth(345), STHeight(82))];
    button.backgroundColor = cwhite;
    button.layer.shadowOffset = CGSizeMake(1, 1);
    button.layer.shadowOpacity = 0.8;
    button.layer.shadowColor = c03.CGColor;
    button.layer.cornerRadius = 2;
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(17), (STHeight(82) - STWidth(23))/2, STWidth(23), STWidth(23))];
    imageView.image = [UIImage imageNamed:imgRes];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [button addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:title textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_MIDDLE];
    [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    titleLabel.frame = CGRectMake(STWidth(53), STHeight(22), titleSize.width, STHeight(21));
    [button addSubview:titleLabel];
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFont:STFont(12) text:tips textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize tipsSize = [tipsLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    tipsLabel.frame = CGRectMake(STWidth(53), STHeight(43), tipsSize.width, STHeight(17));
    _labelDic[title]= tipsLabel;
    [button addSubview:tipsLabel];
    
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(310), (STHeight(82) - STWidth(16))/2, STWidth(16), STWidth(16))];
    [self setImageSelect:selectImageView select:select];
    selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    [button addSubview:selectImageView];
    
    [_selectImageViews addObject:selectImageView];
    
    return button;
}

-(void)updateView{
    
    int start = [[STUserDefaults getKeyValue:CONFIG_WITHDRAW_START] intValue]/100;
    int wxMax =  [[STUserDefaults getKeyValue:CONFIG_WITHDRAW_MAX_WX] intValue]/100;
//    NSMutableArray *datas = _mViewModel.withdrawRules;
//    UserModel *userModel = [[AccountManager sharedAccountManager]getUserModel];
//    for(WithdrawModel *model in datas){
//        if(userModel.mchType == model.mchType){
//            if(model.channel == 0){
                UILabel *duigongLabel  = [_labelDic objectForKey:MSG_BK_DUIGONG_TYPE];
                duigongLabel.text = [NSString stringWithFormat:MSG_BANK_WITHDRAW_RULE,start,3];
                [self resizeLabel:duigongLabel];
                
                UILabel *gerenLabel  = [_labelDic objectForKey:MSG_BK_GEREN_TYPE];
                gerenLabel.text = [NSString stringWithFormat:MSG_BANK_WITHDRAW_RULE,start,3];
                [self resizeLabel:gerenLabel];
//            }else{
                UILabel *wechatLabel  = [_labelDic objectForKey:MSG_BK_WECHAT_TYPE];
                wechatLabel.text = [NSString stringWithFormat:MSG_WECHAT_WITHDRAW_RULE,start];
                [self resizeLabel:wechatLabel];
//            }
//        }
//    }
}

-(void)resizeLabel:(UILabel *)label{
    CGSize labelSize = [label.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    label.frame = CGRectMake(STWidth(53), STHeight(43), labelSize.width, STHeight(17));
}

-(void)setImageSelect:(UIImageView *)imageView select:(Boolean)select{
    if(select){
        imageView.image = [UIImage imageNamed:IMAGE_SELECT_ALL];
    }else{
        imageView.image = [UIImage imageNamed:IMAGE_SELECT_NOAMAL];
    }
}

-(void)onButtonClick:(id)sender{
    if(IS_NS_COLLECTION_EMPTY(_selectImageViews)) return;
    
    for(UIImageView *imageView in _selectImageViews){
        [self setImageSelect:imageView select:NO];
    }
    
    NSInteger tag = ((UIButton *)sender).tag;
    NSInteger tag2 = [((UIButton *)sender).tag2 intValue];
    [self setImageSelect:[_selectImageViews objectAtIndex:tag] select:YES];
    current = tag2;
}

-(void)onNextClick{
    if(_mViewModel){
        [_mViewModel goAddBankPage:current];
    }
}

@end

