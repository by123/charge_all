//
//  OrderSearchViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderSearchViewModel.h"
#import "STNetUtil.h"

@interface OrderSearchViewModel()
@property(assign, nonatomic)int pageID;
@property(assign, nonatomic)int pid;

@end

@implementation OrderSearchViewModel

-(instancetype)init{
    if(self == [super init]){
        _pid = 1;
        _pageID = 1;
        _datas = [[NSMutableArray alloc]init];
        _merchantDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)searchDevice:(NSString *)key refreshNew:(Boolean)refreshNew{
    if(!_delegate)  return;
    if(refreshNew){
        _pid = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchName"] = key;
    dic[@"pageId"] = @(_pid);
    dic[@"pageSize"] = @(20);
    dic[@"mchForm"] = @"1";
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil post:URL_QUERY_All_AGENT_AND_MERCHANT content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            NSMutableArray *rows = [MerchantModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.merchantDatas = rows;
            }else{
                [weakSelf.merchantDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.pid += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
            }else{
                [weakSelf.delegate onRequestNoData:IS_NS_COLLECTION_EMPTY(weakSelf.merchantDatas)];
            }
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)requestOrderList:(Boolean)refreshNew orderId:(NSString *)orderId mchName:(NSString *)mchName deviceSn:(NSString *)deviceSn{
    if(!_delegate)  return;
    if(refreshNew){
        _pageID = 1;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"pageId"] = @(_pageID);
    dic[@"pageSize"] = @(PAGESIZE);
    if(!IS_NS_STRING_EMPTY(orderId)){
        dic[@"orderId"]= orderId;
    }
    if(!IS_NS_STRING_EMPTY(deviceSn)){
        dic[@"deviceSn"] = deviceSn;
    }
    if(!IS_NS_STRING_EMPTY(mchName)){
        dic[@"mchName"] = mchName;
    }
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil post:URL_ORDER_LIST content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            NSMutableArray *rows = [OrderModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"rows"]];
            if(refreshNew){
                weakSelf.datas = rows;
            }else{
                [weakSelf.datas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.pageID += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:data];
            }else{
                [weakSelf.delegate onRequestNoData];
            }
            
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


-(void)closePage{
    if(_delegate){
        [_delegate onClosePage];
    }
}

-(void)goOrderDetailPage:(NSString *)orderId{
    if(_delegate){
        [_delegate onGoOrderDetailPage:orderId];
    }
}

-(void)goRefundPage:(OrderModel *)orderModel{
    if(_delegate){
        [_delegate onGoRefundPage:orderModel];
    }
}

@end
