//
//  AgentDetailViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgentDetailModel.h"

@protocol AgentDetailViewDelegate<BaseRequestDelegate>


-(void)onGoAgentEditPage:(AgentDetailModel *)model;
-(void)onGoMerchantEditPage:(AgentDetailModel *)model;
-(void)onGoNavigation:(double)myLatitude myLongitude:(double)myLongitude latitude:(double)latitude longitude:(double)longitude name:(NSString *)name;

@end


@interface AgentDetailViewModel : NSObject

@property(weak, nonatomic)id<AgentDetailViewDelegate> delegate;
@property(strong, nonatomic)AgentDetailModel *model;
@property(strong, nonatomic)NSMutableArray *infoDatas;
@property(strong, nonatomic)NSMutableArray *agentDatas;
@property(strong, nonatomic)NSMutableArray *ruleDatas;
@property(strong, nonatomic)NSMutableArray *deviceDatas;

-(void)reqeustAgentDetail:(NSString *)mchId;
-(void)goAgentEditPage;
-(void)goMerchantEditPage;

-(void)goNavigation:(double)myLatitude myLongitude:(double)myLongitude latitude:(double)latitude longitude:(double)longitude name:(NSString *)name;

@end


