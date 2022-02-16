//
//  MerchantViewModel.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddMerchantModel.h"
#import "PayRuleModel.h"

@protocol MerchantViewDelegate <BaseRequestDelegate>

-(void)onGoLocationPage;

@end

@interface MerchantViewModel : NSObject

@property(weak, nonatomic)id<MerchantViewDelegate> delegate;
@property(strong, nonatomic)AddMerchantModel *model;
@property(strong, nonatomic)NSMutableArray *rules;
@property(strong, nonatomic)NSMutableArray *chains;

-(void)addMerchant;
-(void)addChildChain;
-(void)getDefaultPayRule;
-(void)queryChildChain;
-(void)goLocationPage;

@end

