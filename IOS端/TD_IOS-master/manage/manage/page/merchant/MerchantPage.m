//
//  MerchantPage.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "MerchantPage.h"
#import "MerchantView.h"
#import "ResultPage.h"
#import "AddMchSuccessPage.h"
#import "LocationPage.h"
#import "STObserverManager.h"
#import "LocationModel.h"

@interface MerchantPage ()<MerchantViewDelegate,STObserverProtocol>

@property(strong, nonatomic)MerchantView *merchatView;

@end

@implementation MerchantPage

+(void)show:(BaseViewController *)controller{
    MerchantPage *page = [[MerchantPage alloc]init];
    [controller pushPage:page];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showSTNavigationBar:MENU_ADD_MERCHANT needback:YES];
    
    MerchantViewModel *viewModel = [[MerchantViewModel alloc]init];
    viewModel.delegate = self;
    
    _merchatView = [[MerchantView alloc]initWithViewModel:viewModel];
    _merchatView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    _merchatView.backgroundColor = c04;
    [self.view addSubview:_merchatView];
    
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_POSITION delegate:self];
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager]  removeSTObsever:NOTIFY_UPDATE_POSITION];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_ADD_MCH]){
        [AddMchSuccessPage show:self mchName:data];
    }else if([respondModel.requestUrl containsString:URL_ADD_CHILD_CHAIN]){
        [AddMchSuccessPage show:self mchName:data];
    }else if([respondModel.requestUrl containsString:URL_DEFALT_PAY_RULE]){
        if(_merchatView){
//            [_merchatView createScaleDatas];
        }
    }else if([respondModel.requestUrl containsString:URL_QUERY_AGENT_AND_MERCHANT]){
        if(_merchatView){
           [_merchatView updateChildChain];
        }
    }

}

-(void)onRequestFail:(NSString *)msg{
}


-(void)onGoLocationPage{
//    [LocationPage show:self];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
//    AMapPOI *poi = msg;
//    [_merchatView updateLocation:poi];
}

@end
