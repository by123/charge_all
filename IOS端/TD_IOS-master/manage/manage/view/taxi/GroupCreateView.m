//
//  GroupCreateView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "GroupCreateView.h"
#import "STSelectLayerButton.h"
#import "TouchScrollView.h"
#import "AccountManager.h"
#import "STAddressPickerLayerView.h"
#import "STSelectInView.h"
#import "STSinglePickerLayerView.h"
#import "STUserDefaults.h"

@interface GroupCreateView()<UITextFieldDelegate,STAddressPickerLayerViewDelegate,STSelectInViewDelegate,STSinglePickerLayerViewDelegate>

@property(strong, nonatomic)GroupCreateViewModel *mViewModel;
@property(strong, nonatomic)TouchScrollView *scrollView;

@property(strong, nonatomic)UITextField *groupNameTF;
@property(strong, nonatomic)STSelectInView *saleSelectView;

@property(strong, nonatomic)UITextField *priceTF;
@property(strong, nonatomic)UITextField *profitTF;
@property(strong, nonatomic)UILabel *profitTipsLabel;
@property(strong, nonatomic)UITextField *freezeTF;

@property(strong, nonatomic)UITextField *preSaleNameTF;
@property(strong, nonatomic)UITextField *preSaleNumberTF;
@property(strong, nonatomic)STSelectInView *preAddressSelectView;
@property(strong, nonatomic)UITextField *preSaleAddressDetailTF;

@property(strong, nonatomic)UITextField *afterSaleNameTF;
@property(strong, nonatomic)UITextField *afterSaleNumberTF;
@property(strong, nonatomic)STSelectInView *afterAddressSelectView;
@property(strong, nonatomic)UITextField *afterSaleAddressDetailTF;

@property(strong, nonatomic)UITextField *firstResponderTF;

@property(strong, nonatomic)UIButton *saveBtn;


@property(strong, nonatomic)STSinglePickerLayerView *saleLayerView;
@property(strong, nonatomic)STAddressPickerLayerView *preAddressLayerView;
@property(strong, nonatomic)STAddressPickerLayerView *afterAddressLayerView;



@end

@implementation GroupCreateView{
    NSInteger salemanPosition;
    NSString *preProvince;
    NSString *preCity;
    NSString *preArea;
    NSString *afterProvince;
    NSString *afterCity;
    NSString *afterArea;
    CGFloat saleTopHeight;

}


-(instancetype)initWithViewModel:(GroupCreateViewModel *)viewModel{
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
    
    _saveBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_SAVE textColor:c_btn_txt_normal backgroundColor:c05 corner:0 borderWidth:0 borderColor:nil];
    _saveBtn.frame = CGRectMake(0, ContentHeight -  STHeight(50), ScreenWidth, STHeight(50));
    _saveBtn.enabled = NO;
    [_saveBtn addTarget:self action:@selector(onSaveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveBtn];
    
    [self initPart1];
    [self initPart2];
    [self initPart3];
    [self initPart4];
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(970))];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)dealloc{
    //移除键盘通知监听者
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)initPart1{

    saleTopHeight = STHeight(50);
    UserModel *userModel = [[AccountManager sharedAccountManager]getUserModel];
    //如果是业务员
    if(userModel.roleType == 2 || userModel.roleType == 3){
        saleTopHeight = 0;
    }
    
    NSArray *titles = @[MSG_GROUP_NAME];
    UIView *contentView = [self buildTitleAndLine:titles top:STHeight(15) height:STHeight(50)+saleTopHeight];
    [_scrollView addSubview:contentView];
    
    _groupNameTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _groupNameTF.textAlignment = NSTextAlignmentRight;
    _groupNameTF.delegate = self;
    [_groupNameTF setPlaceholder:MSG_GROUP_NAME_PLACEHOLDER color:c03 fontSize:STFont(15)];
    _groupNameTF.frame = CGRectMake(STWidth(110), 0 , STWidth(250),STHeight(50));
    [_groupNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [contentView addSubview:_groupNameTF];
    
    _saleSelectView = [[STSelectInView alloc]initWithTitle:MSG_GROUP_SALENAME placeHolder:MSG_SELECT frame: CGRectMake(0, saleTopHeight, ScreenWidth, STHeight(50))];
    _saleSelectView.delegate = self;
    [contentView addSubview:_saleSelectView];
    if(saleTopHeight == 0){
        _saleSelectView.hidden = YES;
    }
}

-(void)initPart2{
    NSArray *titles = @[MSG_GROUP_RULE,MSG_GROUP_PERCENT];
    UIView *contentView = [self buildTitleAndLine:titles top:STHeight(80)+saleTopHeight height:STHeight(247)];
    [_scrollView addSubview:contentView];
    
    [self buildProfitTips:contentView height:STHeight(100)];
    

    NSString *defaultUnit = MSG_GROUP_DEFAULT_UNIT;
    NSString *time = [STUserDefaults getKeyValue:UD_TAXI_TIME];
    if(!IS_NS_STRING_EMPTY(time)){
        int hour = [time intValue] / 60;
        defaultUnit = [NSString stringWithFormat:MSG_GROUP_UNIT,hour];
    }

    UILabel *priceLabel = [[UILabel alloc]initWithFont:STFont(15) text:defaultUnit textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize priceSize = [priceLabel.text sizeWithMaxWidth:ScreenHeight font:STFont(15)];
    priceLabel.frame = CGRectMake(ScreenWidth -  STWidth(15) - priceSize.width , 0, priceSize.width, STHeight(50));
    [contentView addSubview:priceLabel];
    
    _priceTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
    _priceTF.frame = CGRectMake(STWidth(115), 0, STWidth(240) - priceSize.width,STHeight(50));
    _priceTF.textAlignment = NSTextAlignmentRight;
    _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTF.delegate = self;
    [_priceTF setPlaceholder:MSG_INPUT color:c03 fontSize:STFont(15)];
    [_priceTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:_priceTF];
    
    UILabel *profitLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"%" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    profitLabel.frame = CGRectMake(ScreenWidth -  STWidth(30), STHeight(50), STWidth(15), STHeight(50));
    [contentView addSubview:profitLabel];
    
    _profitTF = [[UITextField alloc]initWithFont:STFont(20) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _profitTF.textAlignment = NSTextAlignmentRight;
    _profitTF.keyboardType = UIKeyboardTypeNumberPad;
    _profitTF.maxLength = @"2";
    _profitTF.delegate = self;
    [_profitTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_profitTF setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    _profitTF.frame = CGRectMake(STWidth(90), STHeight(50), STWidth(250),STHeight(50));
    [_profitTF setPlaceholder:MSG_INPUT color:c03 fontSize:STFont(15)];
    [contentView addSubview:_profitTF];
    
    //
    UILabel *freezeTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_GROUP_FREEZE textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize freezeTitleSize = [freezeTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    freezeTitleLabel.frame = CGRectMake(STWidth(15), STHeight(135), freezeTitleSize.width, STHeight(50));
    [contentView addSubview:freezeTitleLabel];
    
    //
    UILabel *freezeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_YUAN textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    freezeLabel.frame = CGRectMake(ScreenWidth -  STWidth(30), STHeight(135), STWidth(15), STHeight(50));
    [contentView addSubview:freezeLabel];
    
    //
    _freezeTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
    _freezeTF.frame = CGRectMake(STWidth(90), STHeight(135), STWidth(250),STHeight(50));
    _freezeTF.textAlignment = NSTextAlignmentRight;
    _freezeTF.keyboardType = UIKeyboardTypeDecimalPad;
    _freezeTF.maxLength = @"2";
    _freezeTF.delegate = self;
    [_freezeTF setPlaceholder:MSG_INPUT color:c03 fontSize:STFont(15)];
    [_freezeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:_freezeTF];
    
    //
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(185) - LineHeight, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [contentView addSubview:lineView];
    
    [self buildTips:MSG_GROUP_FREEZE_TIPS parentView:contentView height:STHeight(185)];

}

-(void)initPart3{
    NSArray *titles = @[MSG_GROUP_PRE_SALENAME,MSG_GROUP_PRE_PHONE,MSG_BLANK,MSG_GROUP_ADDRESS_DETAIL];
    UIView *contentView = [self buildTitleAndLine:titles top:STHeight(342)+saleTopHeight height:STHeight(250)];
    [_scrollView addSubview:contentView];
    [self buildTips:MSG_GROUP_PRE_TIPS parentView:contentView height:STHeight(200)];

    _preSaleNameTF = [self buildNormalTextField:_preSaleNameTF height:0 hold:MSG_INPUT];
    [contentView addSubview:_preSaleNameTF];
    
    _preSaleNumberTF = [self buildNormalTextField:_preSaleNumberTF height:STHeight(50) hold:MSG_INPUT];
    _preSaleNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    _preSaleNumberTF.maxLength = @"11";
    [contentView addSubview:_preSaleNumberTF];
    
    _preAddressSelectView = [[STSelectInView alloc]initWithTitle:MSG_GROUP_PRE_ADDRESS placeHolder:MSG_GROUP_SELECT_CITY frame:CGRectMake(0, STHeight(100), ScreenWidth, STHeight(50)-LineHeight)];
    _preAddressSelectView.delegate = self;
    [contentView addSubview:_preAddressSelectView];
    
    _preSaleAddressDetailTF = [self buildNormalTextField:_preSaleAddressDetailTF height:STHeight(150) hold:MSG_GROUP_ADDRESS_DETAIL_PLACEHOLDER];
    [contentView addSubview:_preSaleAddressDetailTF];
    
    _preAddressLayerView = [[STAddressPickerLayerView alloc]init];
    _preAddressLayerView.hidden = YES;
    _preAddressLayerView.delegate = self;
    [self addSubview:_preAddressLayerView];
}

-(void)initPart4{
    NSArray *titles = @[MSG_GROUP_AFTER_SALENAME,MSG_GROUP_AFTER_PHONE,MSG_BLANK,MSG_GROUP_ADDRESS_DETAIL];
    UIView *contentView = [self buildTitleAndLine:titles top:STHeight(607)+saleTopHeight height:STHeight(250)];
    [_scrollView addSubview:contentView];
    [self buildTips:MSG_GROUP_AFTER_TIPS parentView:contentView height:STHeight(200)];
    
    _afterSaleNameTF = [self buildNormalTextField:_afterSaleNameTF height:0 hold:MSG_INPUT];
    [contentView addSubview:_afterSaleNameTF];
    
    _afterSaleNumberTF = [self buildNormalTextField:_afterSaleNumberTF height:STHeight(50) hold:MSG_INPUT];
    _afterSaleNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    _afterSaleNumberTF.maxLength = @"11";
    [contentView addSubview:_afterSaleNumberTF];
    
    _afterAddressSelectView = [[STSelectInView alloc]initWithTitle:MSG_GROUP_AFTER_ADDRESS placeHolder:MSG_GROUP_SELECT_CITY frame : CGRectMake(0, STHeight(100), ScreenWidth, STHeight(50)-LineHeight)];
    _afterAddressSelectView.delegate = self;
    [contentView addSubview:_afterAddressSelectView];
    
    _afterSaleAddressDetailTF = [self buildNormalTextField:_afterSaleAddressDetailTF height:STHeight(150) hold:MSG_GROUP_ADDRESS_DETAIL_PLACEHOLDER];
    [contentView addSubview:_afterSaleAddressDetailTF];
    
    _afterAddressLayerView = [[STAddressPickerLayerView alloc]init];
    _afterAddressLayerView.hidden = YES;
    _afterAddressLayerView.delegate = self;
    [self addSubview:_afterAddressLayerView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == _preSaleNumberTF || textField == _afterSaleNumberTF || textField == _profitTF){
        return [self validateNumber:string];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
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
        
        if(top == STHeight(15) && saleTopHeight == 0){
            lineView.hidden = YES;
        }
    }
    return contentView;
    
    
    
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
    [self updateProfit:model.totalPercent leftProfit:model.totalPercent];
    
 
}

-(UITextField *)buildNormalTextField:(UITextField *)textFiled height:(CGFloat)height hold:(NSString *)holdStr{
    textFiled = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    textFiled.textAlignment = NSTextAlignmentRight;
    textFiled.frame = CGRectMake(STWidth(110), height , STWidth(250),STHeight(50));
    textFiled.delegate = self;
    [textFiled setPlaceholder:holdStr color:c03 fontSize:STFont(15)];
    [textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return textFiled;
}


    
-(void)updateProfit:(double)totalProfit leftProfit:(double)leftProfit{
    
    NSString *profitStr= [NSString stringWithFormat:MSG_PROFIT_TOTAL,totalProfit,leftProfit];
    CGSize profitSize = [profitStr sizeWithMaxWidth:ScreenWidth - STWidth(49) font:STFont(14)];
    _profitTipsLabel.frame = CGRectMake(STWidth(34), _profitTipsLabel.frame.origin.y, ScreenWidth - STWidth(49), profitSize.height);

    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:profitStr];
    NSRange range1=[[hintString string]rangeOfString:MSG_PROFIT_RANGE1];
    [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range1];
    
    NSRange range2=[[hintString string]rangeOfString:MSG_PROFIT_RANGE2];
    [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range2];
    
    _profitTipsLabel.attributedText=hintString;
}

- (void)textFieldDidChange:(UITextField *)textField{
    [self changeAddBtnStatu];
    if(textField == _profitTF){
        UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
        [self updateProfit:model.totalPercent leftProfit:model.totalPercent - [_profitTF.text doubleValue]];
    }
}

-(void)changeAddBtnStatu{
    if(!IS_NS_STRING_EMPTY(_groupNameTF.text) &&
       !IS_NS_STRING_EMPTY(_profitTF.text) &&
       !IS_NS_STRING_EMPTY(_priceTF.text) &&
       !IS_NS_STRING_EMPTY(_preSaleNumberTF.text) &&
       !IS_NS_STRING_EMPTY(_afterSaleNumberTF.text) &&
       !IS_NS_STRING_EMPTY(_freezeTF.text)){
        [_saveBtn setBackgroundColor:c01 forState:UIControlStateNormal];
        _saveBtn.enabled = YES;
        [_saveBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
    }else{
        [_saveBtn setBackgroundColor:c05 forState:UIControlStateNormal];
        _saveBtn.enabled = NO;
        [_saveBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
    }
}


-(void)handleTextFieldResonder{
    if ([_firstResponderTF isFirstResponder])[_firstResponderTF resignFirstResponder];
    _preAddressLayerView.hidden = YES;
    _afterAddressLayerView.hidden = YES;
    _saleLayerView.hidden = YES;

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self handleTextFieldResonder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _preSaleNumberTF || textField == _afterSaleNumberTF){
        if(IS_NS_STRING_EMPTY(_preSaleNumberTF.text)){
            [LCProgressHUD showMessage:@"手机号码不能为空"];
            return;
        }
        if(textField.text.length != 11){
            [LCProgressHUD showMessage:@"手机号码格式不正确"];
            return;
        }
    }else if(textField == _profitTF){
        UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
        if(model.totalPercent < [_profitTF.text doubleValue]){
            [LCProgressHUD showMessage:@"不能超过您可分配的分润比例"];
        }
    }
}


-(void)onSelectClicked:(id)selectInView{
    [self handleTextFieldResonder];
    if(selectInView == _preAddressSelectView){
        _preAddressLayerView.hidden = NO;
    }else if(selectInView == _afterAddressSelectView){
        _afterAddressLayerView.hidden = NO;
    }else if(_saleSelectView){
        _saleLayerView.hidden = NO;
    }
}

-(void)onSelectResult:(UIView *)layerView province:(NSString *)provinceStr city:(NSString *)cityStr area:(NSString *)area{
    if(layerView == _preAddressLayerView){
        preProvince = provinceStr;
        preCity = cityStr;
        preArea = area;
        [_preAddressSelectView setContent:[NSString stringWithFormat:@"%@-%@-%@",provinceStr,cityStr,area]];
    }else if(layerView == _afterAddressLayerView){
        afterProvince = provinceStr;
        afterCity = cityStr;
        afterArea = area;
        [_afterAddressSelectView setContent:[NSString stringWithFormat:@"%@-%@-%@",provinceStr,cityStr,area]];
    }
}

-(void)updateSaleSelectView{
    if(_saleLayerView == nil){
        NSMutableArray *datas = [[NSMutableArray alloc]init];
        if(!IS_NS_COLLECTION_EMPTY(_mViewModel.salemanDatas)){
            //选中第一个业务员
            salemanPosition = 0;
            SalemanModel *model = [_mViewModel.salemanDatas objectAtIndex:salemanPosition];
            [_saleSelectView setContent:model.name];
            //
            for(SalemanModel *model in _mViewModel.salemanDatas){
                [datas addObject:model.name];
            }
        }
        _saleLayerView = [[STSinglePickerLayerView alloc]initWithDatas:datas];
        _saleLayerView.delegate = self;
        _saleLayerView.hidden = YES;
        [self addSubview:_saleLayerView];
    }
}

-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView position:(NSInteger)position{
    salemanPosition = position;
    [_saleSelectView setContent:result];
}


-(void)onSaveBtnClicked{
    _mViewModel.model.groupName = _groupNameTF.text;
    if(saleTopHeight == 0){
        UserModel *model = [[AccountManager sharedAccountManager]getUserModel];
        _mViewModel.model.salesId = model.userId;
    }else{
        SalemanModel *saleModel = [_mViewModel.salemanDatas objectAtIndex:salemanPosition];
        _mViewModel.model.salesId = saleModel.userId;
    }
    double price= [_priceTF.text doubleValue];
    NSString *timeStr = [STUserDefaults getKeyValue:UD_TAXI_TIME];
    NSString *scaleStr = [STUserDefaults getKeyValue:UD_TAXI_SCALE];
    if(IS_NS_STRING_EMPTY(timeStr) || IS_NS_STRING_EMPTY(scaleStr)){
        _mViewModel.model.service = [NSString stringWithFormat:@"[{\"scale\":3,\"time\":\"120\",\"price\":%d}]",(int)(price * 100)];
    }else{
         _mViewModel.model.service = [NSString stringWithFormat:@"[{\"scale\":%@,\"time\":%@,\"price\":%d}]",scaleStr,timeStr,(int)(price * 100)];
    }
    _mViewModel.model.profitPercentTaxi = [_profitTF.text doubleValue];
    _mViewModel.model.deposit= [NSString stringWithFormat:@"%.f",[_freezeTF.text doubleValue] * 100];
    
    _mViewModel.model.presaleContactName = _preSaleNameTF.text;
    _mViewModel.model.presaleContactTel = _preSaleNumberTF.text;
    _mViewModel.model.presaleDetailAddr = _preSaleAddressDetailTF.text;
    
    _mViewModel.model.presaleProvince = preProvince;
    _mViewModel.model.presaleCity= preCity;
    _mViewModel.model.presaleArea = preArea;
    
    _mViewModel.model.aftersaleContactName = _afterSaleNameTF.text;
    _mViewModel.model.aftersaleContactTel = _afterSaleNumberTF.text;
    _mViewModel.model.aftersaleDetailAddr = _afterSaleAddressDetailTF.text;
    
    _mViewModel.model.aftersaleProvince = afterProvince;
    _mViewModel.model.aftersaleCity= afterCity;
    _mViewModel.model.aftersaleArea = afterArea;
    
    if(_mViewModel){
        [_mViewModel createGroup];
    }

}



#pragma maek UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _firstResponderTF = textField;//当将要开始编辑的时候，获取当前的textField
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect rect = [weakSelf.firstResponderTF.superview convertRect:weakSelf.firstResponderTF.frame toView:weakSelf.scrollView];//获取相对于self的位置
        NSDictionary *userInfo = [notification userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];//获取弹出键盘的fame的value值
        CGRect keyboardRect = [aValue CGRectValue];
        keyboardRect = [weakSelf.scrollView convertRect:keyboardRect fromView:weakSelf.scrollView.window];//获取键盘相对于self的frame ，传window和传nil是一样的
        CGFloat keyboardTop = keyboardRect.origin.y;
        NSNumber * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//获取键盘弹出动画时间值
        NSTimeInterval animationDuration = [animationDurationValue doubleValue];
        if (keyboardTop < CGRectGetMaxY(rect)) {//如果键盘盖住了输入框
            CGFloat gap = keyboardTop - CGRectGetMaxY(rect) - 10;//计算需要网上移动的偏移量（输入框底部离键盘顶部为10的间距）
            [UIView animateWithDuration:animationDuration animations:^{
                weakSelf.scrollView.frame = CGRectMake(weakSelf.scrollView.frame.origin.x, gap, weakSelf.scrollView.frame.size.width, weakSelf.scrollView.frame.size.height);
            }];
        }
    });
    
}
- (void)keyboardWillHide:(NSNotification *)notification{
    
    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [notification userInfo];
        NSNumber * animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//获取键盘隐藏动画时间值
        NSTimeInterval animationDuration = [animationDurationValue doubleValue];
        [UIView animateWithDuration:animationDuration animations:^{
            weakSelf.scrollView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
            
        }];
    });

}
@end


