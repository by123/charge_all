//
//  AgentManageViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantModel.h"

@protocol AgentManageViewDelegate<BaseRequestDelegate>

-(void)onRequestNoData:(Boolean)hasDatas;
-(void)onGoAgentDetailPage:(MerchantModel *)model;
@end


@interface AgentManageViewModel : NSObject

@property(weak, nonatomic)id<AgentManageViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *merchantDatas;

-(void)requestAgentList:(NSString *)key refreshNew:(Boolean)refreshNew;
-(void)goAgentDetailPage:(MerchantModel *)model;

@end


