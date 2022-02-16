//
//  CapitalDetailPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "CapitalDetailPage.h"
#import "CapitalDetailView.h"

@interface CapitalDetailPage()<CapitalDetailViewDelegate>

@property(strong, nonatomic)CapitalDetailView *capitalDetailView;
@property(strong, nonatomic)CapitalDetailViewModel *viewModel;
@property(strong, nonatomic)NSString *date;

@end

@implementation CapitalDetailPage

+(void)show:(BaseViewController *)controller date:(NSString *)date{
    CapitalDetailPage *page = [[CapitalDetailPage alloc]init];
    page.date = date;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_CAPITAL_DETAIL needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[CapitalDetailViewModel alloc]init];
    _viewModel.date = _date;
    _viewModel.delegate = self;
    
    _capitalDetailView =[[CapitalDetailView alloc]initWithViewModel:_viewModel];
    _capitalDetailView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_capitalDetailView];
    
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_DEVICEUSING]){
        CapitalDetailModel *model = _viewModel.detailModel;
        NSArray *contents = @[[NSString stringWithFormat:@"%.2f",model.profitOrderYuan],
                              [NSString stringWithFormat:@"%.2f%%",model.orderPercent],
                              [NSString stringWithFormat:@"%.2f",model.profitRefundYuan],
                              IntStr(model.orderNum),
                              IntStr(model.activeDeviceTotalNum),
                              [NSString stringWithFormat:@"%.2f",model.orderServiceNumYuan]];
        [_capitalDetailView updateContentView:contents noData:NO];
    }else if([respondModel.requestUrl containsString:URL_CHILD_DEVICEUSING]){
        int type = [data intValue];
        if(type == CapitalDetailType_Profit){
            [_capitalDetailView updateProfitView];
        }else if(type == CapitalDetailType_Device){
            [_capitalDetailView updateDeviceView];
        }
    }
//    else if([respondModel.requestUrl containsString:URL_MYDETAIL]){
//        [_capitalDetailView updateSettementPeriod:[data intValue]];
//    }
}

-(void)onRequestFail:(NSString *)msg{
    [_capitalDetailView updateFail];
}

-(void)onRequestNoData:(int)type{
    [_capitalDetailView updateNoData:type];
}


@end

