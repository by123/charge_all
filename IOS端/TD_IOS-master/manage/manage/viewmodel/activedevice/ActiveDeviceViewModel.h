////
////  ActiveDeviceViewModel.h
////  manage
////
////  Created by by.huang on 2018/10/27.
////  Copyright © 2018年 by.huang. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "MerchantModel.h"
//
//NS_ASSUME_NONNULL_BEGIN
//
//@protocol ActiveDeviceViewDelegate <BaseRequestDelegate>
//
//-(void)onScanDevice:(NSString *)mchId mchName:(NSString *)mchName;
//-(void)onGoMerchantBindPage:(MerchantModel *)model;
//-(void)onRequestNoData:(Boolean)hasDatas;
//
//@end
//
//@interface ActiveDeviceViewModel : NSObject
//
//@property(weak, nonatomic)id<ActiveDeviceViewDelegate> delegate;
//@property(strong, nonatomic)NSMutableArray *merchantDatas;
//@property(assign, nonatomic)DeviceActiveType type;
//
//
////搜索设备
//-(void)searchDevice:(NSString *)key;
//
////开始激活
//-(void)goStartActiveDevice:(NSString *)mchId mchName:(NSString *)mchName;
//
////跳转到商户解绑
//-(void)goMerchantBindPage:(MerchantModel *)model;
//
//@end
//
//NS_ASSUME_NONNULL_END
