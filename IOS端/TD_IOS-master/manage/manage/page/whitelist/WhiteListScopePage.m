//
//  WhiteListScopePage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListScopePage.h"
#import "WhiteListScopeView.h"
#import "AccountManager.h"
#import "WhiteListPage.h"
#import "WhiteListEditPage.h"



@interface WhiteListScopePage()<WhiteListScopeViewDelegate>

@property(strong, nonatomic)WhiteListScopeView *whiteListScopeView;
@property(strong, nonatomic)WhiteListScopeViewModel *viewModel;
@property(strong, nonatomic)WhiteListPage *lastPage;
@property(strong, nonatomic)WhiteListEditPage *editPage;
@property(assign, nonatomic)int from;
@property(copy, nonatomic)NSString *whiteListId;

@end

@implementation WhiteListScopePage

+(void)show:(BaseViewController *)controller{
    WhiteListScopePage *page = [[WhiteListScopePage alloc]init];
    page.lastPage = (WhiteListPage *)controller;
    page.from = WHITELIST_FROM_CREATE;
    [controller pushPage:page];
}

+(void)show:(BaseViewController *)controller whiteListId:(NSString *)whiteListId{
    WhiteListScopePage *page = [[WhiteListScopePage alloc]init];
    page.editPage = (WhiteListEditPage *)controller;
    page.from = WHITELIST_FROM_EDIT;
    page.whiteListId = whiteListId;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_SCOPE needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[WhiteListScopeViewModel alloc]init];
    _viewModel.delegate = self;
    _viewModel.from = _from;
    _viewModel.orderWhiteListId = _whiteListId;
    
    _whiteListScopeView =[[WhiteListScopeView alloc]initWithViewModel:_viewModel];
    _whiteListScopeView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_whiteListScopeView];
    
    UserModel *model = [[AccountManager sharedAccountManager]getUserModel];
    if(_from == WHITELIST_FROM_CREATE){
        if(IS_NS_COLLECTION_EMPTY(_lastPage.selectDatas)){
            [_viewModel initTopLayerDatas];
            [_whiteListScopeView updateView:-1];
            if(IS_NS_STRING_EMPTY(_lastPage.orderWhiteListId)){
                [_viewModel queryChildDatas:model.mchId selected:WHITELIST_SELECT_NONE position:0];
            }else{
                _viewModel.orderWhiteListId = _lastPage.orderWhiteListId;
                [_viewModel requestScopeList:model.mchId selected:WHITELIST_SELECT_NONE position:0];
            }
        }else{
            _viewModel.scopeDatas = _lastPage.selectDatas;
            [_whiteListScopeView updateView:-1];
        }
    }else{
        [_viewModel initTopLayerDatas];
        [_whiteListScopeView updateView:-1];
        [_viewModel requestScopeList:model.mchId selected:WHITELIST_SELECT_NONE position:0];
    }
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_WHITELIST_QUERY_CHILD]){
        [_whiteListScopeView updateView:[data intValue]];
    }else if([respondModel.requestUrl containsString:URL_WHITELIST_CHANGE_STATU]){
        [self backLastPage];
    }else if([respondModel.requestUrl containsString:URL_WHITELIST_QUERY_SCOPE]){
        [_whiteListScopeView updateView:[data intValue]];
    }

}

-(void)onRequestFail:(NSString *)msg{
    
}


-(void)onSaveSelect:(NSMutableArray *)datas{
    
    if(IS_NS_COLLECTION_EMPTY(datas)){
        [LCProgressHUD showMessage:MSG_SCOPE_SELECT];
        return;
    }else{
        Boolean isSelectOne = NO;
        for(WTScopeModel *model in datas){
            if(model.selected == WHITELIST_SELECT_ALL){
                isSelectOne = YES;
                break;
            }
        }
        if(isSelectOne){
            _lastPage.selectDatas = datas;
            _lastPage.fromCopy = NO;
            _lastPage.userName = nil;
            _lastPage.orderWhiteListId = nil;
            [self backLastPage];
        }else{
            [LCProgressHUD showMessage:MSG_SCOPE_SELECT];
        }
    }
}

-(void)onGoEditWhiteListPage:(NSMutableArray *)datas{
    if(IS_NS_COLLECTION_EMPTY(datas)){
        [LCProgressHUD showMessage:MSG_SCOPE_SELECT];
        return;
    }else{
        Boolean isSelectOne = NO;
        for(WTScopeModel *model in datas){
            if(model.selected == WHITELIST_SELECT_ALL){
                isSelectOne = YES;
                break;
            }
        }
        if(isSelectOne){
            _editPage.selectDatas = datas;
            [self backLastPage];
        }else{
            [LCProgressHUD showMessage:MSG_SCOPE_SELECT];
        }
    }
}

@end

