//
//  AgentViewModel.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddAgentModel.h"


@protocol AgentViewDelegate <BaseRequestDelegate>

-(void)onGoLocationPage;

@end

@interface AgentViewModel : NSObject

@property(weak, nonatomic)id<AgentViewDelegate> delegate;
@property(strong, nonatomic)AddAgentModel *model;

-(void)addAgent;
-(void)goLocationPage;

@end

