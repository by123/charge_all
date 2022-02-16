//
//  WhiteListScopeViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTScopeModel.h"

@protocol WhiteListScopeViewDelegate<BaseRequestDelegate>

-(void)onSaveSelect:(NSMutableArray *)datas;
-(void)onGoEditWhiteListPage:(NSMutableArray *)datas;

@end


@interface WhiteListScopeViewModel : NSObject

@property(weak, nonatomic)id<WhiteListScopeViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *scopeDatas;
@property(assign, nonatomic)int from;
@property(copy, nonatomic)NSString *orderWhiteListId;

-(void)initTopLayerDatas;
-(void)queryChildDatas:(NSString *)mchId selected:(WhiteListSelectStatu)selected position:(NSInteger)position;
-(void)requestScopeList:(NSString *)mchId selected:(WhiteListSelectStatu)selected position:(NSInteger)position;
-(void)saveSelect:(NSMutableArray *)selectDatas;
-(void)goEditWhiteListPage:(NSMutableArray *)datas;

@end


