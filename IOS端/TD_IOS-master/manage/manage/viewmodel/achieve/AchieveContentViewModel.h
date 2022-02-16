//
//  AchieveContentViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantModel.h"
#import "DeviceModel.h"
#import "ProfitModel.h"

@protocol AchieveContentViewDelegate<BaseRequestDelegate>

-(void)onRequestNoData:(int)type;
-(void)onRequestTotalCount:(NSString *)count extra:(NSString *)extra;


@end


@interface AchieveContentViewModel : NSObject

@property(weak, nonatomic)id<AchieveContentViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray<MerchantModel *> *merchantDatas;
@property(strong, nonatomic)NSMutableArray<DeviceModel *> *deviceDatas;
@property(strong, nonatomic)NSMutableArray<ProfitModel *> *profitDatas;
@property(assign, nonatomic)int year;
@property(assign, nonatomic)int month;


-(void)requestMerchantList:(Boolean)refreshNew;
-(void)requestDeviceList:(Boolean)refreshNew;
-(void)reqeustProfitList:(Boolean)refreshNew;

@end


