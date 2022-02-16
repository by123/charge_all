//
//  AgentView.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AgentView.h"
#import "STSelectLayerButton.h"
#import "TouchScrollView.h"
#import "STSinglePickerLayerView.h"
#import "AccountManager.h"
#import "STAddressPickerLayerView.h"
#import "STSelectInView.h"
#import "MapManage.h"

@interface AgentView()<STSinglePickerLayerViewDelegate,UITextFieldDelegate,STSelectInViewDelegate,STAddressPickerLayerViewDelegate>

@property(strong, nonatomic)AgentViewModel *mViewModel;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)UITextField *nameTF;
@property(strong, nonatomic)STSelectLayerButton *industryBtn;
@property(strong, nonatomic)UITextField *contactNameTF;
@property(strong, nonatomic)UITextField *contactPhoneTF;
@property(strong, nonatomic)UITextField *profitTF;
@property(strong, nonatomic)UITextField *freezeTF;
@property(strong, nonatomic)UIButton *addBtn;

@property(strong, nonatomic)UILabel *profitLabel;

@property(strong, nonatomic)STSinglePickerLayerView *layerView;

@property(strong, nonatomic)STSelectInView *addressBtn;
@property(strong, nonatomic)STAddressPickerLayerView *addressLayerView;
@property(strong, nonatomic)UITextField *addressDetailTF;


@end


@implementation AgentView{
    int currentSelect;
}


-(instancetype)initWithViewModel:(AgentViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}


-(void)initView{
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:nil];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight-STHeight(50));
    [self addSubview:_scrollView];
    [self initTop];
    [self initFreeze];
    [self initProfit];
    [self initAddress];
    
    _addBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_SAVE textColor:c_btn_txt_normal backgroundColor:c05 corner:0 borderWidth:0 borderColor:nil];
    _addBtn.frame = CGRectMake(0, ContentHeight -  STHeight(50), ScreenWidth, STHeight(50));
    _addBtn.enabled = NO;
    [_addBtn addTarget:self action:@selector(onAddBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    NSArray *tempArray = @[@"省代",@"市代",@"区/县代"];
    currentSelect = model.level + 1;
    NSLog(@"当前代理级别:%d",model.level);
    NSMutableArray *industrys = [[NSMutableArray alloc]init];
    for(int i = model.level ; i<tempArray.count ; i ++ ){
        [industrys addObject:tempArray[i]];
    }
    [_industryBtn setSelectText:industrys[0]];

    
    _layerView = [[STSinglePickerLayerView alloc]initWithDatas:industrys];
    _layerView.hidden = YES;
    _layerView.delegate = self;
    [self addSubview:_layerView];
    
    _addressLayerView = [[STAddressPickerLayerView alloc]init];
    _addressLayerView.hidden = YES;
    _addressLayerView.delegate = self;
    [self addSubview:_addressLayerView];
    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(50) * 16)];
    
//    [MapManage sharedMapManage].delegate = self;
//    [[MapManage sharedMapManage] positionLocation];

}

-(void)initTop{
    
    [self buildTitle:@"代理商信息" height:0];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(50), ScreenWidth, STHeight(250))];
    topView.backgroundColor = cwhite;
    [self buildTitleAndLine:topView];
    
    [_scrollView addSubview:topView];
    
    _nameTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _nameTF.textAlignment = NSTextAlignmentRight;
    _nameTF.placeholder = @"请输入代理商名称";
    _nameTF.frame = CGRectMake(STWidth(110), 0 , STWidth(250),STHeight(50));
    [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [topView addSubview:_nameTF];
    
    _industryBtn = [[STSelectLayerButton alloc]initWithFrame:CGRectMake(STWidth(160), STHeight(50) , STWidth(200),STHeight(50))];
    [_industryBtn addTarget:self action:@selector(onIndustyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_industryBtn];
    
    _contactNameTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _contactNameTF.textAlignment = NSTextAlignmentRight;
    _contactNameTF.placeholder = @"请输入联系人姓名";
    _contactNameTF.frame = CGRectMake(STWidth(110), STHeight(100), STWidth(250),STHeight(50));
    [_contactNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [topView addSubview:_contactNameTF];
    
    _contactPhoneTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _contactPhoneTF.textAlignment = NSTextAlignmentRight;
    _contactPhoneTF.placeholder = @"请输入联系人电话";
    _contactPhoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _contactPhoneTF.maxLength = @"11";
    _contactPhoneTF.delegate = self;
    _contactPhoneTF.frame = CGRectMake(STWidth(110), STHeight(150), STWidth(250),STHeight(50));
    [_contactPhoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [topView addSubview:_contactPhoneTF];
    
    
}


-(void)initFreeze{
    [self buildTitle:@"冻结金额（非必填）" height:STHeight(300)];
    UIView *freezeView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(350), ScreenWidth, STHeight(100))];
    freezeView.backgroundColor = cwhite;
    [_scrollView addSubview:freezeView];
    
    UILabel *freezeLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"设置冻结金额" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [freezeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    freezeLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(50));
    [freezeView addSubview:freezeLabel];
    
    _freezeTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _freezeTF.textAlignment = NSTextAlignmentRight;
    _freezeTF.keyboardType = UIKeyboardTypeDecimalPad;
    _freezeTF.text = MSG_ZERO;
    _freezeTF.delegate = self;
    [_freezeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _freezeTF.frame = CGRectMake(STWidth(90), 0, STWidth(250),STHeight(50));
    [freezeView addSubview:_freezeTF];
    
    UILabel *unitLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_YUAN textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    unitLabel.frame = CGRectMake(ScreenWidth -  STWidth(30), 0, STWidth(15), STHeight(50));
    [freezeView addSubview:unitLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15),  STHeight(50) - LineHeight, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [freezeView addSubview:lineView];
    
    [self buildTipsView:freezeView height:STHeight(50) tipsStr:@"设置后，账户金额超过此金额才能提现"];
}

-(void)initProfit{
    
    [self buildTitle:@"代理商分润" height:STHeight(450)];
    UIView *profitView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(500), ScreenWidth, STHeight(100))];
    profitView.backgroundColor = cwhite;
    [_scrollView addSubview:profitView];
    
    
    NSString *labelStr = @"设置子代理商分润比例";
    UILabel *label = [[UILabel alloc]initWithFont:STFont(15) text:labelStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize labelSize = [labelStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    label.frame = CGRectMake(STWidth(15), 0, labelSize.width, STHeight(50));
    [profitView addSubview:label];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15),  STHeight(50)-LineHeight, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [profitView addSubview:lineView];
    
    UILabel *profitLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"%" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    profitLabel.frame = CGRectMake(ScreenWidth -  STWidth(30), 0, STWidth(15), STHeight(50));
    [profitView addSubview:profitLabel];
    
    
    _profitTF = [[UITextField alloc]initWithFont:STFont(20) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _profitTF.textAlignment = NSTextAlignmentRight;
    _profitTF.keyboardType = UIKeyboardTypeNumberPad;
    _profitTF.maxLength = @"2";
    _profitTF.delegate = self;
    [_profitTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_profitTF setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    _profitTF.frame = CGRectMake(STWidth(90), 0, STWidth(250),STHeight(50));
    [profitView addSubview:_profitTF];
    
    
    UIImageView *tipImageView = [[UIImageView alloc]init];
    tipImageView.image = [UIImage imageNamed:IMAGE_TIPS];
    tipImageView.contentMode = UIViewContentModeScaleAspectFill;
    tipImageView.frame = CGRectMake(STWidth(15), STHeight(50) + (STHeight(50) - STWidth(14))/2 ,STWidth(14) , STWidth(14));
    [profitView addSubview:tipImageView];
    
    
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    NSString *profitStr= [NSString stringWithFormat:MSG_PROFIT_TOTAL,model.totalPercent,model.totalPercent];
    _profitLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize profitSize = [profitStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    if(profitSize.width  + STWidth(34-15)> STWidth(345)){
        [_profitLabel setFont:[UIFont systemFontOfSize:STFont(13)]];
        profitSize = [profitStr sizeWithMaxWidth:ScreenWidth font:STFont(13)];
    }
    _profitLabel.frame = CGRectMake(STWidth(34), STHeight(50), profitSize.width, STHeight(50));
    [profitView addSubview:_profitLabel];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:profitStr];
    NSRange range1=[[hintString string]rangeOfString:MSG_PROFIT_RANGE1];
    [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range1];
    
    NSRange range2=[[hintString string]rangeOfString:MSG_PROFIT_RANGE2];
    [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range2];
    
    _profitLabel.attributedText=hintString;
}


-(void)initAddress{
    [self buildTitle:@"区域位置（非必填）" height:STHeight(600)];
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(650), ScreenWidth, STHeight(100))];
    addressView.backgroundColor = cwhite;
    [_scrollView addSubview:addressView];
    
    _addressBtn = [[STSelectInView alloc]initWithTitle:MSG_PROVINCE_CITY_DISTRICT placeHolder:MSG_GROUP_SELECT_CITY frame : CGRectMake(0, 0, ScreenWidth - STWidth(31), STHeight(50)-LineHeight)];
    _addressBtn.delegate = self;
    [addressView addSubview:_addressBtn];
    
    UIButton *positionBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-STWidth(31), (STHeight(50)- STWidth(16))/2, STWidth(16), STWidth(16))];
    [positionBtn setImage:[UIImage imageNamed:IMAGE_MCH_POSITION2] forState:UIControlStateNormal];
    [positionBtn addTarget:self action:@selector(onPositionBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:positionBtn];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15),  STHeight(50) - LineHeight, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [addressView addSubview:lineView];
    
    
    UILabel *addressDetailLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_ADDRESS_DETAIL textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize addressDetailSize = [addressDetailLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    addressDetailLabel.frame = CGRectMake(STWidth(15),  STHeight(50), addressDetailSize.width, STHeight(50));
    [addressView addSubview:addressDetailLabel];
    
    _addressDetailTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _addressDetailTF.textAlignment = NSTextAlignmentRight;
    _addressDetailTF.delegate = self;
    _addressDetailTF.placeholder = @"详细地址";
    [_addressDetailTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _addressDetailTF.frame = CGRectMake(STWidth(30) + addressDetailSize.width, STHeight(50), ScreenWidth - STWidth(45) - addressDetailSize.width,STHeight(50));
    [addressView addSubview:_addressDetailTF];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == _contactPhoneTF || textField == _profitTF){
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


-(void)buildTitle:(NSString *)title height:(CGFloat)height{
    UILabel *infoLabel = [[UILabel alloc]initWithFont:STFont(14) text:title textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize infoSize = [infoLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    infoLabel.frame = CGRectMake(STWidth(15), height, infoSize.width, STHeight(50));
    [_scrollView addSubview:infoLabel];
}


-(void)buildTitleAndLine:(UIView *)topView{
    NSArray *titles = @[@"代理商名称",@"代理商级别",@"代理人姓名",@"代理人电话"];
    for(int i = 0 ; i < titles.count ; i ++){
        NSString *labelStr = titles[i];
        UILabel *label = [[UILabel alloc]initWithFont:STFont(15) text:labelStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize labelSize = [labelStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        label.frame = CGRectMake(STWidth(15), i * STHeight(50), labelSize.width, STHeight(50));
        [topView addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), (i + 1) *  STHeight(50) - LineHeight, STWidth(345), LineHeight)];
        lineView.backgroundColor = cline;
        [topView addSubview:lineView];
    }
    [self buildTipsView:topView height:STHeight(200) tipsStr:MSG_CONTACTPHONE_TIPS2];
}


-(void)buildTipsView:(UIView *) parentView height:(CGFloat)height tipsStr:(NSString *)tipsStr{
    UIImageView *tipImageView = [[UIImageView alloc]init];
    tipImageView.image = [UIImage imageNamed:IMAGE_TIPS];
    tipImageView.contentMode = UIViewContentModeScaleAspectFill;
    tipImageView.frame = CGRectMake(STWidth(15), height + (STHeight(50) - STWidth(14))/2 ,STWidth(14) , STWidth(14));
    [parentView addSubview:tipImageView];
    
    
    UILabel *label = [[UILabel alloc]initWithFont:STFont(14) text:tipsStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize labelSize = [label.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    label.frame = CGRectMake(STWidth(34), height, labelSize.width, STHeight(50));
    [parentView addSubview:label];
}


-(void)onAddBtnClicked{
    
    _mViewModel.model.mchName = _nameTF.text;
    _mViewModel.model.level = [NSString stringWithFormat:@"%d",currentSelect];
    _mViewModel.model.contactUser = _contactNameTF.text;
    _mViewModel.model.contactPhone = _contactPhoneTF.text;
    _mViewModel.model.profitSubAgent = _profitTF.text;
    _mViewModel.model.blockedAmount = _freezeTF.text;
    _mViewModel.model.detailAddr = _addressDetailTF.text;
    if(_mViewModel){
        [_mViewModel addAgent];
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
    [self changeAddBtnStatu];
    if(textField == _profitTF){
        UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
        NSString *profitStr= [NSString stringWithFormat:MSG_PROFIT_TOTAL,model.totalPercent,model.totalPercent - [_profitTF.text doubleValue]];
        CGSize profitSize = [profitStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
        if(profitSize.width  + STWidth(34-15)> STWidth(345)){
            [_profitLabel setFont:[UIFont systemFontOfSize:STFont(13)]];
            profitSize = [profitStr sizeWithMaxWidth:ScreenWidth font:STFont(13)];
        }
        _profitLabel.frame = CGRectMake(STWidth(34), STHeight(50), profitSize.width, STHeight(50));
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:profitStr];
        NSRange range1=[[hintString string]rangeOfString:MSG_PROFIT_RANGE1];
        [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range1];
        
        NSRange range2=[[hintString string]rangeOfString:MSG_PROFIT_RANGE2];
        [hintString addAttribute:NSForegroundColorAttributeName value:c05 range:range2];
        
        _profitLabel.attributedText=hintString;
    }
}

-(void)changeAddBtnStatu{
    if(!IS_NS_STRING_EMPTY(_nameTF.text) &&
       !IS_NS_STRING_EMPTY(_profitTF.text) &&
       !IS_NS_STRING_EMPTY(_contactPhoneTF.text) &&
       !IS_NS_STRING_EMPTY(_contactNameTF.text)){
        [_addBtn setBackgroundColor:c01 forState:UIControlStateNormal];
        _addBtn.enabled = YES;
        [_addBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
    }else{
        [_addBtn setBackgroundColor:c05 forState:UIControlStateNormal];
        _addBtn.enabled = NO;
        [_addBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
    }
}

-(void)onIndustyBtnClicked{
    [self resignFirstResponderAll];
    _addressLayerView.hidden = YES;
    _layerView.hidden = NO;
}

-(void)onSelectClicked:(id)selectInView{
    [self resignFirstResponderAll];
    _addressLayerView.hidden = NO;
    _layerView.hidden = YES;
}



-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView position:(NSInteger)position{
    NSArray *tempArray = @[@"省代",@"市代",@"区/县代"];
    for(int i = 0 ; i < tempArray.count ; i ++){
        if([tempArray[i] isEqualToString:result]){
            currentSelect = i + 1;
        }
    }
    [_industryBtn setSelectText:result];
}

-(void)onSelectResult:(UIView *)layerView province:(NSString *)provinceStr city:(NSString *)cityStr area:(NSString *)area{
    if(layerView == _addressLayerView){
        _mViewModel.model.province = provinceStr;
        _mViewModel.model.city = cityStr;
        _mViewModel.model.area = area;
        [_addressBtn setContent:[NSString stringWithFormat:@"%@-%@-%@",provinceStr,cityStr,area]];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignFirstResponderAll];
}

-(void)resignFirstResponderAll{
    [_nameTF resignFirstResponder];
    [_profitTF resignFirstResponder];
    [_contactPhoneTF resignFirstResponder];
    [_contactNameTF resignFirstResponder];
    [_freezeTF resignFirstResponder];
    [_addressDetailTF resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _contactPhoneTF){
        if(IS_NS_STRING_EMPTY(_contactNameTF.text)){
            [LCProgressHUD showMessage:@"手机号码不能为空"];
            return;
        }
        if(_contactPhoneTF.text.length != 11){
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

    
//-(void)onPositionLocation:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode{
//     _mViewModel.model.province = regeocode.province;
//     _mViewModel.model.city = regeocode.city;
//     _mViewModel.model.area = regeocode.district;
//     [_addressBtn setContent:[NSString stringWithFormat:@"%@-%@-%@",regeocode.province,regeocode.city,regeocode.district]];
//}

-(void)onPositionBtnBtnClick{
    if(_mViewModel){
        [_mViewModel goLocationPage];
    }
}

//-(void)updateLocation:(AMapPOI *)poi{
//    _addressDetailTF.text = [NSString stringWithFormat:@"%@%@",poi.address,poi.name];
//    _mViewModel.model.province = poi.province;
//    _mViewModel.model.city = poi.city;
//    _mViewModel.model.area = poi.district;
//    [_addressBtn setContent:[NSString stringWithFormat:@"%@-%@-%@",poi.province,poi.city,poi.district]];
//}
//
//-(void)onSearchPOIResult:(NSArray *)pois nextPage:(Boolean)nextPage{}
//


@end
