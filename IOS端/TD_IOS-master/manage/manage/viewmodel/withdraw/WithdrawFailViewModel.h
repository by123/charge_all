//
//  WithdrawFailViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithdrawDetailModel.h"

@protocol WithdrawFailViewDelegate<BaseRequestDelegate>

@end


@interface WithdrawFailViewModel : NSObject


@property(weak, nonatomic)id<WithdrawFailViewDelegate> delegate;
@property(copy, nonatomic)NSString *errorMsg;

-(void)requestWithdrawDetail:(NSString *)withdrawId;


@end


