//
//  OrderViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderViewModel.h"
#import "STTimeUtil.h"
#import "STNetUtil.h"
#import "AccountManager.h"
#import "MerchantModel.h"

@interface OrderViewModel()

@property(assign, nonatomic)int pageID;

@end

@implementation OrderViewModel

-(instancetype)init{
    if(self == [super init]){
        _pageID = 1;
        _startDate = [STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy-MM-dd"];
        _endDate = [STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy-MM-dd"];
        _startDateStr = [STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy年MM月dd日"];
        _endDateStr = [STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy年MM月dd日"];
        _model = [[MerchantModel alloc]init];
    }
    return self;
}


-(void)goOrderDetailPage:(NSString *)orderId{
    if(_delegate){
        [_delegate onGoOrderDetailPage:orderId];
    }
}

-(void)goRefundPage:(OrderModel *)model{
    if(_delegate){
        [_delegate onGoRefundPage:model];
    }
}

-(void)updateUI:(int)type datas:(NSMutableArray *)datas{
    if(_delegate){
        [_delegate onUpdateUI:type datas:datas];
    }
}

-(void)queryAgentAndMerchant{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = [[AccountManager sharedAccountManager] getUserModel].mchId;
    WS(weakSelf)
    [STNetUtil get:URL_QUERY_AGENT_AND_MERCHANT parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            weakSelf.queryDatas = [MerchantModel mj_objectArrayWithKeyValuesArray:data];
//            UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];
//            if(userModel.supportSevice == 1){
                MerchantModel *taxiModel = [[MerchantModel alloc]init];
                taxiModel.mchName = @"出租车";
                taxiModel.mchType = -1;
                [weakSelf.queryDatas addObject:taxiModel];
//            }
            [weakSelf.delegate onRequestSuccess:respondModel data:data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}
@end
