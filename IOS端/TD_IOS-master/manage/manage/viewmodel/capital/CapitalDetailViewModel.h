//
//  CapitalDetailViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CapitalDetailModel.h"

@protocol CapitalDetailViewDelegate<BaseRequestDelegate>

-(void)onRequestNoData:(int)type;

@end


@interface CapitalDetailViewModel : NSObject

@property(weak, nonatomic)id<CapitalDetailViewDelegate> delegate;
@property(strong, nonatomic)CapitalDetailModel *detailModel;
@property(strong, nonatomic)NSMutableArray *profitDatas;
@property(strong, nonatomic)NSMutableArray *deviceDatas;
@property(copy, nonatomic)NSString *date;


-(void)getDeviceUsing;
-(void)getChildProfit:(Boolean)refreshNew;
-(void)getChildDeviceUsing:(Boolean)refreshNew;
//-(void)getWithdrawTime;

@end


