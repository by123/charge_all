//
//  UserModel.h
//  manage
//
//  Created by by.huang on 2018/10/26.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject<NSCoding>

//
@property(copy, nonatomic)NSString *token;

//user

@property(copy, nonatomic)NSString *mchId;
//0:代理商， 1:普通商户, 2:平台
@property(assign, nonatomic)int mchType;
@property(copy, nonatomic)NSString *userId;
@property(assign, nonatomic)int roleType;
@property(copy, nonatomic)NSString *name;
@property(copy, nonatomic)NSString *creid;
@property(assign, nonatomic)int cretype;
@property(copy, nonatomic)NSString *mobile;

//tblmch
@property(assign, nonatomic)int level;
@property(copy, nonatomic)NSString *mchName;
@property(copy, nonatomic)NSString *contactUser;
@property(copy, nonatomic)NSString *contactPhone;
@property(copy, nonatomic)NSString *province;
@property(copy, nonatomic)NSString *city;
@property(copy, nonatomic)NSString *area;
@property(copy, nonatomic)NSString *detailAddr;
@property(assign, nonatomic)long createTime;
@property(assign, nonatomic)int settementPeriod;
@property(assign,nonatomic)double totalPercent;
@property(copy, nonatomic)NSString *salesId;
@property(copy, nonatomic)NSString *superUser;
@property(copy, nonatomic)NSString *industry;
//是否支持出租车业务
@property(assign, nonatomic)int supportSevice;


+(NSString *)getMechantName:(int)mchType level:(int)level;
+(NSString *)getMechantType:(int)mchType;

@end

