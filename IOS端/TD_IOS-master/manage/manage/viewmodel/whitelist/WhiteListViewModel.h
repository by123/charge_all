//
//  WhiteListViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WhiteListViewDelegate<BaseRequestDelegate>

-(void)onGoWhiteListScopePage:(NSString *)orderWhiteListId;
-(void)onGoWhiteListChargeTimePage:(NSString *)scale;

@end


@interface WhiteListViewModel : NSObject

@property(weak, nonatomic)id<WhiteListViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *selectDatas;
@property(copy, nonatomic)NSString *orderWhiteListId;


-(void)goWhiteListScopePage:(NSString *)orderWhiteListId;
-(void)createWhiteList:(NSMutableArray *)datas userName:(NSString *)userName orderWhiteListId:(NSString *)orderWhiteListId scale:(int)scale time:(NSString *)time;
-(void)goWhiteListChargeTimePage:(NSString *)scale;

@end


