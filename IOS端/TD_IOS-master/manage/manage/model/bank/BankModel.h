//
//  BankModel.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankModel : NSObject

//BK名称
@property(copy, nonatomic)NSString *bankName;

//BK卡号
@property(copy, nonatomic)NSString *bankId;

//支行名称
@property(copy, nonatomic)NSString *bankBranch;

//账户名称
@property(copy, nonatomic)NSString *accountName;

//是否对公账户
@property(assign, nonatomic)int isPublic;

//微信头像
@property(copy, nonatomic)NSString *headUrl;

@property(assign, nonatomic)Boolean isSelect;

@property(assign, nonatomic)Boolean hasAllType;

+(Boolean)hasAllType:(NSMutableArray *)datas;

@end

NS_ASSUME_NONNULL_END
