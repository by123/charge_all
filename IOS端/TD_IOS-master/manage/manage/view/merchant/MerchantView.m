//
//  MerchantView.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "MerchantView.h"
#import "STSelectLayerButton.h"
#import "TouchScrollView.h"
#import "STSinglePickerLayerView.h"
#import "AccountManager.h"
#import "ScaleViewCell.h"
#import "ScaleModel.h"
#import "STConvertUtil.h"
#import "MerchantModel.h"
#import "IndustryModel.h"
#import "STAddressPickerLayerView.h"
#import "STSelectInView.h"
#import "MapManage.h"
#import "STProfitView.h"
#import "STNetUtil.h"

@interface MerchantView()<STSinglePickerLayerViewDelegate,UITableViewDelegate,UITableViewDataSource,ScaleViewCellDelegate,UITextFieldDelegate,STSelectInViewDelegate,STAddressPickerLayerViewDelegate,STProfitViewDelegate>

@property(strong, nonatomic)MerchantViewModel *mViewModel;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)STSelectLayerButton *chainBtn;
@property(strong, nonatomic)UITextField *nameTF;
@property(strong, nonatomic)STSelectLayerButton *industryBtn;
@property(strong, nonatomic)STSelectLayerButton *ruleBtn;
@property(strong, nonatomic)UITextField *contactNameTF;
@property(strong, nonatomic)UITextField *contactPhoneTF;
@property(strong, nonatomic)UITextField *freezeTF;
@property(strong, nonatomic)UIButton *addBtn;
@property(strong, nonatomic)UITableView *scaleTableView;
@property(strong, nonatomic)NSMutableArray *scaleDatas;

@property(strong, nonatomic)UILabel *profitLabel;

@property(strong, nonatomic)STSinglePickerLayerView *chainsLayerView;
@property(strong, nonatomic)STSinglePickerLayerView *industryLayerView;
@property(strong, nonatomic)STSinglePickerLayerView *timeLayer;
@property(strong, nonatomic)STSinglePickerLayerView *ruleLayer;
@property(strong, nonatomic)UIButton *addScaleBtn;

@property(strong, nonatomic)NSMutableArray *times;
@property(strong, nonatomic)NSMutableArray *allDatas;
@property(strong, nonatomic)NSMutableArray *industryDatas;

@property(strong, nonatomic)STSelectInView *addressBtn;
@property(strong, nonatomic)STAddressPickerLayerView *addressLayerView;
@property(strong, nonatomic)UITextField *addressDetailTF;


@property(strong, nonatomic)UILabel *addressLabel;
@property(strong, nonatomic)UIView *addressView;
@property(strong, nonatomic)UILabel *bottomLabel;
@property(strong, nonatomic)UIView *bottomView;
@property(strong, nonatomic)UIView *preView;
@property(strong, nonatomic)STProfitView *profitView;
@property(strong, nonatomic)NSArray *rules;


@property(strong, nonatomic)UITextField *prepaidTF;
@property(strong, nonatomic)UITextField *maxMoneyTF;
@property(strong, nonatomic)UITextField *minMoneyTF;
@property(strong, nonatomic)UITextField *minMinutesTF;
@property(strong, nonatomic)UITextField *stepMinutesTF;
@property(strong, nonatomic)UITextField *priceTF;

@property(assign, nonatomic)Boolean isWhiteList;

@end

@implementation MerchantView{
    NSInteger buttonPosition;
    NSInteger chainPosition;
    float totalPercent;
    NSInteger rulePosition;
}


-(instancetype)initWithViewModel:(MerchantViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        _scaleDatas = [[NSMutableArray alloc]init];
        _allDatas = [ScaleModel getTimesData];
        _rules = @[@"阶梯收费",@"预付费"];
        rulePosition = 0;
        UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
        totalPercent = model.totalPercent;
        [self initView];
        NSString *result = [STUserDefaults getKeyValue:UD_INDUSTY];
        _industryDatas = [IndustryModel mj_objectArrayWithKeyValuesArray:result];
        if(!IS_NS_COLLECTION_EMPTY(_industryDatas)){
            IndustryModel *firstModel = _industryDatas[0];
            [self createScaleDatas:firstModel];
        }

    }
    return self;
}


//创建新数据
-(void)createScaleDatas:(IndustryModel *)model{
    //清空数组
    [_scaleDatas removeAllObjects];
    //重新创建数据
    [self useConfigRule:model];
    [self restoreRule];
    [self initBottom];
}

//删除已选择重复档位
-(void)restoreRule{
    
    //重置时间选择器
    [_times removeAllObjects];
    for(TitleContentModel *model in _allDatas){
        [_times addObject:[NSString stringWithFormat:@"%@%@",model.content,model.extra]];
    }
    
    //找出重复的档位
    NSMutableArray *positionArray = [[NSMutableArray alloc]init];
    for(ScaleModel *model in _scaleDatas){
        for(int i= 0 ;i < _times.count ; i ++){
            NSString *timeStr= [_times objectAtIndex:i];
            timeStr = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-2)];
            if([model.timeModel.content isEqualToString:timeStr]){
                [positionArray addObject:[NSString stringWithFormat:@"%@小时",timeStr]];
            }
        }
    }
    //删除重复档位
    if(!IS_NS_COLLECTION_EMPTY(positionArray)){
        for(int i= 0 ;i < positionArray.count ; i ++){
            [_times removeObject:positionArray[i]];
        }
    }
    [_timeLayer updateDatas:_times];
}

//当后台无数据返回，采用本地规则
//-(void)useLocalRule{
//    for(int i = 0 ; i < 2 ; i ++){
//        NSString *title = [self formatScaleTitle:i];
//        TitleContentModel *model = [[TitleContentModel alloc]init];
//        if(i == 0){
//            model =  [_allDatas objectAtIndex:0];
//            [_scaleDatas addObject:[ScaleModel build:title timeModel:model price:@"2" isDelete:NO]];
//        }
//        else if(i == 1){
//            model =  [_allDatas objectAtIndex:7];
//            [_scaleDatas addObject:[ScaleModel build:title timeModel:model price:@"3" isDelete:YES]];
//        }else{
//            [_scaleDatas addObject:[ScaleModel build:title timeModel:model price:MSG_EMPTY isDelete:YES]];
//        }
//    }
//}

//后台返回结果，用服务端规则
//-(void)useServerRule{
//    Boolean firstNotDelete = NO;
//    for(int i = 0 ; i < _mViewModel.rules.count ; i ++){
//        NSString *title = [self formatScaleTitle:i];
//        PayRuleModel *ruleModel = [_mViewModel.rules objectAtIndex:i];
//        for(TitleContentModel *model in _allDatas){
//            if([model.extra2 intValue]  == ruleModel.time){
//                [_scaleDatas addObject:[ScaleModel build:title timeModel:model price:[NSString stringWithFormat:@"%ld",ruleModel.price/100] isDelete:firstNotDelete]];
//                firstNotDelete = YES;
//            }
//        }
//    }
//}

//使用配置规则
-(void)useConfigRule:(IndustryModel *)model{
    NSMutableArray *rules = [PayRuleModel mj_objectArrayWithKeyValuesArray:model.rule];
    if(!IS_NS_COLLECTION_EMPTY(rules)){
        for(int i = 0; i < rules.count ; i ++){
            NSString *title = [self formatScaleTitle:i];
            PayRuleModel *ruleModel = rules[i];
            NSString *price = [NSString stringWithFormat:@"%.2f",(double)ruleModel.price/100];
            if(i == 0){
                for(TitleContentModel *temp in _allDatas){
                    if([temp.title intValue]  == ruleModel.scale){
                        [_scaleDatas addObject:[ScaleModel build:title timeModel:temp price:price isDelete:NO]];
                    }
                }
            }else{
                for(TitleContentModel *temp in _allDatas){
                    if([temp.title intValue]  == ruleModel.scale){
                        [_scaleDatas addObject:[ScaleModel build:title timeModel:temp price:price isDelete:YES]];
                    }
                }
            }
        }
    }
}

//增加一条数据
-(void)addScaleData{
    [self saveExitData];
    NSString *title = [self formatScaleTitle:[_scaleDatas count]];
    TitleContentModel *model =[[TitleContentModel alloc]init];
    [_scaleDatas addObject:[ScaleModel build:title timeModel:model price:MSG_EMPTY isDelete:YES]];
    
//    for (ScaleModel *model in _scaleDatas){
//        [STLog print:model.timeModel.mj_JSONString content:model.price];
//    }
}


//删除一条数据
-(void)deleteScaleData:(NSInteger)position{
    [self saveExitData];
    [_scaleDatas removeObjectAtIndex:position];
    [self restoreScale];
    [self restoreRule];
}

//档位复原
-(void)restoreScale{
    for(int i = 0 ; i < _scaleDatas.count ; i ++){
        ScaleModel *model = [_scaleDatas objectAtIndex:i];
        model.title = [self formatScaleTitle:i];
    }
}


//保存已经填写的数据
-(void)saveExitData{
    for(int i = 0 ; i < _scaleDatas.count ; i ++){
        ScaleViewCell *cell = [_scaleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        ScaleModel *model = [_scaleDatas objectAtIndex:i];
        model.price = [cell getPriceTF].text;
        
    }
}

//数字转档位(例如：1 转成 第一档)
-(NSString *)formatScaleTitle:(NSInteger)position{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    formatter.locale = locale;
    NSString *result = [NSString stringWithFormat:@"第%@档",[formatter stringFromNumber:[NSNumber numberWithInteger: position + 1]]];
    return result;
}

-(void)initView{
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:nil];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    [self addSubview:_scrollView];
    [self initTop];
    [self initFreeze];
    [self initProfit];
//    [self initBottom];
    [self initAddress];
    
    _addBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_SAVE textColor:c_btn_txt_normal backgroundColor:c05 corner:0 borderWidth:0 borderColor:nil];
    _addBtn.frame = CGRectMake(0, ContentHeight -  STHeight(50), ScreenWidth, STHeight(50));
    _addBtn.enabled = NO;
    [_addBtn addTarget:self action:@selector(onAddBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    [self addIndustrySelect];
    [self addTimeSelect];
    [self addRuleSelect];
    
    _addressLayerView = [[STAddressPickerLayerView alloc]init];
    _addressLayerView.hidden = YES;
    _addressLayerView.delegate = self;
    [self addSubview:_addressLayerView];
    
    [_mViewModel queryChildChain];
    
//    [MapManage sharedMapManage].delegate = self;
//    [[MapManage sharedMapManage] positionLocation];
    
    WS(weakSelf)
    [STNetUtil getConfig:CONFIG_RELATIVE_PERCENT_WHITELIST success:^(NSString *result) {
        NSMutableArray *datas= [STConvertUtil jsonToDic:result];
        if(!IS_NS_COLLECTION_EMPTY(datas)){
            UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
            weakSelf.isWhiteList = NO;
            for(NSString *mchId in datas){
                if([model.mchId isEqualToString:mchId]){
                    weakSelf.isWhiteList = YES;
                    break;
                }
            }
            if(model.level == 4 && model.mchType == 0){
               [weakSelf.profitView hiddenRelative:YES];
                weakSelf.isWhiteList = NO;
            }else{
                [weakSelf.profitView hiddenRelative:!weakSelf.isWhiteList];
            }
        }
    }];
}
    

-(void)updateChildChain{
    NSMutableArray *chainNames = [[NSMutableArray alloc]init];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.chains)){
        for(MerchantModel *model in _mViewModel.chains){
            if(IS_NS_STRING_EMPTY(model.mchName)){
                [chainNames addObject:@"无"];
            }else{
                [chainNames addObject:model.mchName];
            }
        }
    }
    [_chainBtn setSelectText:chainNames[0]];
    
    _chainsLayerView = [[STSinglePickerLayerView alloc]initWithDatas:chainNames];
    _chainsLayerView.hidden = YES;
    _chainsLayerView.delegate = self;
    [self addSubview:_chainsLayerView];
    
    
}
    
-(void)addIndustrySelect{
    _industryLayerView = [[STSinglePickerLayerView alloc]initWithDatas:MSG_INDUSTRYS];
    _industryLayerView.hidden = YES;
    _industryLayerView.delegate = self;
    [_industryLayerView setData:MSG_INDUSTRYS[1]];
    [self addSubview:_industryLayerView];
    
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    if(model.level == 4){
        for(int i = 0 ; i < MSG_INDUSTRYS.count;  i++){
            NSString *tempStr = MSG_INDUSTRYS[i];
            if([tempStr isEqualToString:model.industry]){
                [_industryBtn setSelectText:MSG_INDUSTRYS[i]];
                [_industryLayerView setData:tempStr];
                break;
            }
        }
    }
//    else{
//        [_industryBtn setSelectText:MSG_INDUSTRYS[0]];
//    }
    
}


-(void)addTimeSelect{
    _times = [[NSMutableArray alloc]init];
    _timeLayer = [[STSinglePickerLayerView alloc]initWithDatas:_times];
    _timeLayer.hidden = YES;
    _timeLayer.delegate = self;
    [self addSubview:_timeLayer];
}

-(void)addRuleSelect{
    _ruleLayer = [[STSinglePickerLayerView alloc]initWithDatas:_rules];
    _ruleLayer.hidden = YES;
    _ruleLayer.delegate = self;
    [self addSubview:_ruleLayer];
}

-(void)initTop{
     [_scrollView addSubview:[self buildTitle:@"商户信息" height:0]];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(50), ScreenWidth, STHeight(300))];
    topView.backgroundColor = cwhite;
    [self buildTitleAndLine:topView];
    [_scrollView addSubview:topView];
    
    _chainBtn = [[STSelectLayerButton alloc]initWithFrame:CGRectMake(STWidth(160), 0 , STWidth(200),STHeight(50))];
    [_chainBtn addTarget:self action:@selector(onChainBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_chainBtn];
    
    _nameTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _nameTF.textAlignment = NSTextAlignmentRight;
    [_nameTF setPlaceholder:@"请输入商户名称" color:c05 fontSize:STFont(15)];
    _nameTF.frame = CGRectMake(STWidth(110), STHeight(50) , STWidth(250),STHeight(50));
    [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _nameTF.returnKeyType = UIReturnKeyNext;
    [topView addSubview:_nameTF];
    
    _industryBtn = [[STSelectLayerButton alloc]initWithFrame:CGRectMake(STWidth(160), STHeight(100) , STWidth(200),STHeight(50))];
    [_industryBtn setHolderText:@"请选择"];
    [_industryBtn addTarget:self action:@selector(onIndustyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_industryBtn];
    
    _contactNameTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _contactNameTF.textAlignment = NSTextAlignmentRight;
    [_contactNameTF setPlaceholder:@"请输入联系人姓名" color:c05 fontSize:STFont(15)];
    _contactNameTF.returnKeyType = UIReturnKeyNext;
    _contactNameTF.frame = CGRectMake(STWidth(110), STHeight(150), STWidth(250),STHeight(50));
    [_contactNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [topView addSubview:_contactNameTF];

    _contactPhoneTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _contactPhoneTF.textAlignment = NSTextAlignmentRight;
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    if(model.level == 4){
        [_contactPhoneTF setPlaceholder:@"非必填" color:c05 fontSize:STFont(15)];
    }else{
        [_contactPhoneTF setPlaceholder:@"请输入联系人电话" color:c05 fontSize:STFont(15)];
    }
    _contactPhoneTF.returnKeyType = UIReturnKeyNext;
    _contactPhoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _contactPhoneTF.maxLength = @"11";
    _contactPhoneTF.frame = CGRectMake(STWidth(110), STHeight(200), STWidth(250),STHeight(50));
    [_contactPhoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _contactPhoneTF.delegate = self;
    [topView addSubview:_contactPhoneTF];
}


-(void)initFreeze{
    [_scrollView addSubview:[self buildTitle:@"冻结金额（非必填）" height:STHeight(350)]];
    UIView *freezeView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(400), ScreenWidth, STHeight(100))];
    freezeView.backgroundColor = cwhite;
    [_scrollView addSubview:freezeView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"设置冻结金额" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    titleLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(50));
    [freezeView addSubview:titleLabel];
    
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
    _profitView = [[STProfitView alloc]initWithFrame:CGRectMake(0, STHeight(500), ScreenWidth, STHeight(150)) totalPercent:totalPercent allocPercent:0];
    _profitView.delegate = self;
    //默认隐藏
    [_profitView hiddenRelative:YES];
    [_scrollView addSubview:_profitView];
}


-(void)initBottom{
 
    _bottomLabel = [self buildTitle:@"计费规则" height:STHeight(650)];
    [_scrollView addSubview:_bottomLabel];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(700), ScreenWidth, 6 * STHeight(51) + STHeight(15))];
    _bottomView.backgroundColor = cwhite;
    _bottomView.userInteractionEnabled = YES;
    [_scrollView addSubview:_bottomView];
    
    NSString *ruleStr = @"使用计费规则";
    UILabel *ruleLabel = [[UILabel alloc]initWithFont:STFont(15) text:ruleStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize labelSize = [ruleStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    ruleLabel.frame = CGRectMake(STWidth(15), 0, labelSize.width, STHeight(50));
    [_bottomView addSubview:ruleLabel];
    
    _ruleBtn = [[STSelectLayerButton alloc]initWithFrame:CGRectMake(STWidth(160), 0 , STWidth(200),STHeight(50))];
    [_ruleBtn setHolderText:@"请选择"];
    [_ruleBtn setSelectText:_rules[rulePosition]];
    [_ruleBtn addTarget:self action:@selector(onRuleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_ruleBtn];
    
    [_ruleLayer setSelect:rulePosition];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(50)-LineHeight, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [_bottomView addSubview:lineView];
    
    [self initScaleTableView];
    [self initPreView];
    
}

-(void)initPreView{
    _preView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(51), ScreenWidth, STHeight(51) * 4)];
    _preView.userInteractionEnabled = YES;
    _preView.hidden = YES;
    [_bottomView addSubview:_preView];
    [self buildPreViewTitle:@"预付金额" left:STWidth(15) top:0];
    [self buildPreViewTitle:@"元" left:STWidth(350) top:0];
    [self buildPreViewTitle:@"封顶金额" left:STWidth(15) top:STHeight(51)];
    [self buildPreViewTitle:@"元" left:STWidth(350) top:STHeight(51)];
    [self buildPreViewTitle:@"首次" left:STWidth(15) top:STHeight(102)];
    [self buildPreViewTitle:@"小时" left:STWidth(150) top:STHeight(102)];
    [self buildPreViewTitle:@"元" left:STWidth(350) top:STHeight(102)];
    [self buildPreViewTitle:@"超过每" left:STWidth(15) top:STHeight(153)];
    [self buildPreViewTitle:@"小时" left:STWidth(150) top:STHeight(153)];
    [self buildPreViewTitle:@"元" left:STWidth(350) top:STHeight(153)];
    [self buildPreViewLine];
    
    _prepaidTF = [self buildPreViewTF:_prepaidTF left:STWidth(140) top:0 width:STWidth(200) keyboardType:UIKeyboardTypeDecimalPad];
    [_preView addSubview:_prepaidTF];
    
    _maxMoneyTF = [self buildPreViewTF:_maxMoneyTF left:STWidth(140) top:STHeight(51) width:STWidth(200) keyboardType:UIKeyboardTypeDecimalPad];
    [_preView addSubview:_maxMoneyTF];
    
    _minMinutesTF = [self buildPreViewTF:_minMinutesTF left:STWidth(70) top:STHeight(102) width:STWidth(70) keyboardType:UIKeyboardTypeNumberPad];
    [_preView addSubview:_minMinutesTF];

    _minMoneyTF = [self buildPreViewTF:_minMoneyTF left:STWidth(180) top:STHeight(102) width:STWidth(160) keyboardType:UIKeyboardTypeDecimalPad];
    [_preView addSubview:_minMoneyTF];

    _stepMinutesTF = [self buildPreViewTF:_stepMinutesTF left:STWidth(70) top:STHeight(153) width:STWidth(70) keyboardType:UIKeyboardTypeNumberPad];
    [_preView addSubview:_stepMinutesTF];

    _priceTF  = [self buildPreViewTF:_priceTF left:STWidth(180) top:STHeight(153) width:STWidth(160) keyboardType:UIKeyboardTypeDecimalPad];
    [_preView addSubview:_priceTF];
}

-(void)buildPreViewTitle:(NSString *)title left:(CGFloat)left top:(CGFloat)top{
    UILabel *label = [[UILabel alloc]initWithFont:STFont(15) text:title textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize labelSize = [title sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    label.frame = CGRectMake(left, top, labelSize.width, STHeight(50));
    [_preView addSubview:label];
}

-(void)buildPreViewLine{
    for(int i = 0 ; i < 4 ; i ++){
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), (i + 1) *  STHeight(51) - LineHeight, STWidth(345), LineHeight)];
        lineView.backgroundColor = cline;
        [_preView addSubview:lineView];
    }
}

-(UITextField *)buildPreViewTF:(UITextField *)textField left:(CGFloat)left top:(CGFloat)top width:(CGFloat)width keyboardType:(UIKeyboardType) keyboardType{
    textField = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    textField.textAlignment = NSTextAlignmentRight;
    textField.placeholder = @"请输入";
    textField.delegate = self;
    textField.keyboardType = keyboardType;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    textField.frame = CGRectMake(left, top, width,STHeight(51));
    return textField;
}

-(void)initScaleTableView{
    _scaleTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(15) + STHeight(51), ScreenWidth, STHeight(51) * _scaleDatas.count)];
    _scaleTableView.delegate = self;
    _scaleTableView.dataSource = self;
    [_scaleTableView setScrollEnabled:NO];
    [_scaleTableView useDefaultProperty];
    [_scaleTableView setSectionFooterHeight:STHeight(15)];
    [_bottomView addSubview:_scaleTableView];
    
    
    _addScaleBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(75),  STHeight(15) + STHeight(51) * (_scaleDatas.count+1) + STHeight(7), STWidth(95), STHeight(21))];
    [_addScaleBtn addTarget:self action:@selector(onAddScaleClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (STHeight(21) - STWidth(16))/2, STWidth(16), STWidth(16))];
    addImageView.image = [UIImage imageNamed:IMAGE_ADD_RULE];
    addImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_addScaleBtn addSubview:addImageView];
    
    UILabel *addLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"增加计费档" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize addSize = [addLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    addLabel.frame = CGRectMake(STWidth(21), 0, addSize.width, STHeight(21));
    [_addScaleBtn addSubview:addLabel];
    
    [_bottomView addSubview:_addScaleBtn];
}


-(void)initAddress{
    _addressLabel = [self buildTitle:@"区域位置（必填）" height:STHeight(715) + 6 * STHeight(51)];
    [_scrollView addSubview:_addressLabel];
    
    _addressView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(765) + 6 * STHeight(51), ScreenWidth, STHeight(100))];
    _addressView.backgroundColor = cwhite;
    [_scrollView addSubview:_addressView];
    
    _addressBtn = [[STSelectInView alloc]initWithTitle:MSG_PROVINCE_CITY_DISTRICT placeHolder:MSG_GROUP_SELECT_CITY frame : CGRectMake(0, 0, ScreenWidth-STWidth(31), STHeight(50)-LineHeight)];
    _addressBtn.delegate = self;
    [_addressView addSubview:_addressBtn];
    
    UIButton *positionBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-STWidth(31), (STHeight(50)- STWidth(16))/2, STWidth(16), STWidth(16))];
    [positionBtn setImage:[UIImage imageNamed:IMAGE_MCH_POSITION2] forState:UIControlStateNormal];
    [positionBtn addTarget:self action:@selector(onPositionBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_addressView addSubview:positionBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15),  STHeight(50) - LineHeight, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [_addressView addSubview:lineView];
    
    UILabel *addressDetailLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_ADDRESS_DETAIL textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize addressDetailSize = [addressDetailLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    addressDetailLabel.frame = CGRectMake(STWidth(15),  STHeight(50), addressDetailSize.width, STHeight(50));
    [_addressView addSubview:addressDetailLabel];
    
    _addressDetailTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _addressDetailTF.textAlignment = NSTextAlignmentRight;
    _addressDetailTF.delegate = self;
    _addressDetailTF.placeholder = @"详细地址";
    [_addressDetailTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _addressDetailTF.frame = CGRectMake(STWidth(30) + addressDetailSize.width, STHeight(50), ScreenWidth - STWidth(45) - addressDetailSize.width,STHeight(50));
    [_addressView addSubview:_addressDetailTF];
    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(510) +STHeight(138) + 9 * STHeight(51) + STHeight(200))];

}


-(UILabel *)buildTitle:(NSString *)title height:(CGFloat)height{
    UILabel *infoLabel = [[UILabel alloc]initWithFont:STFont(14) text:title textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize infoSize = [infoLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    infoLabel.frame = CGRectMake(STWidth(15), height, infoSize.width, STHeight(50));
    return infoLabel;
}

-(void)buildTitleAndLine:(UIView *)topView{
    NSArray *titles = @[@"所属连锁门店",@"商户名称",@"所属行业",@"联系人姓名",@"联系人电话"];
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
    [self buildTipsView:topView height:STHeight(250) tipsStr:MSG_CONTACTPHONE_TIPS];
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

//tableview




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_scaleDatas count];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = cwhite;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(36);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScaleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ScaleViewCell identify ]];
    if(!cell){
        cell = [[ScaleViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ScaleViewCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    [cell updateData:[_scaleDatas objectAtIndex:indexPath.section] positon:indexPath.section];
    return cell;
}


//


-(void)onAddBtnClicked{
    
    [self saveExitData];
    
    _mViewModel.model.mchName = _nameTF.text;
    _mViewModel.model.industry = [_industryBtn getSelectText];
    _mViewModel.model.contactUser = _contactNameTF.text;
    _mViewModel.model.contactPhone = _contactPhoneTF.text;
    _mViewModel.model.blockedAmount = _freezeTF.text;
    _mViewModel.model.pledge = @"0";
    _mViewModel.model.detailAddr = _addressDetailTF.text;
    
    _mViewModel.model.profitSubAgent = [_profitView getProfitPercent];
    if(_profitView.isRelative){
        _mViewModel.model.profitPool = [_profitView getProfitPool];
        _mViewModel.model.percentInPool = [_profitView getProfitPercentInPool];
    }
    if(rulePosition == 0){
        NSMutableArray *array = [[NSMutableArray alloc]init];
        Boolean checkData = YES;
        if(!IS_NS_COLLECTION_EMPTY(_scaleDatas)){
            for(int i = 0 ; i <  _scaleDatas.count ; i ++){
                ScaleModel *model = [_scaleDatas objectAtIndex:i];
                if(!IS_NS_STRING_EMPTY(model.timeModel.extra2) && !IS_NS_STRING_EMPTY(model.timeModel.title)){
                    ScaleItemModel *itemModel = [[ScaleItemModel alloc]init];
                    itemModel.time = model.timeModel.extra2;
                    itemModel.scale = [model.timeModel.title intValue];
                    itemModel.price = (int)([model.price doubleValue] * 100);
                    [array addObject:itemModel.mj_JSONString];
                    if(itemModel.price == 0){
                        checkData = NO;
                    }
                }
             
            }
        }
        if(!checkData){
            [LCProgressHUD showMessage:@"计费档位价格不能为0，请完善"];
            return;
        }
        
        _mViewModel.model.service =[STConvertUtil arrayToJson:array];
        _mViewModel.model.serviceType = 1;
        
    }else{
        ServiceItemModel *model = [[ServiceItemModel alloc]init];
        model.prepaid = [_prepaidTF.text doubleValue] * 100;
        model.maxMoney = [_maxMoneyTF.text doubleValue] * 100;
        model.minMinutes = [_minMinutesTF.text intValue] * 60;
        model.stepMinutes = [_stepMinutesTF.text intValue] * 60;
        model.minMoney = [_minMoneyTF.text doubleValue] * 100;
        model.price = [_priceTF.text doubleValue] * 100;
        
        _mViewModel.model.service = model.mj_JSONString;
        _mViewModel.model.serviceType = 2;
    }
  
    [STLog print:_mViewModel.model.service];
    [STLog print:_mViewModel.model.mj_JSONString];

    if(_mViewModel){
        UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
        //如果选择中第一条并且不是连锁门店，则创建普通商户
        if(chainPosition == 0 && model.level != 4){
            [_mViewModel addMerchant];
        }else{
            MerchantModel *model = [_mViewModel.chains objectAtIndex:chainPosition];
            _mViewModel.model.parentAgencyId = model.mchId;
            [_mViewModel addChildChain];
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
    [self changeAddBtnStatu];
    if(!IS_NS_STRING_EMPTY(_maxMoneyTF.text) && !IS_NS_STRING_EMPTY(_prepaidTF.text)){
        double maxMoeny = [_maxMoneyTF.text doubleValue];
        double prepaid = [_prepaidTF.text doubleValue];
        if(maxMoeny > prepaid){
            [LCProgressHUD showMessage:@"封顶金额不能大于预付费金额"];
            _maxMoneyTF.text = @"";
        }
    }
    if(!IS_NS_STRING_EMPTY(_prepaidTF.text) && !IS_NS_STRING_EMPTY(_minMoneyTF.text)){
        double prepaid = [_prepaidTF.text doubleValue];
        double minMoney = [_minMoneyTF.text doubleValue];
        if(minMoney > prepaid){
            [LCProgressHUD showMessage:@"首次金额不能大于预付费金额"];
            _minMoneyTF.text = @"";
        }
    }
    if(!IS_NS_STRING_EMPTY(_prepaidTF.text) && !IS_NS_STRING_EMPTY(_priceTF.text)){
        double prepaid = [_prepaidTF.text doubleValue];
        double priceMoney = [_priceTF.text doubleValue];
        if(priceMoney > prepaid){
            [LCProgressHUD showMessage:@"超过金额不能大于预付费金额"];
            _priceTF.text = @"";
        }
    }
}

-(void)onProfitTextFieldDidChange{
    [self changeAddBtnStatu];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == _contactPhoneTF){
        return [self validateNumber:string format:@"0123456789"];
    }
    if(textField == _freezeTF){
        return [self validateNumber:string format:@"0123456789."];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number format:(NSString *)formatStr{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:formatStr];
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

-(void)changeAddBtnStatu{
    if(!IS_NS_STRING_EMPTY(_nameTF.text) &&
       [_profitView isProfitFill] &&
       !IS_NS_STRING_EMPTY(_contactNameTF.text) &&
       !IS_NS_STRING_EMPTY([_industryBtn getSelectText]) &&
       !IS_NS_STRING_EMPTY(_addressDetailTF.text) &&
       !IS_NS_STRING_EMPTY([_addressBtn getContent])){
        if(rulePosition == 1 && (IS_NS_STRING_EMPTY(_prepaidTF.text) ||
                                 IS_NS_STRING_EMPTY(_maxMoneyTF.text) ||
                                 IS_NS_STRING_EMPTY(_minMinutesTF.text) ||
                                 IS_NS_STRING_EMPTY(_minMoneyTF.text) ||
                                 IS_NS_STRING_EMPTY(_stepMinutesTF.text) ||
                                 IS_NS_STRING_EMPTY(_priceTF.text))){
                [_addBtn setBackgroundColor:c05 forState:UIControlStateNormal];
                _addBtn.enabled = NO;
                [_addBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
        }else{
            UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
            if(chainPosition == 0 && model.level != 4){
                if(!IS_NS_STRING_EMPTY(_contactPhoneTF.text)){
                    [_addBtn setBackgroundColor:c01 forState:UIControlStateNormal];
                    _addBtn.enabled = YES;
                    [_addBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
                }else{
                    [_addBtn setBackgroundColor:c05 forState:UIControlStateNormal];
                    _addBtn.enabled = NO;
                    [_addBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
                }
            }else{
                [_addBtn setBackgroundColor:c01 forState:UIControlStateNormal];
                _addBtn.enabled = YES;
                [_addBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
            }
        }
    }else{
        [_addBtn setBackgroundColor:c05 forState:UIControlStateNormal];
        _addBtn.enabled = NO;
        [_addBtn setTitleColor:c_btn_txt_normal forState:UIControlStateNormal];
    }
}
    
-(void)onChainBtnClicked{
    [self resignAllTF];
    _chainsLayerView.hidden = NO;
    _addressLayerView.hidden = YES;
    _industryLayerView.hidden = YES;
    _ruleLayer.hidden = YES;
}

-(void)onIndustyBtnClicked{
    [self resignAllTF];
    _addressLayerView.hidden = YES;
    _chainsLayerView.hidden = YES;
    _industryLayerView.hidden = NO;
    _ruleLayer.hidden = YES;
}

-(void)onSelectClicked:(id)selectInView{
    [self resignAllTF];
    _addressLayerView.hidden = NO;
    _chainsLayerView.hidden = YES;
    _industryLayerView.hidden = YES;
    _ruleLayer.hidden = YES;
}

-(void)onRuleBtnClicked{
    [self resignAllTF];
    _addressLayerView.hidden = YES;
    _chainsLayerView.hidden = YES;
    _industryLayerView.hidden = YES;
    _ruleLayer.hidden = NO;
}

-(void)onSelectResult:(UIView *)layerView province:(NSString *)provinceStr city:(NSString *)cityStr area:(NSString *)area{
    if(layerView == _addressLayerView){
        _mViewModel.model.province = provinceStr;
        _mViewModel.model.city = cityStr;
        _mViewModel.model.area = area;
        [_addressBtn setContent:[NSString stringWithFormat:@"%@-%@-%@",provinceStr,cityStr,area]];
    }
}

-(void)onSelectResult:(NSString *)result layerView:(id)layerView position:(NSInteger)position{
    if(layerView == _industryLayerView){
        [_industryBtn setSelectText:result];
        [self changeAddBtnStatu];
        if(!IS_NS_COLLECTION_EMPTY(_industryDatas)){
            IndustryModel *model  = _industryDatas[position];
            [_scaleDatas removeAllObjects];
            [self useConfigRule:model];
            [self restoreRule];
            [self updateTableViewUI];
        }
    }else if(layerView == _ruleLayer){
        rulePosition = position;
        [_ruleBtn setSelectText:result];
        [self changeAddBtnStatu];
        if(position == 0){
            _scaleTableView.hidden = NO;
            _addScaleBtn.hidden = NO;
            _preView.hidden = YES;
        }else{
            _scaleTableView.hidden = YES;
            _addScaleBtn.hidden = YES;
            _preView.hidden = NO;
        }

    }
    else if(layerView == _chainsLayerView){
        chainPosition = position;
        UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
        if(model.level == 4 || position !=0){
            _contactPhoneTF.placeholder = @"非必填";
            MerchantModel *model = [_mViewModel.chains objectAtIndex:chainPosition];          
            totalPercent = model.totalPercent;
        }else{
            _contactPhoneTF.placeholder = @"请输入联系人电话";
            totalPercent = model.totalPercent;
        }
//        [self textFieldDidChange:_profitTF];
        [_chainBtn setSelectText:result];
        if(!IS_NS_COLLECTION_EMPTY(_mViewModel.chains)){
            MerchantModel *model = [_mViewModel.chains objectAtIndex:position];
            [_industryBtn setSelectText:model.industry];
        }
        [self changeAddBtnStatu];
        if(chainPosition == 0 && _isWhiteList){
            [_profitView hiddenRelative:NO];
        }else{
            [_profitView hiddenRelative:YES];
            [_profitView changeAbsoluteProfitView];
        }
        [_profitView setProfitPercent:@"0"];
        [_profitView updateTips:totalPercent allocPercent:0];
    }
    else if(layerView == _timeLayer){
        
        ScaleViewCell *cell = (ScaleViewCell *)[_scaleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:buttonPosition]];
        
        ScaleModel *scaleModel = [_scaleDatas objectAtIndex:buttonPosition];
        NSString *timeStr = [_times objectAtIndex:position];
        timeStr = [timeStr substringWithRange:NSMakeRange(0, timeStr.length-2)];
        for(TitleContentModel *model in _allDatas){
            if([model.content isEqualToString:timeStr]){
                scaleModel.timeModel = model;
                break;
            }
        }
        [cell updateTime:scaleModel.timeModel];
        [[cell getPriceTF] becomeFirstResponder];
        
        [self restoreRule];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignAllTF];

}

//表单TF失去焦点
-(void)resignAllTF{
    [_nameTF resignFirstResponder];
    [_profitView resignFirstResponder];
    [_contactPhoneTF resignFirstResponder];
    [_contactNameTF resignFirstResponder];
    [_freezeTF resignFirstResponder];
    [_addressDetailTF resignFirstResponder];
    [_prepaidTF resignFirstResponder];
    [_stepMinutesTF resignFirstResponder];
    [_priceTF resignFirstResponder];
    [_minMoneyTF resignFirstResponder];
    [_minMinutesTF resignFirstResponder];
    [_maxMoneyTF resignFirstResponder];

//    [_pledgeTF resignFirstResponder];
    //所有tf失去焦点
    if(!IS_NS_COLLECTION_EMPTY(_scaleDatas)){
        for(int i = 0 ; i < _scaleDatas.count ; i ++){
            ScaleViewCell *cell = [_scaleTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            [[cell getPriceTF] resignFirstResponder];
        }
    }
}


//点击增加计费档
-(void)onAddScaleClicked{
    NSInteger count = _scaleDatas.count+ 1;
    [self addScaleData];
    [self updateTableViewUI];

    if(count == 5){
        _addScaleBtn.hidden = YES;
    }
}


//点击选择档位时间回调
-(void)OnClickScaleBtn:(NSInteger)position{
    _timeLayer.hidden = NO;
    buttonPosition = position;
    [self resignAllTF];
}



//点击删除回调
-(void)OnClickDeleteBtn:(NSInteger)position{
    [self deleteScaleData:position];
    [self updateTableViewUI];
    _addScaleBtn.hidden = NO;
   
}


//增加或删除的UI变化
-(void)updateTableViewUI{
    [_scaleTableView reloadData];
    WS(weakSelf)
    [UIView animateWithDuration:0.3F animations:^{
        weakSelf.scaleTableView.frame = CGRectMake(0, STHeight(15)+ STHeight(51), ScreenWidth, STHeight(51) * weakSelf.scaleDatas.count);
        weakSelf.addScaleBtn.frame = CGRectMake(STWidth(75), STHeight(15) + STHeight(51) * (weakSelf.scaleDatas.count+1) + STHeight(7), STWidth(95), STHeight(21));
    }];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _contactPhoneTF){
        UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
        if(IS_NS_STRING_EMPTY(_contactPhoneTF.text) && chainPosition != 0 && model.level !=4){
            [LCProgressHUD showMessage:@"手机号码不能为空"];
            return;
        }
        if(_contactPhoneTF.text.length != 11){
            [LCProgressHUD showMessage:@"手机号码格式不正确"];
            return;
        }
    }
}


-(void)onPositionBtnBtnClick{
    if(_mViewModel){
        [_mViewModel goLocationPage];
    }
}


//-(void)onPositionLocation:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode{
//    _mViewModel.model.province = regeocode.province;
//    _mViewModel.model.city = regeocode.city;
//    _mViewModel.model.area = regeocode.district;
//    if(!IS_NS_STRING_EMPTY(regeocode.province) && !IS_NS_STRING_EMPTY(regeocode.city) && !IS_NS_STRING_EMPTY(regeocode.district)){
//        [_addressBtn setContent:[NSString stringWithFormat:@"%@-%@-%@",regeocode.province,regeocode.city,regeocode.district]];
//    }
//}

-(void)onSearchPOIResult:(NSArray *)pois nextPage:(Boolean)nextPage{}

//-(void)updateLocation:(AMapPOI *)poi{
//    _addressDetailTF.text = [NSString stringWithFormat:@"%@%@",poi.address,poi.name];
//    _mViewModel.model.province = poi.province;
//    _mViewModel.model.city = poi.city;
//    _mViewModel.model.area = poi.district;
//    if(!IS_NS_STRING_EMPTY(poi.province) && !IS_NS_STRING_EMPTY(poi.city) && !IS_NS_STRING_EMPTY(poi.district)){
//        [_addressBtn setContent:[NSString stringWithFormat:@"%@-%@-%@",poi.province,poi.city,poi.district]];
//    }
//    [self changeAddBtnStatu];
//}


-(void)onChangeProfitView:(Boolean)isRelative{
    _mViewModel.model.isRelative = isRelative;
    [self changeAddBtnStatu];
    CGSize addressSize = [_addressLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    CGSize bottomSize = [_bottomLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    CGFloat height = 0;
    WS(weakSelf)
    if(isRelative){
        height = STHeight(92);
    }
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(510) +STHeight(138) + 8 * STHeight(51) + STHeight(200) + height)];

    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.bottomLabel.frame = CGRectMake(STWidth(15), STHeight(650) + height, bottomSize.width, STHeight(50));
        weakSelf.bottomView.frame = CGRectMake(0, STHeight(700) + height, ScreenWidth, 5 * STHeight(51) + STHeight(15));
        weakSelf.addressLabel.frame = CGRectMake(STWidth(15), STHeight(715) + 5 * STHeight(51) + height, addressSize.width, STHeight(50));
        weakSelf.addressView.frame = CGRectMake(0, STHeight(765) + 5 * STHeight(51) + height, ScreenWidth, STHeight(100));
    }];
}


@end
