//
//  WithdrawViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankModel.h"
#import "WithdrawModel.h"
#import "CapitalModel.h"

@protocol WithdrawViewDelegate<BaseRequestDelegate>

-(void)onBackLastPage;
-(void)onGoSelectBank:(NSMutableArray *)datas;
-(void)onGoBindWeChat;

@end


@interface WithdrawViewModel : NSObject

@property(strong, nonatomic)NSMutableArray *banks;
@property(strong, nonatomic)BankModel *defaultModel;
@property(strong, nonatomic)WithdrawModel *withDrawModel;
@property(strong, nonatomic)CapitalModel *capitalModel;
@property(weak, nonatomic)id<WithdrawViewDelegate> delegate;
@property(copy, nonatomic)NSString *tips;

-(void)reqeustBankInfo;
-(void)requestRule:(double)withdrawMoneyYuan;
-(void)backLastPage;
-(void)doWithdraw:(NSString *)money;
-(void)goSelectBank;
-(void)goBindWeChat;

@end


