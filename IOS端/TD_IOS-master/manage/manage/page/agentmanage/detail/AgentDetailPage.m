//
//  AgentDetailPage.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AgentDetailPage.h"
#import "AgentDetailView.h"
#import "TitleContentModel.h"
#import "AccountModel.h"
#import "STTimeUtil.h"
#import "MerchantDetailView.h"
#import "PayRuleModel.h"
#import "AgentEditPage.h"
#import "MerchantEditPage.h"
#import "STObserverManager.h"
#import "AccountManager.h"
#import "STAlertUtil.h"
#import "MapManage.h"
#import "STNetUtil.h"

@interface AgentDetailPage()<AgentDetailViewDelegate,STObserverProtocol>

@property(strong, nonatomic)AgentDetailView *agentDetailView;
@property(strong, nonatomic)MerchantDetailView *merchantDetailView;
@property(strong, nonatomic)AgentDetailViewModel *viewModel;
@property(copy, nonatomic)NSString *mchId;
@property(assign, nonatomic)int mchType;
@property(assign, nonatomic)Boolean isWhiteList;

@end

@implementation AgentDetailPage

+(void)show:(BaseViewController *)controller model:(MerchantModel *)model{
    AgentDetailPage *page = [[AgentDetailPage alloc]init];
    page.mchId = model.mchId;
    page.mchType = model.mchType;
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_mchType == 0){
        [self showSTNavigationBar:MSG_TITLE_AGENT_DETAIL needback:YES];
    }else{
        [self showSTNavigationBar:MSG_TITLE_MERCHANT_DETAIL needback:YES];
    }
    [self initView];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_UPDATE_AGENT_MERCHANT_DETAIL delegate:self];

}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_UPDATE_AGENT_MERCHANT_DETAIL];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}

-(void)initView{
    _viewModel = [[AgentDetailViewModel alloc]init];
    _viewModel.delegate = self;
    
    if(_mchType == 0){
        _agentDetailView =[[AgentDetailView alloc]initWithViewModel:_viewModel];
        _agentDetailView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
        _agentDetailView.backgroundColor = cbg;
        [self.view addSubview:_agentDetailView];
    }else{
        _merchantDetailView = [[MerchantDetailView alloc]initWithViewModel:_viewModel];
        _merchantDetailView.frame = CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight);
        _merchantDetailView.backgroundColor = cbg;
        [self.view addSubview:_merchantDetailView];
    }

    
    WS(weakSelf)
    [STNetUtil getConfig:CONFIG_RELATIVE_PERCENT_WHITELIST success:^(NSString *result) {
        NSMutableArray *datas= [STConvertUtil jsonToDic:result];
        if(!IS_NS_COLLECTION_EMPTY(datas)){
            UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
            weakSelf.isWhiteList = NO;
            for(NSString *mchId in datas){
                if([model.mchId isEqualToString:mchId]){
                    weakSelf.isWhiteList = YES;
                    break;
                }
            }
            [weakSelf.viewModel reqeustAgentDetail:weakSelf.mchId];
        }
    }];
}

-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    AgentDetailModel *model = _viewModel.model;
    
    [_viewModel.infoDatas removeAllObjects];
    [_viewModel.ruleDatas removeAllObjects];
    [_viewModel.deviceDatas removeAllObjects];

    if(_mchType == 0){
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_TYPE content:[UserModel getMechantName:model.mchType level:model.level]]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_ACCOUNT content:model.mchId]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_NAME content:model.mchName]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_USER_NAME content:model.contactUser]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_PHONE content:model.contactPhone]];
        if(!IS_NS_STRING_EMPTY(model.industry)){
            [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_INDUSTRY content:model.industry]];
        }
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_SETTEMENT content:[NSString stringWithFormat:@"T+%d",model.settementPeriod]]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_PERCENT content:[NSString stringWithFormat:@"%.2f%%",model.totalPercent]]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_SALEMAN content:model.salesName]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_CREATTIME content:[STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.createTime] format:MSG_TIME_FORMAT]]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_FREEZE content:DoubleStr(model.blockedAmountYuan)]];
//        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_AGENT_ADDRESS content:[NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.area,model.detailAddr]]];
        
        if(!IS_NS_STRING_EMPTY(model.provinceAgentMchName)){
            [_viewModel.agentDatas addObject:[TitleContentModel buildModel:MSG_AGENT_PROVINCE content:model. provinceAgentMchName]];
        }
        if(!IS_NS_STRING_EMPTY(model.cityAgentMchName)){
            [_viewModel.agentDatas addObject:[TitleContentModel buildModel:MSG_AGENT_CITY content:model.cityAgentMchName]];
        }
        if(!IS_NS_STRING_EMPTY(model.countryAgentMchName)){
            [_viewModel.agentDatas addObject:[TitleContentModel buildModel:MSG_AGENT_AREA content:model.countryAgentMchName]];
        }

        [_viewModel.deviceDatas addObject:[TitleContentModel buildModel:MSG_AGENT_DEVICE_TOTAL content:IntStr(model.deviceTotal)]];
        [_viewModel.deviceDatas addObject:[TitleContentModel buildModel:MSG_AGENT_DEVICE_ACTIVE content:IntStr(model.deviceActiveTotal)]];
        
        [_agentDetailView updateView];
    }else{
        
        if(model.level == 1){
            [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_ACCOUNT_TYPE content:MSG_SUB_CHAIN]];
        }else{
            [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_ACCOUNT_TYPE content:MSG_MERCHANT]];
        }
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_NAME content:model.mchName]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_INDUSTRY content:model.industry]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_USER_NAME content:model.contactUser]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_PHONE content:model.contactPhone]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_SETTEMENT content:[NSString stringWithFormat:@"T+%d",model.settementPeriod]]];
       
     
        if((model.profitPool == 0 && model.percentInPool == 0) || !_isWhiteList){
            [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_PERCENT content:[NSString stringWithFormat:@"%.2f%%",model.totalPercent]]];
        }else{
            
            [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_PERCENT_RELATIVE content:[NSString stringWithFormat:@"%.2f%%",model.percentInPool]]];
            
            [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_PERCENT_REAL content:[NSString stringWithFormat:@"%.2f%%",model.totalPercent]]];
        }
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_SALEMAN content:model.salesName]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_CREATETIME content:[STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.createTime] format:MSG_TIME_FORMAT]]];
        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_FREEZE content:DoubleStr(model.blockedAmountYuan)]];
//        [_viewModel.infoDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_ADDRESS content:[NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.area,model.detailAddr]]];

        if(!IS_NS_STRING_EMPTY(model.provinceAgentMchName)){
            [_viewModel.agentDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_PROVINCE content:model. provinceAgentMchName]];
        }
        if(!IS_NS_STRING_EMPTY(model.cityAgentMchName)){
            [_viewModel.agentDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_CITY content:model.cityAgentMchName]];
        }
        if(!IS_NS_STRING_EMPTY(model.countryAgentMchName)){
            [_viewModel.agentDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_AREA content:model.countryAgentMchName]];
        }
        if(!IS_NS_STRING_EMPTY(model.listAgentMchName)){
            [_viewModel.agentDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_CHIAN content:model.listAgentMchName]];
        }

        if(!IS_NS_COLLECTION_EMPTY(model.mchPriceRule)){
            NSDictionary *dic = model.mchPriceRule[0];
            int serviceType = [[dic objectForKey:@"serviceType"] intValue];
            if(serviceType == 1){
                for(int i = 0 ; i < model.service.count ; i++){
                    PayRuleModel *ruleModel = [model.service objectAtIndex:i];
                    [_viewModel.ruleDatas addObject:[TitleContentModel buildModel:[self formatScaleTitle:i] content:[NSString stringWithFormat:MSG_TIME_PRICE,(int)(ruleModel.time/60),((double)ruleModel.price/100)]]];
                }
            }else{
                NSString  *service = [dic objectForKey:@"service"];
                NSDictionary *serviceDic = service.mj_JSONObject;
                [_viewModel.ruleDatas addObject:[TitleContentModel buildModel:@"预付金额" content:[NSString stringWithFormat:@"%.2f元",[[serviceDic objectForKey:@"prepaid"] doubleValue] / 100]]];
                [_viewModel.ruleDatas addObject:[TitleContentModel buildModel:@"封顶金额" content:[NSString stringWithFormat:@"%.2f元",[[serviceDic objectForKey:@"maxMoney"] doubleValue] / 100]]];
                
                int minMinutes = [[serviceDic objectForKey:@"minMinutes"] intValue] / 60;
                double minMoney = [[serviceDic objectForKey:@"minMoney"] doubleValue] / 100;
                [_viewModel.ruleDatas addObject:[TitleContentModel buildModel:[NSString stringWithFormat:@"首次%d小时",minMinutes] content:[NSString stringWithFormat:@"%.2f元",minMoney]]];
                
                int stepMinutes = [[serviceDic objectForKey:@"stepMinutes"] intValue] / 60;
                double price = [[serviceDic objectForKey:@"price"] doubleValue] / 100;
                [_viewModel.ruleDatas addObject:[TitleContentModel buildModel:[NSString stringWithFormat:@"超过每%d小时",stepMinutes] content:[NSString stringWithFormat:@"%.2f元",price]]];
                
            }
        }
        
        [_viewModel.deviceDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_DEVICE_TOTAL content:IntStr(model.deviceTotal)]];
        [_viewModel.deviceDatas addObject:[TitleContentModel buildModel:MSG_MERCHANT_DEVICE_ACTIVE content:IntStr(model.deviceActiveTotal)]];
        
        [_merchantDetailView updateView];
    }

}

-(void)onRequestFail:(NSString *)msg{
    
}

//数字转档位(例如：1 转成 第一档)
-(NSString *)formatScaleTitle:(NSInteger)position{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    formatter.locale = locale;
    NSString *result = [NSString stringWithFormat:MSG_SCALE_NUM,[formatter stringFromNumber:[NSNumber numberWithInteger: position + 1]]];
    return result;
}


-(void)onGoMerchantEditPage:(AgentDetailModel *)model{
    [MerchantEditPage show:self model:model];
}

-(void)onGoAgentEditPage:(AgentDetailModel *)model{
    [AgentEditPage show:self model:model];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    if([key isEqualToString:NOTIFY_UPDATE_AGENT_MERCHANT_DETAIL] ){
        [_viewModel reqeustAgentDetail:_mchId];
    }
}

-(void)onGoNavigation:(double)myLatitude myLongitude:(double)myLongitude latitude:(double)latitude longitude:(double)longitude name:(NSString *)name{
//    STSheetModel *appleModel = [[STSheetModel alloc]init];
//    appleModel.title = @"苹果地图";
//    appleModel.click = ^{
//        [[MapManage sharedMapManage] openAppleMap:latitude longitude:longitude name:name];
//    };
//
//    STSheetModel *maModel = [[STSheetModel alloc]init];
//    maModel.title = @"高德地图";
//    maModel.click = ^{
//        [[MapManage sharedMapManage] openMaMap:latitude longitude:longitude name:name];
//    };
//
//    STSheetModel *baiduModel = [[STSheetModel alloc]init];
//    baiduModel.title = @"百度地图";
//    baiduModel.click = ^{
//        [[MapManage sharedMapManage] openBaiduMap:latitude longitude:longitude name:name];
//    };
//
//    STSheetModel *tencentModel = [[STSheetModel alloc]init];
//    tencentModel.title = @"腾讯地图";
//    tencentModel.click = ^{
//        [[MapManage sharedMapManage] openTencent:myLatitude myLongitude:myLongitude latitude:latitude longitude:longitude name:name];
//    };
//
//    NSMutableArray *models = [[NSMutableArray alloc]init];
//    [models addObject:appleModel];
//    [models addObject:maModel];
//    [models addObject:baiduModel];
//    [models addObject:tencentModel];
//
//    [STAlertUtil showSheetController:@"导航" content:nil controller:self sheetModels:models];
}


@end

