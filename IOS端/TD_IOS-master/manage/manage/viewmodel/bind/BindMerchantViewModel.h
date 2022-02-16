//
//  BindMerchantViewModel.h
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BindMerchantViewDelegate <BaseRequestDelegate>

-(void)onBindMerchant:(MerchantModel *)model;

-(void)onRequestNoData:(Boolean)hasDatas;

-(void)onScanDevice:(NSString *)mchId mchName:(NSString *)mchName;

-(void)onGoMerchantUnBindPage:(MerchantModel *)model;

@end

@interface BindMerchantViewModel : NSObject

@property(weak, nonatomic)id<BindMerchantViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *merchantDatas;
@property(copy, nonatomic)NSString *openid;
@property(copy, nonatomic)NSString *unionid;
@property(copy, nonatomic)NSString *type;
@property(assign, nonatomic)MerchantFromType from;

-(void)getMechantDatas:(NSString *)queryName refreshNew:(Boolean)refreshNew;

-(void)doBindMerchant:(MerchantModel *)model;
-(void)bindMerchant:(MerchantModel *)model;
//开始激活
-(void)goStartActiveDevice:(NSString *)mchId mchName:(NSString *)mchName;
//跳转到商户解绑
-(void)goMerchantUnBindPage:(MerchantModel *)model;

@end
NS_ASSUME_NONNULL_END
