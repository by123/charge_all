//
//  AgentDetailModel.h
//  manage
//
//  Created by by.huang on 2019/1/11.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AgentDetailModel : NSObject

//代理商等级
@property(assign, nonatomic)int level;
//代理商账号
@property(copy, nonatomic)NSString *mchId;
//代理商名称
@property(copy, nonatomic)NSString *mchName;
//代理商类型
@property(assign, nonatomic)int mchType;
//代理人姓名
@property(copy, nonatomic)NSString *contactUser;
//代理人电话
@property(copy, nonatomic)NSString *contactPhone;
//结算周期
@property(assign, nonatomic)int settementPeriod;
//分润比例
@property(assign, nonatomic)double profitPercent;
@property(assign, nonatomic)double totalPercent;
//关联业务员
@property(copy, nonatomic)NSString *salesName;
//账号创建日期
@property(assign, nonatomic)long createTime;
//冻结金额
@property(assign, nonatomic)double blockedAmount;
//冻结金额(元)
@property(assign, nonatomic)double blockedAmountYuan;
//设备总数
@property(assign, nonatomic)int deviceTotal;
//设备激活数
@property(assign, nonatomic)int deviceActiveTotal;



//商户字段
@property(copy, nonatomic)NSString *industry;
@property(strong, nonatomic)NSMutableArray *mchPriceRule;
@property(copy, nonatomic)NSString *pledgeYuan;
@property(strong, nonatomic)NSMutableArray *service;

@property(copy, nonatomic)NSString *province;
@property(copy, nonatomic)NSString *city;
@property(copy, nonatomic)NSString *area;
@property(copy, nonatomic)NSString *detailAddr;

@property(assign, nonatomic)double mchLocationLatitude;
@property(assign, nonatomic)double mchLocationLongitude;

@property(copy, nonatomic)NSString *provinceAgentMchName;
@property(copy, nonatomic)NSString *cityAgentMchName;
@property(copy, nonatomic)NSString *countryAgentMchName;
@property(copy, nonatomic)NSString *listAgentMchName;

@property(copy, nonatomic)NSString *mchLocationProvince;
@property(copy, nonatomic)NSString *mchLocationCity;
@property(copy, nonatomic)NSString *mchLocationArea;
@property(copy, nonatomic)NSString *mchLocationDetailAddr;

@property(assign, nonatomic)double profitPool;
@property(assign, nonatomic)double percentInPool;



@end

NS_ASSUME_NONNULL_END
