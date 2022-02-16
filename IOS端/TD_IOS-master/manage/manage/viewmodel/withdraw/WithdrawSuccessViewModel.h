//
//  WithdrawSuccessViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithdrawDetailModel.h"

@protocol WithdrawSuccessViewDelegate<BaseRequestDelegate>

-(void)onBackHomePage;

@end


@interface WithdrawSuccessViewModel : NSObject

@property(weak, nonatomic)id<WithdrawSuccessViewDelegate> delegate;
@property(strong, nonatomic)WithdrawDetailModel *model;

-(void)requestWithdrawDetail:(NSString *)withdrawId;
-(void)backHomePage;


@end


