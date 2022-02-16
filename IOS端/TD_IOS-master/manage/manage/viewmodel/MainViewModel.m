//
//  MainViewModel.m
//  bus
//
//  Created by by.huang on 2018/9/14.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "MainViewModel.h"
#import "STNetUtil.h"
#import "MainModel.h"
#import "AccountModel.h"
#import "AccountManager.h"

@implementation MainViewModel

//首页数据
-(void)getHomeData{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_HOME parameters:nil success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            MainModel *model = [MainModel mj_objectWithKeyValues:respondModel.data];
            [weakSelf.delegate onRequestSuccess:respondModel data:model];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


//扫码绑定商户
-(void)scanMerchant{
    if(_delegate){
        [_delegate onGoScanPage];
    }
}

//激活设备
-(void)goActiveDevice{
    if(_delegate){
        [_delegate onGoActiveDevice];
    }
}

//添加商户
-(void)goAddMerchat{
    if(_delegate){
        [_delegate onGoAddMerchat];
    }
}

//添加代理
-(void)goAddAgent{
    if(_delegate){
        [_delegate onGoAddAgent];
    }
}

//添加业务员
-(void)goAddSaleman{
    if(_delegate){
        [_delegate onGoAddSaleman];
    }
}
    
//添加连锁门店
-(void)goAddChain{
    if(_delegate){
        [_delegate onGoAddChain];
    }
}

//账户详情
-(void)goAccountDetail{
    if(_delegate){
        [_delegate onGoAccountDetail];
    }
}

//BK信息
-(void)goBankDetail{
    if(_delegate){
        [_delegate onGogoBankDetail];
    }
}


//设置
-(void)goSettingPage{
    if(_delegate){
        [_delegate onGoAppSettingPage];
    }
}

//白名单
-(void)goWhiteListPage{
    if(_delegate){
        [_delegate onGoWhiteListPage];
    }
}


//
- (void)goReset{
    if(_delegate){
        [_delegate onGoResetPage];
    }
}

//
-(void)goTaxi{
    if(_delegate){
        [_delegate onGoTaxi];
    }
}


//
-(void)goArchievePage:(NSInteger)tab{
    if(_delegate){
       [_delegate onGoArchievePage:tab];
    }
}


//
-(void)goMsgPage{
    if(_delegate){
        [_delegate onGoMsgPage];
    }
}

//
-(void)goOrderSearchPage{
    if(_delegate){
        [_delegate onGoOrderSearchPage];
    }
}

//
-(void)goOrderDetailPage:(NSString *)orderId{
    if(_delegate){
        [_delegate onGoOrderDetailPage:orderId];
    }
}

//
-(void)goRefundPage:(OrderModel *)model{
    if(_delegate){
        [_delegate onGoRefundPage:model];
    }
}

//
-(void)goHelpPage{
    if(_delegate){
        [_delegate onGoHelpPage];
    }
}

//
-(void)goWithdrawPage:(CapitalModel *)model{
    if(_delegate){
        [_delegate onGoWithdrawPage:model];
    }
}

//
- (void)goWithdrawSuccessPage:(NSString *)withdrawId{
    if(_delegate){
        [_delegate onGoWithdrawSuccessPage:withdrawId];
    }
}

//
-(void)goWithdrawFailPage:(NSString *)withdrawId{
    if(_delegate){
        [_delegate onGoWithdrawFailPage:withdrawId];
    }
}

-(void)goAgentManagePage{
    if(_delegate){
        [_delegate onGoAgentManagePage];
    }
}

-(void)goUnBindingPage{
    if(_delegate){
        [_delegate onGoUnBindingPage];
    }
}

-(void)goCapitalDetailPage:(NSString *)date{
    if(_delegate){
        [_delegate onGoCapitalDetailPage:date];
    }
}

@end
