//
//  AchieveViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantModel.h"

@protocol AchieveViewDelegate<BaseRequestDelegate>

-(void)onGoAgentDetailPage:(MerchantModel *)model;

@end


@interface AchieveViewModel : NSObject

@property(weak, nonatomic)id<AchieveViewDelegate> delegate;
@property(assign, nonatomic)NSInteger currentTab;
@property(strong, nonatomic)NSMutableArray *datas;

-(void)goAgentDetailPage:(MerchantModel *)model;



@end


