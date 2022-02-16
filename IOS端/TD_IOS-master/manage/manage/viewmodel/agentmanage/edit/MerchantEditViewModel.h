//
//  MerchantEditViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddMerchantModel.h"
#import "PayRuleModel.h"
#import "AgentDetailModel.h"

@protocol MerchantEditViewDelegate<BaseRequestDelegate>

-(void)onGoBack;
-(void)onGoLocationPage;

@end


@interface MerchantEditViewModel : NSObject

@property(weak, nonatomic)id<MerchantEditViewDelegate> delegate;
@property(strong, nonatomic)AddMerchantModel *model;
@property(strong, nonatomic)NSMutableArray *rules;
@property(strong, nonatomic)AgentDetailModel *detailModel;

-(instancetype)initWithModel:(AgentDetailModel *)detailModel;
-(void)requestEditMerchant;
-(void)getDefaultPayRule;
-(void)goBack;
-(void)goLocationPage;

@end


