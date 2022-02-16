//
//  AddPersonalView.m
//  manage
//
//  Created by by.huang on 2018/12/1.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AddPersonalView.h"
#import "STBlankInView.h"
#import "STSelectInView.h"
#import "STSinglePickerLayerView.h"
#import "STConfirmLayerView.h"
#import "STBankLayerView.h"

@interface AddPersonalView()<STBlankInViewDelegate,STSelectInViewDelegate,STBankLayerViewDelegte,STConfirmLayerViewDelegate>

@property(strong, nonatomic)AddBankViewModel *mViewModel;
//开卡人姓名
@property(strong, nonatomic)STBlankInView *nameView;
//BK卡号
@property(strong, nonatomic)STBlankInView *cardNumView;
//开户BK
@property(strong, nonatomic)STSelectInView *bankView;

//开户行选择
@property(strong, nonatomic)STBankLayerView *bankLayerView;

//确认选择
@property(strong, nonatomic)STConfirmLayerView *confirmLayerView;
//提交信息
@property(strong, nonatomic)NSMutableArray *confirmDatas;

@property(strong, nonatomic)UIButton *saveBtn;


@end

@implementation AddPersonalView{
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
    _nameView = [[STBlankInView alloc]initWithTitle:@"开卡人姓名" placeHolder:MSG_BLANK_KAIKAREN_NAME];
    _nameView.frame = CGRectMake(0, STHeight(25), ScreenWidth, STHeight(50));
    _nameView.delegate = self;
    [self addSubview:_nameView];
    
    _cardNumView = [[STBlankInView alloc]initWithTitle:MSG_CARDNUM_BK placeHolder:MSG_BLANK_BK_CARDNUM];
    _cardNumView.frame = CGRectMake(0, STHeight(90), ScreenWidth, STHeight(50));
    _cardNumView.delegate = self;
    [_cardNumView inputNumber];
    [self addSubview:_cardNumView];
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(140), ScreenWidth, LineHeight)];
    line1.backgroundColor = cline;
    [self addSubview:line1];
    
    _bankView = [[STSelectInView alloc]initWithTitle:MSG_KAIHU_BK placeHolder:MSG_SELECT_BK frame : CGRectMake(0, STHeight(140)+LineHeight, ScreenWidth, STHeight(50))];
    _bankView.frame = CGRectMake(0, STHeight(140)+LineHeight, ScreenWidth, STHeight(50));
    _bankView.delegate = self;
    [self addSubview:_bankView];
    
    
    _saveBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_SAVE textColor:c_btn_txt_highlight backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    _saveBtn.frame = CGRectMake(STWidth(15), STHeight(430), STWidth(345), STHeight(50));
    [_saveBtn addTarget:self action:@selector(onSaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveBtn];
    
    _bankLayerView = [[STBankLayerView alloc]init];
    _bankLayerView.delegate = self;
    _bankLayerView.hidden = YES;
    [self addSubview:_bankLayerView];
    
    
    //确认框
    [_confirmDatas removeAllObjects];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_TYPE content:MSG_BK_GEREN_TYPE]];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_KAIKAREN_NAME content:MSG_EMPTY]];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_CARDNUM content:MSG_EMPTY]];
    [_confirmDatas addObject:[TitleContentModel buildModel:MSG_BK_KAIHU content:MSG_EMPTY]];
    
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
    [_nameView resign];
    [_cardNumView resign];
    if(selectInView == _bankView){
        if(manualSelect){
            manualSelect = NO;
            _bankLayerView.hidden = NO;
            return;
        }
        NSString *cardNumStr = [_cardNumView getContent];
        if(IS_NS_STRING_EMPTY(cardNumStr)){
            _bankLayerView.hidden = NO;
        }else{
            manualSelect = YES;
            [_mViewModel checkCardNum:cardNumStr];
        }
    }
    
}
    
-(void)updateBankName:(BankSelectModel *)bankModel{
    [_bankLayerView updatePosition:bankModel];
    [_bankView setContent:bankModel.bank_name];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nameView resign];
    [_cardNumView resign];
    
}

-(void)onSelectResult:(BankSelectModel *)data layerView:(UIView *)layerView position:(NSInteger)position{
    [_bankView setContent:data.bank_name];
}

//点击修改
-(void)onUpdateBtnClicked{
    _confirmLayerView.hidden = YES;
    
}

//点击确认
-(void)onConfirmBtnClicked{
    _mViewModel.model.accountName = [_nameView getContent];
    _mViewModel.model.bankId = [_cardNumView getContent];
    
    BankSelectModel *bankModel = [_bankLayerView getCurrentModel];
    _mViewModel.model.bankCode = bankModel.bank_code;
    _mViewModel.model.bankName = bankModel.bank_name;
    
    _confirmLayerView.hidden = YES;
    if(_mViewModel){
        [_mViewModel doSavePersonBank];
    }
}


-(void)onSaveBtnClick{
    if(IS_NS_STRING_EMPTY([_nameView getContent])){
        [LCProgressHUD showMessage:MSG_BLANK_KAIKAREN_NAME];
        return;
    }
    if(IS_NS_STRING_EMPTY([_cardNumView getContent])){
        [LCProgressHUD showMessage:MSG_BLANK_BK_CARDNUM];
        return;
    }
    if(IS_NS_STRING_EMPTY([_bankView getContent])){
        [LCProgressHUD showMessage:MSG_SELECT_BK];
        return;
    }

    if(!IS_NS_COLLECTION_EMPTY(_confirmDatas) && _confirmDatas.count >= 4){
        ((TitleContentModel *)[_confirmDatas objectAtIndex:1]).content = [_nameView getContent];
        ((TitleContentModel *)[_confirmDatas objectAtIndex:2]).content = [_cardNumView getContent];
        ((TitleContentModel *)[_confirmDatas objectAtIndex:3]).content = [_bankView getContent];
        
    }
    
    [_confirmLayerView updateContents:_confirmDatas];
    _confirmLayerView.hidden = YES;
    
    _bankLayerView.hidden = YES;
    _confirmLayerView.hidden = NO;
    
}

@end
