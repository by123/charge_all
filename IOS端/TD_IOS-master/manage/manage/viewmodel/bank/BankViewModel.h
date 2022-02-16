//
//  BankViewModel.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankModel.h"

@protocol BankViewDelegate <BaseRequestDelegate>

-(void)onGoAddBankHomePage:(NSMutableArray *)banks;
-(void)onGoBankDetailPage:(BankModel *)bankModel;

@end

@interface BankViewModel : NSObject

@property(weak, nonatomic)id<BankViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *banks;

-(void)getBankInfo;
-(void)goAddBankHomePage;
-(void)goBankDetailPage:(BankModel *)model;
@end

