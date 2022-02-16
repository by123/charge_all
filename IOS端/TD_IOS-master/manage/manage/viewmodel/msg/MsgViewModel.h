//
//  MsgViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgModel.h"

@protocol MsgViewDelegate<BaseRequestDelegate>

-(void)onRequestNoData:(Boolean)hasDatas;
-(void)onGoMsgDetailPage:(NSString *)msgId;

@end


@interface MsgViewModel : NSObject

@property(weak, nonatomic)id<MsgViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray <MsgModel *> *datas;


-(void)requestMsgList:(Boolean)refreshNew;
-(void)goMsgDetailPage:(NSString *)msgId;

@end


