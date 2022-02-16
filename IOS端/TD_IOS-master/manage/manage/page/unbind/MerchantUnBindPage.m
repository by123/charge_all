//
//  MerchantBindPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MerchantUnBindPage.h"
#import "MerchantUnBindView.h"
#import "MerchantUnBindResultPage.h"
#import "STDialog.h"

@interface MerchantUnBindPage()<MerchantUnBindViewDelegate,STDialogDelegate>

@property(strong, nonatomic)MerchantUnBindView *merchantUnBindView;
@property(strong, nonatomic)MerchantUnBindViewModel *viewModel;
@property(strong, nonatomic)MerchantModel *model;
@property(strong, nonatomic)STDialog *dialog;

@end

@implementation MerchantUnBindPage

+(void)show:(BaseViewController *)controller model:(MerchantModel *)model{
    MerchantUnBindPage *page = [[MerchantUnBindPage alloc]init];
    page.model = model;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_MERCHANT_BIND needback:YES];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[MerchantUnBindViewModel alloc]init];
    _viewModel.mchModel = _model;
    _viewModel.delegate = self;
    
    _merchantUnBindView =[[MerchantUnBindView alloc]initWithViewModel:_viewModel];
    _merchantUnBindView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
    [self.view addSubview:_merchantUnBindView];
    
    [_viewModel queryMerchantDetail];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_MERCHANT_DEVICE_TOTAL]){
        if(_merchantUnBindView){
            [_merchantUnBindView updateView];
            [self createDialog:_viewModel.model.total];
        }
    }else if([respondModel.requestUrl containsString:URL_UNBIND_MERCHANT_DEVICE]){
        [MerchantUnBindResultPage show:self isSuccess:YES count:[[data objectForKey:@"count"] intValue]];
    }

}

-(void)onRequestFail:(NSString *)msg{
    if([msg isEqualToString:@"unbind"]){
        [MerchantUnBindResultPage show:self isSuccess:NO count:_viewModel.model.total];
    }
}

-(void)createDialog:(int)count{
    _dialog = [[STDialog alloc]initWithTitle:@"解绑设备" content:@"确认是否批量解绑，操作后不可恢复" subContent:[NSString stringWithFormat:@"设备数量：%d个",count] size:CGSizeMake(STWidth(260), STHeight(220))];
    [_dialog showConfirmBtn:YES cancelBtn:YES];
    _dialog.delegate = self;
    _dialog.hidden = YES;
    [self.view addSubview:_dialog];
}

-(void)onOpenDialog{
    _dialog.hidden = NO;
}

-(void)onConfirmBtnClicked{
    [_viewModel doUnbindMerchant];
}

-(void)onCancelBtnClicked{
    _dialog.hidden = YES;
}


@end

