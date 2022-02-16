//
//  WhiteListChargeTimePage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListChargeTimePage.h"
#import "WhiteListChargeTimeView.h"
#import "STObserverManager.h"

@interface WhiteListChargeTimePage()<WhiteListChargeTimeViewDelegate>

@property(strong, nonatomic)WhiteListChargeTimeView *whiteListChargeTimeView;
@property(strong, nonatomic)WhiteListChargeTimeViewModel *viewModel;
@property(copy, nonatomic)NSString *scale;
@property(assign, nonatomic)WhiteListType type;

@end

@implementation WhiteListChargeTimePage

+(void)show:(BaseViewController *)controller scale:(NSString *)scale type:(WhiteListType)type{
    WhiteListChargeTimePage *page = [[WhiteListChargeTimePage alloc]init];
    page.scale = scale;
    page.type = type;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:@"充电时长" needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[WhiteListChargeTimeViewModel alloc]init];
    _viewModel.delegate = self;
    _viewModel.scale = _scale;
    _viewModel.type = _type;
    
    if(!IS_NS_COLLECTION_EMPTY(_viewModel.datas) && !IS_NS_STRING_EMPTY(_scale)){
        for(WTChargeTimeModel *model in _viewModel.datas){
            if(model.scale == [_scale intValue]){
                model.isSelect = YES;
            }else{
                model.isSelect = NO;
            }
        }
    }
    
    _whiteListChargeTimeView =[[WhiteListChargeTimeView alloc]initWithViewModel:_viewModel];
    _whiteListChargeTimeView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_whiteListChargeTimeView];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    
}

-(void)onRequestFail:(NSString *)msg{
    
}


-(void)onGoBack{
    [self backLastPage];
}


@end

