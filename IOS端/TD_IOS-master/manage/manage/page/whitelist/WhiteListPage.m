//
//  WhiteListPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListPage.h"
#import "WhiteListView.h"
#import "WhiteListRecordPage.h"
#import "WhiteListScopePage.h"
#import "WhiteListChargeTimePage.h"
#import "STObserverManager.h"

@interface WhiteListPage()<WhiteListViewDelegate,STObserverProtocol>

@property(strong, nonatomic)WhiteListView *whiteListView;
@property(strong, nonatomic)WhiteListViewModel *viewModel;

@end

@implementation WhiteListPage

+(void)show:(BaseViewController *)controller{
    WhiteListPage *page = [[WhiteListPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(weakSelf)
    [self showSTNavigationBar:MENU_WHITELIST needback:YES rightBtn:MSG_WHITELIST_HISTORY rightColor:c11 block:^{
        [WhiteListRecordPage show:weakSelf];
    }];
    [self initView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_WHITELIST_TIME delegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
    if(_whiteListView){
        if(_fromCopy){
            _viewModel.orderWhiteListId = _orderWhiteListId;
            [_whiteListView updateView:_userName];
        }else{
            _viewModel.selectDatas = _selectDatas;
            [_whiteListView updateView:nil];
        }
    }
}

-(void)initView{
    _viewModel = [[WhiteListViewModel alloc]init];
    _viewModel.selectDatas = _selectDatas;
    _viewModel.delegate = self;
    
    _whiteListView =[[WhiteListView alloc]initWithViewModel:_viewModel];
    _whiteListView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_whiteListView];
    
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_UPDATE_WHITELIST_TIME];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{

}

-(void)onRequestFail:(NSString *)msg{
    
}


-(void)onGoWhiteListScopePage:(NSString *)orderWhiteListId{
//    if(IS_NS_STRING_EMPTY(orderWhiteListId)){
        [WhiteListScopePage show:self];
//    }else{
//        [WhiteListScopePage show:self whiteListId:orderWhiteListId];
//    }
}

-(void)onGoWhiteListChargeTimePage:(NSString *)scale{
    [WhiteListChargeTimePage show:self scale:scale type:WhiteListType_Create];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    if(!IS_NS_STRING_EMPTY(msg)){
        NSArray *datas = [msg componentsSeparatedByString:@"|"];
        [_whiteListView updateTime:datas[0] scale:datas[1]];
    }
    
}

@end

