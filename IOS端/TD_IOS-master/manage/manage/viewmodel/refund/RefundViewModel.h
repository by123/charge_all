//
//  RefundViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"

@protocol RefundViewDelegate<BaseRequestDelegate>


@end


@interface RefundViewModel : NSObject

@property(weak, nonatomic)id<RefundViewDelegate> delegate;
@property(strong, nonatomic)OrderModel *model;


-(void)requestRefund:(NSString *)reason refundMoney:(NSString *)refundMoney;

@end


