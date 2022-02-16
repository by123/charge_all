//
//  WhiteListEditViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTRecordModel.h"
#import "WTScopeModel.h"

@protocol WhiteListEditViewDelegate<BaseRequestDelegate>

-(void)onGoWhiteListChargeTimePage:(NSString *)timeLevel;
-(void)onGoWhiteListScopePage:(NSString *)orderWhiteListId;

@end


@interface WhiteListEditViewModel : NSObject

@property(weak, nonatomic)id<WhiteListEditViewDelegate> delegate;
@property(strong, nonatomic)WTRecordModel *recordModel;
@property(strong, nonatomic)NSMutableArray *selectDatas;


-(void)editWhiteListScope;
-(void)goWhiteListChargeTimePage:(NSString *)timeLevel;
-(void)goWhiteListScopePage:(NSString *)orderWhiteListId;

@end


