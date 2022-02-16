////
////  ActiveDeviceView.m
////  manage
////
////  Created by by.huang on 2018/10/27.
////  Copyright © 2018年 by.huang. All rights reserved.
////
//
//#import "ActiveDeviceView.h"
//
//@interface ActiveDeviceView()<UITextFieldDelegate>
//
//@property(strong, nonatomic)ActiveDeviceViewModel *mViewModel;
//
//@property(strong, nonatomic)UIButton *activeBtn;
//@property(strong, nonatomic)UILabel *titleLabel;
//@property(strong, nonatomic)UITextField  *deviceTF;
//@property(strong, nonatomic)UIImageView *searchImageView;
//@property(strong, nonatomic)UIButton *cancelBtn;
//@property(strong, nonatomic)UILabel *selectMerchantLabel;
//@property(strong, nonatomic)UIScrollView *labelView;
//@property(strong, nonatomic)UIView *shadowView;
//
//@property(strong, nonatomic)NSMutableArray *buttons;
//
//
//@end
//
//@implementation ActiveDeviceView{
//    NSUInteger mCurrentSelect;
//}
//
//-(instancetype)initWithViewModel:(ActiveDeviceViewModel *)viewModel{
//    if(self == [super init]){
//        mCurrentSelect = -1;
//        _mViewModel = viewModel;
//        _buttons = [[NSMutableArray alloc]init];
//        [self initView];
//        [_mViewModel searchDevice:MSG_EMPTY];
//    }
//    return self;
//}
//
//-(void)initView{
//    NSString *titleStr = MSG_EMPTY;
//    if(_mViewModel.type == DeviceActiveType_Active){
//        titleStr = MSG_SELECT_ACTIVE_MERCHANT;
//        _titleLabel = [[UILabel alloc]initWithFont:STFont(18) text:titleStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
//        CGSize infoSize = [titleStr sizeWithMaxWidth:ScreenWidth font:STFont(18) fontName:FONT_MIDDLE];
//        [_titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(18)]];
//        _titleLabel.frame = CGRectMake(STWidth(15), STHeight(12), infoSize.width, STHeight(25));
//    }else{
//        titleStr = MSG_UNBIND_MERCHANT_TIPS;
//        _titleLabel = [[UILabel alloc]initWithFont:STFont(12) text:titleStr textAlignment:NSTextAlignmentLeft textColor:c13 backgroundColor:nil multiLine:YES];
//        CGSize infoSize = [titleStr sizeWithMaxWidth:STWidth(345) font:STFont(12)];
//        _titleLabel.frame = CGRectMake(STWidth(15), STHeight(10), STWidth(345), infoSize.height);
//    }
//    [self addSubview:_titleLabel];
//
//
//    
//    
//    _shadowView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(57), ScreenWidth - STWidth(30),  STHeight(50))];
//    _shadowView.backgroundColor = cwhite;
//    _shadowView.layer.shadowOffset = CGSizeMake(1, 1);
//    _shadowView.layer.shadowOpacity = 0.8;
//    _shadowView.layer.shadowColor = c03.CGColor;
//    _shadowView.layer.cornerRadius = 2;
//    [self addSubview:_shadowView];
//    
//    
//    _deviceTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:cwhite corner:0 borderWidth:0 borderColor:nil padding:STWidth(15)];
//    _deviceTF.frame = CGRectMake(0, 0, ScreenWidth - STWidth(30),  STHeight(50));
//    [_deviceTF setPlaceholder:@"输入商户信息搜索或筛选"];
//    [_deviceTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    _deviceTF.delegate = self;
//    [_shadowView addSubview:_deviceTF];
//    
//    _searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(310), (STHeight(50) - STWidth(20))/2, STWidth(20), STWidth(20))];
//    _searchImageView.image = [UIImage imageNamed:IMAGE_SELECT];
//    _searchImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [_deviceTF addSubview:_searchImageView];
//    
//    
//    _activeBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"开始激活" textColor:c_btn_txt_normal backgroundColor:c05 corner:0 borderWidth:0 borderColor:nil];
//    _activeBtn.frame = CGRectMake(0, ContentHeight - STHeight(50), ScreenWidth , STHeight(50));
//    _activeBtn.enabled = NO;
//    [_activeBtn addTarget:self action:@selector(onActiveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_activeBtn];
//    if(_mViewModel.type == DeviceActiveType_UnBind){
//        _activeBtn.hidden = YES;
//    }
//    
//    _cancelBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"取消" textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
//    _cancelBtn.frame = CGRectMake(STWidth(310), STHeight(10),STWidth(65) ,  STHeight(50));
//    _cancelBtn.hidden = YES;
//    [_cancelBtn addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_cancelBtn];
//    
//    NSString *merchatStr = (_mViewModel.type == DeviceActiveType_Active) ? @"选择商户" : MSG_MERCHANT_BIND_SELECT;
//    _selectMerchantLabel = [[UILabel alloc]initWithFont:STFont(20) text:merchatStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
//    CGSize merchatSize = [merchatStr sizeWithMaxWidth:ScreenWidth font:STFont(20) fontName:FONT_MIDDLE];
//    [_selectMerchantLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
//    _selectMerchantLabel.frame = CGRectMake(STWidth(15), STHeight(80), merchatSize.width, STHeight(28));
//    _selectMerchantLabel.hidden = YES;
//    [self addSubview:_selectMerchantLabel];
//    
//    
//    _labelView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, STHeight(126), ScreenWidth,ContentHeight - STHeight(176))];
//    _labelView.showsVerticalScrollIndicator = NO;
//    _labelView.showsHorizontalScrollIndicator = NO;
//    [self addSubview:_labelView];
//    
//    [self createLabelUI];
//    
//    
//}
//
//
//-(void)onActiveBtnClicked{
//    if(mCurrentSelect != -1){
//        MerchantModel *model =  [_mViewModel.merchantDatas objectAtIndex:mCurrentSelect];
//        [_mViewModel goStartActiveDevice:model.mchId mchName:model.mchName];
//    }
//}
//
//-(void)onCancelClicked{
//    [self narrowUI];
//}
//
//- (void)textFieldDidChange:(UITextField *)textField{
//    if(_mViewModel){
//        [_mViewModel searchDevice:textField.text];
//    }
//}
//
//
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [self expandUI];
//    return YES;
//}
//
//
//
//-(void)expandUI{
//    WS(weakSelf)
//    [UIView animateWithDuration:0.3f animations:^{
//        weakSelf.titleLabel.hidden = YES;
//        weakSelf.shadowView.frame = CGRectMake(STWidth(15), STHeight(10), STWidth(295),  STHeight(50));
//        weakSelf.deviceTF.frame = CGRectMake(0, 0, STWidth(295),  STHeight(50));
//        weakSelf.searchImageView.frame =  CGRectMake(STWidth(260), (STHeight(50) - STWidth(20))/2, STWidth(20), STWidth(20));
//        
//    } completion:^(BOOL finished) {
//        weakSelf.cancelBtn.hidden = NO;
//        weakSelf.selectMerchantLabel.hidden = NO;
//    }];
//}
//
//-(void)narrowUI{
//    [_deviceTF resignFirstResponder];
//    WS(weakSelf)
//    [UIView animateWithDuration:0.3f animations:^{
//        weakSelf.cancelBtn.hidden = YES;
//        weakSelf.selectMerchantLabel.hidden = YES;
//        weakSelf.shadowView.frame = CGRectMake(STWidth(15), STHeight(58), ScreenWidth - STWidth(30),  STHeight(50));
//        weakSelf.deviceTF.frame = CGRectMake(0, 0, ScreenWidth - STWidth(30),  STHeight(50));
//        weakSelf.searchImageView.frame =  CGRectMake(STWidth(310), (STHeight(50) - STWidth(20))/2, STWidth(20), STWidth(20));
//        
//    } completion:^(BOOL finished) {
//        weakSelf.titleLabel.hidden = NO;
//    }];
//}
//
//-(void)createLabelUI{
//    CGFloat startX = STWidth(15);
//    CGFloat startY = 0;
//    CGFloat buttonHeight = STHeight(36);
//    
//    if(IS_NS_COLLECTION_EMPTY(_mViewModel.merchantDatas)) return;
//
//    //层级
//    int layer = 1;
//    for(int i = 0; i < _mViewModel.merchantDatas.count; i++)
//    {
//        MerchantModel *model = [_mViewModel.merchantDatas objectAtIndex:i];
//        UIButton *btn = [[UIButton alloc]init];
//        [btn setTitle:model.mchName forState:UIControlStateNormal];
//        [btn setTitleColor:c11 forState:UIControlStateNormal];
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = 2;
//        btn.layer.borderColor = c11.CGColor;
//        btn.layer.borderWidth = LineHeight;
//        btn.titleLabel.font = [UIFont systemFontOfSize:STFont(15)];
//        btn.tag = i;
//        [btn addTarget:self action:@selector(onLabelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [_buttons addObject:btn];
//        [_labelView addSubview:btn];
//        
//        CGSize titleSize = [model.mchName sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
//        
//        titleSize.height = 20;
//        titleSize.width += 20;
//        
//        if(startX + titleSize.width > [UIScreen mainScreen].bounds.size.width - STWidth(15)){
//            startX = STWidth(15);
//            startY = startY + buttonHeight + 10;
//            layer ++;
//        }
//        btn.frame = CGRectMake(startX, startY, titleSize.width, buttonHeight);
//        startX = CGRectGetMaxX(btn.frame) + 10;
//    }
//    
//    _labelView.contentSize = CGSizeMake(ScreenWidth,(buttonHeight+10)*layer);
//
//
//}
//
//
//
//-(void)onLabelBtnClicked:(id)sender{
//    UIButton *btn = sender;
//    if(IS_YELLOW_SKIN){
//        [btn setTitleColor:c21 forState:UIControlStateNormal];
//        [btn setBackgroundColor:c01 forState:UIControlStateNormal];
//        btn.layer.borderColor = c01.CGColor;
//    }else{
//        [btn setTitleColor:c01 forState:UIControlStateNormal];
//        [btn setBackgroundColor:cwhite forState:UIControlStateNormal];
//        btn.layer.borderColor = c01.CGColor;
//    }
//
//
//    
//    if(mCurrentSelect == btn.tag){
//        [self setNormalStatu:mCurrentSelect];
//
//        mCurrentSelect = -1;
//        _activeBtn.enabled = NO;
//        _activeBtn.backgroundColor = c05;
//        [_activeBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
//        
//        return;
//    }
//    if(mCurrentSelect != -1 && !IS_NS_COLLECTION_EMPTY(_buttons)){
//        [self setNormalStatu:mCurrentSelect];
//    }
//    
//    mCurrentSelect = btn.tag;
//    
//    if(_mViewModel.type == DeviceActiveType_Active){
//        _activeBtn.enabled = YES;
//        _activeBtn.backgroundColor = c01;
//        [_activeBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
//    }else if(_mViewModel.type == DeviceActiveType_UnBind){
//        MerchantModel *model =  [_mViewModel.merchantDatas objectAtIndex:mCurrentSelect];
//        [_mViewModel goMerchantBindPage:model];
//    }
//    
//    [_deviceTF resignFirstResponder];
//
//}
//
//
//-(void)setNormalStatu:(NSInteger)select{
//    UIButton *selectBtn = [_buttons objectAtIndex:select];
//    [selectBtn setTitleColor:c11 forState:UIControlStateNormal];
//    [selectBtn setBackgroundColor:cwhite forState:UIControlStateNormal];
//    selectBtn.layer.borderColor = c11.CGColor;
//}
//
//
//-(void)updateDatas:(NSMutableArray *)datas{
//    mCurrentSelect = -1;
//    _activeBtn.enabled = NO;
//    _activeBtn.backgroundColor = c05;
//    [_activeBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
//    
//    [_labelView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [_buttons removeAllObjects];
//    
//    
//    [self createLabelUI];
//}
//
//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//   [_deviceTF resignFirstResponder];
//}
//@end
