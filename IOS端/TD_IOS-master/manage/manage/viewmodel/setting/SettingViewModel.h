//
//  SettingViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SettingViewDelegate

-(void)onLogout;
-(void)onGoUpdatePswPage;
-(void)onGoAboutPage;

@end

@interface SettingViewModel : NSObject

@property(weak, nonatomic)id<SettingViewDelegate> delegate;


-(void)doLogout;
-(void)goUpdatePswPage;
-(void)goAboutPage;

@end

NS_ASSUME_NONNULL_END
