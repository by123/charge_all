//
//  TaxiViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupModel.h"

@protocol TaxiViewDelegate<BaseRequestDelegate>

-(void)onCreateGroup;
-(void)onRequestNoData:(Boolean)empty;
-(void)onGoScanPage:(NSString *)groupId groupName:(NSString *)groupName;
-(void)onGoGroupDetailPage:(GroupModel *)model;

@end


@interface TaxiViewModel : NSObject

@property(weak, nonatomic)id<TaxiViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *datas;

-(void)createGroup;
-(void)requestGroupList:(Boolean)refreshNew;
-(void)goScanPage:(NSString *)groupId groupName:(NSString *)groupName;
-(void)goGroupDetailPage:(GroupModel *)model;

@end


