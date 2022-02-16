//
//  WTRecordModel.h
//  manage
//
//  Created by by.huang on 2019/3/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTRecordModel : NSObject

@property(copy, nonatomic)NSString *orderWhiteListId;
@property(copy, nonatomic)NSString *userName;
@property(copy, nonatomic)NSString *userId;
@property(copy, nonatomic)NSString *inviterId;
@property(assign, nonatomic)int whiteListState;
@property(copy, nonatomic)NSString *headUrl;
@property(assign, nonatomic)int duration;
@property(assign, nonatomic)int timeLevel;


@end

NS_ASSUME_NONNULL_END
