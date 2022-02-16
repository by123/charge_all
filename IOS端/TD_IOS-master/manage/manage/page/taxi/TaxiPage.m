//
//  TaxiPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "TaxiPage.h"
#import "TaxiView.h"
#import "GroupCreatePage.h"
#import "ScanPage.h"
#import "GroupDetailPage.h"
#import "STObserverManager.h"

@interface TaxiPage()<TaxiViewDelegate,STObserverProtocol>

@property(strong, nonatomic)TaxiView *taxiView;
@property(strong, nonatomic)TaxiViewModel *viewModel;

@end

@implementation TaxiPage

+(void)show:(BaseViewController *)controller{
    TaxiPage *page = [[TaxiPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MENU_TAXI needback:YES];
    [self initView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_GROUP_LIST delegate:self];

}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_UPDATE_GROUP_LIST];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[TaxiViewModel alloc]init];
    _viewModel.delegate = self;
    
    _taxiView =[[TaxiView alloc]initWithViewModel:_viewModel];
    _taxiView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _taxiView.backgroundColor = cbg;
    [self.view addSubview:_taxiView];
    [_viewModel requestGroupList:YES];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [_taxiView updateView];
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onRequestNoData:(Boolean)empty{
    [_taxiView onRequestNoData:empty];
}

-(void)onCreateGroup{
   [GroupCreatePage show:self];
}

-(void)onGoScanPage:(NSString *)groupId groupName:(NSString *)groupName{
    [ScanPage show:self type:ScanType_BIND_GROUP mchId:groupId mchName:groupName];
}

-(void)onGoGroupDetailPage:(GroupModel *)model{
    [GroupDetailPage show:self model:model];
}


-(void)onReciveResult:(NSString *)key msg:(id)msg{
    if(_viewModel){
        [_viewModel requestGroupList:YES];
    }
}

@end

