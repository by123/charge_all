//
//  AgentEditViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddAgentModel.h"
#import "AgentDetailModel.h"

@protocol AgentEditViewDelegate<BaseRequestDelegate>

-(void)onGoBack;
-(void)onGoLocationPage;
@end


@interface AgentEditViewModel : NSObject

@property(weak, nonatomic)id<AgentEditViewDelegate> delegate;
@property(strong, nonatomic)AddAgentModel *model;
@property(strong, nonatomic)AgentDetailModel *detailModel;

-(void)requestEditAgent;
-(void)goBack;
-(void)goLocationPage;
@end


