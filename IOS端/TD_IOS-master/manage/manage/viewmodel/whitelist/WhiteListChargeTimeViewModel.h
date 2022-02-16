//
//  WhiteListChargeTimeViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTChargeTimeModel.h"

@protocol WhiteListChargeTimeViewDelegate<BaseRequestDelegate>

-(void)onGoBack;

@end


@interface WhiteListChargeTimeViewModel : NSObject

@property(weak, nonatomic)id<WhiteListChargeTimeViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *datas;
@property(copy, nonatomic)NSString *scale;
@property(assign, nonatomic)WhiteListType type;

-(void)goBack;
@end


