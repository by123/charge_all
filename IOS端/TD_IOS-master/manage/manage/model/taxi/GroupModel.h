//
//  GroupModel.h
//  manage
//
//  Created by by.huang on 2019/4/3.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupModel : NSObject

//分组ID
@property(copy,nonatomic)NSString *groupId;
//分组名称
@property(copy,nonatomic)NSString *groupName;
//充电价格
@property(copy,nonatomic)NSString *service;
//分润比例
@property(assign,nonatomic)double profitPercentTaxi;
//关联业务员
@property(copy,nonatomic)NSString *salesId;
//业务员名字
@property(copy,nonatomic)NSString *salesName;

//售前
@property(copy,nonatomic)NSString *presaleContactName;
@property(copy,nonatomic)NSString *presaleContactTel;
@property(copy,nonatomic)NSString *presaleDetailAddr;

@property(copy,nonatomic)NSString *presaleProvince;
@property(copy,nonatomic)NSString *presaleCity;
@property(copy,nonatomic)NSString *presaleArea;

//售后
@property(copy,nonatomic)NSString *aftersaleContactName;
@property(copy,nonatomic)NSString *aftersaleContactTel;
@property(copy,nonatomic)NSString *aftersaleDetailAddr;

@property(copy,nonatomic)NSString *aftersaleProvince;
@property(copy,nonatomic)NSString *aftersaleCity;
@property(copy,nonatomic)NSString *aftersaleArea;

//
@property(assign,nonatomic)int deviceTotal;
@property(assign,nonatomic)int deviceTotalActive;
@property(assign,nonatomic)int taxiNum;

@property(copy,nonatomic)NSString *deposit;


@end

NS_ASSUME_NONNULL_END
