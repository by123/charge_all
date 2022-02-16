//
//  MsgModel.h
//  manage
//
//  Created by by.huang on 2018/11/17.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgModel : NSObject

@property(copy, nonatomic)NSString *msgId;
@property(copy, nonatomic)NSString *title;
@property(copy, nonatomic)NSString *brief;
@property(copy, nonatomic)NSString *content;
@property(assign, nonatomic)int mchType;
@property(assign, nonatomic)long publishTime;
@property(assign, nonatomic)long createTime;
@property(assign, nonatomic)long modifyTime;
@property(assign, nonatomic)int noticeState;

@end

NS_ASSUME_NONNULL_END
