//
//  BankSelectModel.h
//  manage
//
//  Created by by.huang on 2018/12/3.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankSelectModel : NSObject

//BKid
@property(copy, nonatomic)NSString *bank_id;

//BK名称
@property(copy, nonatomic)NSString *bank_name;

//BK编码
@property(copy, nonatomic)NSString *bank_code;

@end

NS_ASSUME_NONNULL_END
