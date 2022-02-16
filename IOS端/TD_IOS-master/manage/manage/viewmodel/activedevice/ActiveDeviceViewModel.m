////
////  ActiveDeviceViewModel.m
////  manage
////
////  Created by by.huang on 2018/10/27.
////  Copyright © 2018年 by.huang. All rights reserved.
////
//
//#import "ActiveDeviceViewModel.h"
//#import "STNetUtil.h"
//
//@implementation ActiveDeviceViewModel
//
//-(instancetype)init{
//    if(self == [super init]){
//        _merchantDatas = [[NSMutableArray alloc]init];
//    }
//    return self;
//}
//
//-(void)searchDevice:(NSString *)key{
//    if(!_delegate)  return;
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    dic[@"queryName"] = key;
//    dic[@"mchType"] = @(-1);
//    dic[@"queryDirectMchType"] = @(0);
//    [_delegate onRequestBegin];
//    WS(weakSelf)
//    [STNetUtil get:URL_QUERY_All_AGENT_AND_MERCHANT parameters:dic success:^(RespondModel *respondModel) {
//        if([respondModel.status isEqualToString:STATU_SUCCESS]){
//            weakSelf.merchantDatas = [MerchantModel mj_objectArrayWithKeyValuesArray:respondModel.data];
//            NSPredicate *apredicate=[NSPredicate predicateWithFormat:@"mchType==1"];
//            NSArray *newDatas=[weakSelf.merchantDatas filteredArrayUsingPredicate:apredicate];
//            [weakSelf.merchantDatas removeAllObjects];
//            [weakSelf.merchantDatas addObjectsFromArray:newDatas];
//            [weakSelf.delegate onRequestSuccess:respondModel data:weakSelf.merchantDatas];
//        }else{
//            [weakSelf.delegate onRequestFail:respondModel.msg];
//        }
//    } failure:^(int errorCode) {
//        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
//    }];
//
//}
//
//
//-(void)goStartActiveDevice:(NSString *)mchId mchName:(NSString *)mchName{
//    if(_delegate){
//        [_delegate onScanDevice:mchId mchName:mchName];
//    }
//}
//
//-(void)goMerchantBindPage:(MerchantModel *)model{
//    if(_delegate){
//        [_delegate onGoMerchantBindPage:model];
//    }
//}
//
//@end
