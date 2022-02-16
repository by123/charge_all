//
//  WhiteListRecordViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTRecordModel.h"

@protocol WhiteListRecordViewDelegate<BaseRequestDelegate>


-(void)onGoWhiteListPage;
-(void)onRequestNoData;
-(void)onDoCopy:(WTRecordModel *)model;
-(void)onDoChangeState:(WTRecordModel *)model;
//-(void)onDoChangeScope:(NSString *)mchId model:(WTRecordModel *)model;
-(void)onDoEditScope:(NSString *)mchId model:(WTRecordModel *)model;

@end


@interface WhiteListRecordViewModel : NSObject

@property(weak, nonatomic)id<WhiteListRecordViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *recordDatas;
@property(strong, nonatomic)NSMutableArray *scopeDatas;

-(void)requestRecordList:(Boolean)refreshNew;
-(void)changeWhiteListStatu:(Boolean)statu wtId:(NSString *)whiteListId;
-(void)goWhiteListPage;

-(void)doCopy:(WTRecordModel *)model;
-(void)doChangeState:(WTRecordModel *)model;
//-(void)doChangeScope:(NSString *)mchId model:(WTRecordModel *)model;
-(void)doEditScope:(NSString *)mchId model:(WTRecordModel *)model;

-(void)requestScopeList:(NSString *)mchId orderWhiteListId:(NSString *)orderWhiteListId purpose:(int)purpose;

@end


