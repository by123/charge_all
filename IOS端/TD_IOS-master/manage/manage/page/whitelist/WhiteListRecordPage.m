//
//  WhiteListRecordPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListRecordPage.h"
#import "WhiteListRecordView.h"
#import "WhiteListScopePage.h"
#import "WhiteListEditPage.h"
#import "STObserverManager.h"


@interface WhiteListRecordPage()<WhiteListRecordViewDelegate,STObserverProtocol>

@property(strong, nonatomic)WhiteListRecordView *whiteListRecordView;
@property(strong, nonatomic)WhiteListRecordViewModel *viewModel;
@property(strong, nonatomic)WhiteListPage *lastPage;

@end

@implementation WhiteListRecordPage

+(void)show:(BaseViewController *)controller{
    WhiteListRecordPage *page = [[WhiteListRecordPage alloc]init];
    page.lastPage = (WhiteListPage *)controller;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_WHITELIST_HISTORY needback:YES];
    [self initView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_WHITELIST_LIST delegate:self];
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_UPDATE_WHITELIST_LIST];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[WhiteListRecordViewModel alloc]init];
    _viewModel.delegate = self;
    
    _whiteListRecordView =[[WhiteListRecordView alloc]initWithViewModel:_viewModel];
    _whiteListRecordView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_whiteListRecordView];
    
    [_viewModel requestRecordList:YES];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_WHITELIST_RECORD]){
        [_whiteListRecordView onRequestSuccess:respondModel data:data];
    }else if([respondModel.requestUrl containsString:URL_WHITELIST_CHANGE_STATU]){
        WTRecordModel *model = data;
        [_viewModel.recordDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WTRecordModel *temp = obj;
            if([temp.orderWhiteListId isEqualToString:model.orderWhiteListId]){
                temp.whiteListState = model.whiteListState;
                *stop = YES;
            }
        }];
        [_whiteListRecordView updateView];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onRequestNoData{
    [_whiteListRecordView onRequestNoData];
}


-(void)onGoWhiteListPage{
    [self backLastPage];
}


-(void)onDoChangeState:(WTRecordModel *)model{
    WS(weakSelf)
    if(model.whiteListState == 1){
        [STAlertUtil showAlertController:MSG_WHITELIST_CLOSE content:MSG_WHITELIST_CLOSE_CONFIRM controller:self confirm:^{
            [weakSelf.viewModel changeWhiteListStatu:NO wtId:model.orderWhiteListId];
        }];
    }else{
        [STAlertUtil showAlertController:MSG_WHITELIST_OPEN content:MSG_WHITELIST_OPEN_CONFIRM controller:self confirm:^{
            [weakSelf.viewModel changeWhiteListStatu:YES wtId:model.orderWhiteListId];
        }];
    }
}

//-(void)onDoChangeScope:(NSString *)mchId model:(WTRecordModel *)model{
//    [WhiteListScopePage show:self whiteListId:model.orderWhiteListId];
//}

-(void)onDoEditScope:(NSString *)mchId model:(WTRecordModel *)model{
    [WhiteListEditPage show:self model:model];
}

-(void)onDoCopy:(WTRecordModel *)model{
    WS(weakSelf)
    [STAlertUtil showAlertController:MSG_WHITELIST_COPY content:MSG_WHITELIST_COPY_CONFIRM controller:self confirm:^{
        weakSelf.lastPage.orderWhiteListId = model.orderWhiteListId;
        weakSelf.lastPage.fromCopy = YES;
        weakSelf.lastPage.selectDatas = nil;
        weakSelf.lastPage.userName = model.userName;
        [weakSelf backLastPage];
    }];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    [_viewModel requestRecordList:YES];
}


@end

