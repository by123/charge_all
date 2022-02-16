//
//  LoginViewModel.h
//  manage
//
//  Created by by.huang on 2018/10/25.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LoginViewDelegate <BaseRequestDelegate>

-(void)goNextPage;
-(void)onGoAgreementPage;

@end

@interface LoginViewModel : NSObject

@property(weak, nonatomic)id<LoginViewDelegate> delegate;


-(void)doLogin:(NSString *)userName psw:(NSString *)password;
-(void)goForgetPswPage;
-(void)goAgreementPage;

@end

NS_ASSUME_NONNULL_END
