//
//  BankHomeViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithdrawModel.h"
#define WeChat 0
#define Corporate 1
#define Personal  2

@protocol BankHomeViewDelegate<BaseRequestDelegate>

-(void)onGoAddBankPage:(NSInteger)type;

@end


@interface BankHomeViewModel : NSObject

@property(strong, nonatomic)NSMutableArray *withdrawRules;
@property(weak, nonatomic)id<BankHomeViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *banks;

-(void)goAddBankPage:(NSInteger)type;
-(void)requestRule;

@end


