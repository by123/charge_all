//
//  ChainPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ChainPage.h"
#import "ChainView.h"
#import "ResultPage.h"
#import "STObserverManager.h"
#import "LocationPage.h"
#import "LocationModel.h"

@interface ChainPage()<ChainViewDelegate,STObserverProtocol>

@property(strong, nonatomic)ChainView *chainView;
@property(strong, nonatomic)ChainViewModel *viewModel;

@end

@implementation ChainPage

+(void)show:(BaseViewController *)controller{
    ChainPage *page = [[ChainPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MENU_ADD_CHAIN needback:YES];
    [self initView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_POSITION delegate:self];
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager]  removeSTObsever:NOTIFY_UPDATE_POSITION];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[ChainViewModel alloc]init];
    _viewModel.delegate = self;
    
    _chainView =[[ChainView alloc]initWithViewModel:_viewModel];
    _chainView.backgroundColor = c04;
    _chainView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_chainView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl isEqualToString:URL_ADD_CHAIN]){
        NSString *userName = [data objectForKey:@"SuperUser"];
        NSString *psw = [data objectForKey:@"password"];
        [ResultPage show:self username:userName psw:psw type:3];
    }
}

-(void)onRequestFail:(NSString *)msg{
    
}

-(void)onGoLocationPage{
//    [LocationPage show:self];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
//    AMapPOI *poi = msg;
//    [_chainView updateLocation:poi];
}


@end

