//
//  WhiteListEditPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListEditPage.h"
#import "WhiteListEditView.h"
#import "WhiteListChargeTimePage.h"
#import "STObserverManager.h"
#import "WhiteListScopePage.h"

@interface WhiteListEditPage()<WhiteListEditViewDelegate,STObserverProtocol>

@property(strong, nonatomic)WhiteListEditView *whiteListEditView;
@property(strong, nonatomic)WhiteListEditViewModel *viewModel;
@property(strong, nonatomic)WTRecordModel *recordModel;

@end

@implementation WhiteListEditPage

+(void)show:(BaseViewController *)controller model:(WTRecordModel *)model{
    WhiteListEditPage *page = [[WhiteListEditPage alloc]init];
    page.recordModel = model;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:@"编辑白名单" needback:YES];
    [self initView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_WHITELIST_EDIT_TIME delegate:self];
}


-(void)initView{
    _viewModel = [[WhiteListEditViewModel alloc]init];
    _viewModel.delegate = self;
    _viewModel.recordModel = _recordModel;
    
    _whiteListEditView =[[WhiteListEditView alloc]initWithViewModel:_viewModel];
    _whiteListEditView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_whiteListEditView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
    if(_whiteListEditView){
        _viewModel.selectDatas = _selectDatas;
        [_whiteListEditView updateView];
    }
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [LCProgressHUD showMessage:MSG_UPDATE_SUCCESS];
    [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_WHITELIST_LIST msg:nil];
    [self backLastPage];
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onGoWhiteListChargeTimePage:(NSString *)timeLevel{
    [WhiteListChargeTimePage show:self scale:timeLevel type:WhiteListType_Edit];
}

-(void)onGoWhiteListScopePage:(NSString *)orderWhiteListId{
    [WhiteListScopePage show:self whiteListId:orderWhiteListId];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    if(!IS_NS_STRING_EMPTY(msg)){
        NSArray *datas = [msg componentsSeparatedByString:@"|"];
        [_whiteListEditView updateTime:datas[0] scale:datas[1]];
    }
}

@end

