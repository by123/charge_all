//
//  WithdrawPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawPage.h"
#import "WithdrawView.h"
#import "BankHomePage.h"
#import "STObserverManager.h"
#import "WithdrawSuccessPage.h"
#import "WithdrawFailPage.h"
#import "BankSelectPage.h"
#import "BindWeChatPage.h"

@interface WithdrawPage()<WithdrawViewDelegate,STObserverProtocol>

@property(strong, nonatomic)WithdrawView *withdrawView;
@property(strong, nonatomic)WithdrawViewModel *viewModel;
@property(strong, nonatomic)UIView *noDataView;
@property(strong, nonatomic)UIImageView *noBankImageView;
@property(strong, nonatomic)UILabel *noBankLabel;
@property(strong, nonatomic)CapitalModel *capitalModel;

@end

@implementation WithdrawPage

+(void)show:(BaseViewController *)controller model:(CapitalModel *)model{
    WithdrawPage *page = [[WithdrawPage alloc]init];
    page.capitalModel = model;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TX needback:YES];
    [self initView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_BANK_WITHDRAW delegate:self];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_BANK delegate:self];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_WECHAT_BIND delegate:self];

}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_UPDATE_BANK_WITHDRAW];
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_UPDATE_BANK];
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_WECHAT_BIND];


}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[WithdrawViewModel alloc]init];
    _viewModel.capitalModel = _capitalModel;
    _viewModel.delegate = self;
    
    _withdrawView =[[WithdrawView alloc]initWithViewModel:_viewModel];
    _withdrawView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_withdrawView];
    
    _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight)];
    _noDataView.backgroundColor = cwhite;
    _noDataView.hidden = YES;
    [self.view addSubview:_noDataView];
    
    UIButton *addBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_ADD_BK textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    [addBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    addBtn.frame = CGRectMake((ScreenWidth - STWidth(220))/2, STHeight(295), STWidth(220), STHeight(50));
    [addBtn addTarget:self action:@selector(onAddClick) forControlEvents:UIControlEventTouchUpInside];
    [_noDataView addSubview:addBtn];
    
    _noBankImageView = [[UIImageView alloc]init];
    _noBankImageView.image = [UIImage imageNamed:IMAGE_NO_BANK];
    _noBankImageView.contentMode = UIViewContentModeScaleAspectFill;
    _noBankImageView.frame = CGRectMake((ScreenWidth-STWidth(100))/2, STHeight(70),STWidth(100) , STWidth(100));
    [_noDataView addSubview:_noBankImageView];
    
    _noBankLabel = [[UILabel alloc]initWithFont:STFont(16) text:MSG_NO_BK_DETAIL textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noBankLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    [_noDataView addSubview:_noBankLabel];
    
    [_viewModel reqeustBankInfo];

}


-(void)onAddClick{
    [BankHomePage show:self banks:_viewModel.banks from:BIND_FROM_WITHDRAW];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    if([key isEqualToString:NOTIFY_UPDATE_BANK_WITHDRAW]){
        [_viewModel reqeustBankInfo];
    }else if([key isEqualToString:NOTIFY_UPDATE_BANK]){
        _viewModel.banks = msg;
        WS(weakSelf)
        [_viewModel.banks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BankModel *model = obj;
            if(model.isSelect){
                weakSelf.viewModel.defaultModel = model;
            }
        }];
        [_withdrawView updateBankView];
        [self requestRule];
    }else if([key containsString:NOTIFY_WECHAT_BIND]){
        [_viewModel reqeustBankInfo];
    }
}

-(void)requestRule{
    //如果是微信
    if(_viewModel.defaultModel.isPublic == 2){
        [_withdrawView updateRuleView:YES];
    }else{
        [_withdrawView updateRuleView:NO];
    }
//    [_viewModel requestRule];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_BANKINFO]){
        if(IS_NS_COLLECTION_EMPTY(_viewModel.banks)){
            _withdrawView.hidden = YES;
            _noDataView.hidden = NO;
        }else{
            _withdrawView.hidden = NO;
            _noDataView.hidden = YES;
            [_withdrawView updateBankView];
        }
        [self requestRule];
    }
    else if([respondModel.requestUrl containsString:URL_WITHDRAW_RULE]){
        [_withdrawView updateAuxiliary];
    }
    else if([respondModel.requestUrl containsString:URL_WITHDRAW]){
        NSString *withdrawId = data;
        [WithdrawSuccessPage show:self withdrawId:withdrawId];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onBackLastPage{
    [self backLastPage];
}

-(void)onGoSelectBank:(NSMutableArray *)datas{
    [BankSelectPage show:self datas:datas];
}

-(void)onGoBindWeChat{
    [BindWeChatPage show:self from:BIND_FROM_WITHDRAW];
}
@end

