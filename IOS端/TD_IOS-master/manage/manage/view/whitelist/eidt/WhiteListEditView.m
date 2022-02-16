//
//  WhiteListEditView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListEditView.h"
#import "STBlankInView.h"
#import "STSelectInView.h"

@interface WhiteListEditView()<STSelectInViewDelegate>

@property(strong, nonatomic)WhiteListEditViewModel *mViewModel;
@property(strong, nonatomic)STBlankInView *nameView;
@property(strong, nonatomic)STSelectInView *scopeView;
@property(strong, nonatomic)STSelectInView *timeView;


@end

@implementation WhiteListEditView

-(instancetype)initWithViewModel:(WhiteListEditViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _nameView = [[STBlankInView alloc]initWithTitle:@"客户姓名" placeHolder:@"请输入客户姓名"];
    _nameView.frame = CGRectMake(0, 0, ScreenWidth, STHeight(50));
    [self addSubview:_nameView];
    
    _scopeView = [[STSelectInView alloc]initWithTitle:@"使用范围" placeHolder:@"请选择可免费充电的商户" frame:CGRectMake(0, STHeight(50), ScreenWidth, STHeight(50))];
    _scopeView.delegate = self;
    _scopeView.frame = CGRectMake(0, STHeight(50), ScreenWidth, STHeight(50));
    [self addSubview:_scopeView];
    
    _timeView = [[STSelectInView alloc]initWithTitle:@"充电时长" placeHolder:@"请选择可免费充电的时长" frame:CGRectMake(0, STHeight(100), ScreenWidth, STHeight(50))];
    _timeView.delegate = self;
    _timeView.frame = CGRectMake(0, STHeight(100), ScreenWidth, STHeight(50));
    [self addSubview:_timeView];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_CONFIRM textColor:cwhite backgroundColor:c24 corner:2 borderWidth:0 borderColor:nil];
    confirmBtn.frame = CGRectMake(0, ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [confirmBtn addTarget:self action:@selector(onConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    for(int i = 1 ; i <= 3 ; i ++){
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(50) * i, ScreenWidth - STWidth(30), LineHeight)];
        lineView.backgroundColor = cline;
        [self addSubview:lineView];
    }
    
    [_nameView setContent:_mViewModel.recordModel.userName];
    [_scopeView setContent:[NSString stringWithFormat:@"%@的使用范围",_mViewModel.recordModel.userName]];
    [_timeView setContent:[NSString stringWithFormat:@"%d小时",_mViewModel.recordModel.duration/60]];
}

-(void)onSelectClicked:(id)selectInView{
    if(selectInView == _timeView){
        [_mViewModel goWhiteListChargeTimePage:IntStr(_mViewModel.recordModel.timeLevel)];
    }else if(selectInView == _scopeView){
        [_mViewModel goWhiteListScopePage:_mViewModel.recordModel.orderWhiteListId];
    }
}

-(void)onConfirmBtnClick{
    if(IS_NS_STRING_EMPTY([_nameView getContent])){
        [LCProgressHUD showMessage:@"请输入客户姓名"];
        return;
    }
//    if(IS_NS_COLLECTION_EMPTY(_mViewModel.selectDatas)){
//        [LCProgressHUD showMessage:@"请选择使用范围"];
//        return;
//    }
    _mViewModel.recordModel.userName = [_nameView getContent];
    [_mViewModel editWhiteListScope];
}

-(void)updateView{
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.selectDatas)){
        NSString *scopeStr = MSG_EMPTY;
        for (WTScopeModel *model in _mViewModel.selectDatas) {
            if(model.selected == WHITELIST_SELECT_ALL){
                Boolean add = YES;
                //如果为全选中，则只选择父级
                for(WTScopeModel *temp in _mViewModel.selectDatas){
                    if([model.parentAgencyId isEqualToString:temp.mchId] && temp.selected == WHITELIST_SELECT_ALL){
                        add = NO;
                        break;
                    }
                }
                if(add){
                    scopeStr = [scopeStr stringByAppendingString:model.mchName];
                    scopeStr = [scopeStr stringByAppendingString:@","];
                }
            }
        }
        scopeStr = [scopeStr substringWithRange:NSMakeRange(0, scopeStr.length - 1)];
        [_scopeView setContent:scopeStr];
    }
}

-(void)updateTime:(NSString *)time scale:(NSString *)scale{
    _mViewModel.recordModel.timeLevel = [scale intValue];
    _mViewModel.recordModel.duration = [time intValue];
    [_timeView setContent:[NSString stringWithFormat:@"%d小时",[time intValue]/60]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nameView resign];
}

@end

