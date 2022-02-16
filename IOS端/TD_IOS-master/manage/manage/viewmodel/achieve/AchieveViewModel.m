
//
//  AchieveViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AchieveViewModel.h"

@implementation AchieveViewModel

-(void)goAgentDetailPage:(MerchantModel *)model{
    if(_delegate){
        [_delegate onGoAgentDetailPage:model];
    }
}

@end
