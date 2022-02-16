//
//  AddCorporateView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AddCorporateView.h"
#import "STBlankInView.h"
#import "STSelectInView.h"
#import "STSinglePickerLayerView.h"
#import "STConfirmLayerView.h"
#import "BankSelectModel.h"
#import "STCityPickerLayerView.h"
#import "STBankLayerView.h"

@interface AddCorporateView()<STBlankInViewDelegate,STSelectInViewDelegate,STConfirmLayerViewDelegate,STCityPickerLayerViewDelegate,STBankLayerViewDelegte>

@property(strong, nonatomic)AddBankViewModel *mViewModel;
//账号
@property(strong, nonatomic)STBlankInView *accountView;
//BK对公账户
@property(strong, nonatomic)STBlankInView *corporateBankView;
//开户BK
@property(strong, nonatomic)STSelectInView *bankView;
//支行
@property(strong, nonatomic)STBlankInView *subBranchView;
//开户所在地
@property(strong, nonatomic)STSelectInView *addressView;
//开户行选择
@property(strong, nonatomic)STBankLayerView *bankLayerView;
//开户所在地选择
@property(strong, nonatomic)STCityPickerLayerView *addressLayerView;

//确认选择
@property(strong, nonatomic)STConfirmLayerView *confirmLayerView;
//提交信息
@property(strong, nonatomic)NSMutableArray *confirmDatas;


@property(strong, nonatomic)UIButton *saveBtn;


@end

@implementation AddCorporateView{
    Boolean manualSelect;
}

-(instancetype)initWithViewModel:(AddBankViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        _confirmDatas = [[NSMutableArray alloc]init];
        [self initView];
    }
    return self;
}

-(void)initView{
    _accountView = [[STBlankInView alloc]initWithTitle:@"账户名称" placeHolder:@"请输入账户名称"];
    _accountView.frame = CGRectMake(0, STHeight(25), ScreenWidth, STHeight(50));
    _accountView.delegate = self;
    [self addSubview:_accountView];
    
    _corporateBankView = [[STBlankInView alloc]initWithTitle:MSG_BK_DUIGONG_TYPE placeHolder:MSG_BLANK_BK_DUIGONG];
    _corporateBankView.frame = CGRectMake(0, STHeight(90), ScreenWidth, STHeight(50));
    _corporateBankView.delegate = self;
    [_corporateBankView inputNumber];
    [self addSubview:_corporateBankView];
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(140), ScreenWidth, LineHeight)];
    line1.backgroundColor = cline;
    [self addSubview:line1];
    
    _bankView = [[STSelectInView alloc]initWithTitle:MSG_KAIHU_BK placeHolder:MSG_SELECT_BK frame : CGRectMake(0, STHeight(140)+LineHeight, ScreenWidth, STHeight(50))];
    _bankView.frame = CGRectMake(0, STHeight(140)+LineHeight, ScreenWidth, STHeight(50));
    _bankView.delegate = self;
    [self addSubview:_bankView];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(190)+LineHeight, ScreenWidth, LineHeight)];
    line2.backgroundColor = cline;
    [self addSubview:line2];
    
    _subBranchView = [[STBlankInView alloc]initWithTitle:@"支行名称" placeHolder:@"请输入支行名称"];
    _subBranchView.frame = CGRectMake(0, STHeight(190)+LineHeight*2, ScreenWidth, STHeight(50));
    _subBranchView.delegate = self;
    [self addSubview:_subBranchView];
    
    _addressView = [[STSelectInView alloc]initWithTitle:@"开户所在地" placeHolder:@"请选择" frame : CGRectMake(0, STHeight(255), ScreenWidth, STHeight(50))];
    _addressView.frame = CGRectMake(0, STHeight(255), ScreenWidth, STHeight(50));
    _addressView.delegate = self;
    [self addSubview:_addressView];
    
    _saveBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_SAVE textColor:c_btn_txt_highlight backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    _saveBtn.frame = CGRectMake(STWidth(15), STHeight(430), STWidth(345), STHeight(50));
    [_saveBtn addTarget:self action:@selector(onSaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveBtn];
    
    _addressLayerView = [[STCityPickerLayerView alloc]init];
    _addressLayerView.hidden = YES;
    _addressLayerView.delegate = self;
    [self addSubview:_addressLayerView];
    
    
    _bankLayerView = [[STBankLayerView alloc]init];
    _bankLayerView.delegate = self;
    _bankLayerView.hidden = YES;
    [self addSubview:_bankLayerView];
    
    //确认框
    [_confirmDatas removeAllObjects];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_TYPE content:MSG_BK_DUIGONG_TYPE]];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_ACCOUNT_NAME content:MSG_EMPTY]];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_DUIGONG content:MSG_EMPTY]];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_KAIHU content:MSG_EMPTY]];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_ZHIHANG content:MSG_EMPTY]];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_KAIHU_ADDRESS content:MSG_EMPTY]];

    _confirmLayerView = [[STConfirmLayerView alloc]initWithTitle:@"确认账户信息" datas:_confirmDatas];
    _confirmLayerView.delegate = self;
    _confirmLayerView.hidden = YES;
    [self addSubview:_confirmLayerView];
  
}

-(void)updateView{
    
}


-(void)onTextFieldDidChange:(UITextField *)textField{
    
}

-(void)onSelectClicked:(STSelectInView *)selectInView{
    [_accountView resign];
    [_corporateBankView resign];
    [_subBranchView resign];
    if(selectInView == _bankView){
        _addressLayerView.hidden = YES;
        if(manualSelect){
            manualSelect = NO;
            _bankLayerView.hidden = NO;
            return;
        }
        NSString *cardNumStr = [_corporateBankView getContent];
        if(IS_NS_STRING_EMPTY(cardNumStr)){
            _bankLayerView.hidden = NO;
        }else{
            manualSelect = YES;
            [_mViewModel checkCardNum:cardNumStr];
        }
    }
    else if(selectInView == _addressView){
        _addressLayerView.hidden = NO;
        _bankLayerView.hidden = YES;
    }

}
    
-(void)updateBankName:(BankSelectModel *)bankModel{
    [_bankLayerView updatePosition:bankModel];
    [_bankView setContent:bankModel.bank_name];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_accountView resign];
    [_corporateBankView resign];
    [_subBranchView resign];

}


//点击修改
-(void)onUpdateBtnClicked{
    _confirmLayerView.hidden = YES;

}

//点击确认
-(void)onConfirmBtnClicked{
    _mViewModel.model.accountName = [_accountView getContent];
    _mViewModel.model.bankBranch = [_subBranchView getContent];
    _mViewModel.model.bankId = [_corporateBankView getContent];

    BankSelectModel *bankModel = [_bankLayerView getCurrentModel];
    _mViewModel.model.bankCode = bankModel.bank_code;
    _mViewModel.model.bankName = bankModel.bank_name;
    
    CitySelectModel *cityModel = [_addressLayerView getCurrentModel];
    _mViewModel.model.cityCode = cityModel.city_code;
    _mViewModel.model.cityName = cityModel.city_name;
    
    _confirmLayerView.hidden = YES;
    if(_mViewModel){
        [_mViewModel doSaveCorporateBank];
    }
}


-(void)onSaveBtnClick{
    
    if(IS_NS_STRING_EMPTY([_accountView getContent])){
        [LCProgressHUD showMessage:@"请输入账户名称"];
        return;
    }
    if(IS_NS_STRING_EMPTY([_corporateBankView getContent])){
        [LCProgressHUD showMessage:MSG_BLANK_BK_DUIGONG];
        return;
    }
    if(IS_NS_STRING_EMPTY([_bankView getContent])){
        [LCProgressHUD showMessage:MSG_SELECT_BK];
        return;
    }
    if(IS_NS_STRING_EMPTY([_subBranchView getContent])){
        [LCProgressHUD showMessage:MSG_BLANK_ZHIHANG];
        return;
    }
    if(IS_NS_STRING_EMPTY([_addressView getContent])){
        [LCProgressHUD showMessage:MSG_SELECT_KAIHU_ADDRESS];
        return;
    }
    if(!IS_NS_COLLECTION_EMPTY(_confirmDatas) && _confirmDatas.count >= 6){
        ((TitleContentModel *)[_confirmDatas objectAtIndex:1]).content = [_accountView getContent];
        ((TitleContentModel *)[_confirmDatas objectAtIndex:2]).content = [_corporateBankView getContent];
        ((TitleContentModel *)[_confirmDatas objectAtIndex:3]).content = [_bankView getContent];
        ((TitleContentModel *)[_confirmDatas objectAtIndex:4]).content = [_subBranchView getContent];
        ((TitleContentModel *)[_confirmDatas objectAtIndex:5]).content = [_addressView getContent];

    }
    
    [_confirmLayerView updateContents:_confirmDatas];
    _confirmLayerView.hidden = YES;
    
    _addressLayerView.hidden = YES;
    _bankLayerView.hidden = YES;
    _confirmLayerView.hidden = NO;
    

}


-(void)onSelectResult:(UIView *)layerView province:(NSString *)provinceStr city:(NSString *)cityStr code:(NSString *)code{
    [_addressView setContent:[NSString stringWithFormat:@"%@%@",provinceStr,cityStr]];
}

-(void)onSelectResult:(BankSelectModel *)data layerView:(UIView *)layerView position:(NSInteger)position{
    [_bankView setContent:data.bank_name];
}

@end

