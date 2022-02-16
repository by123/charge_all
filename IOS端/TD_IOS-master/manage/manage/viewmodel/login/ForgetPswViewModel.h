//
//  ForgetPswViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ForgetPswViewDelegate<BaseRequestDelegate>

-(void)onClosePage;

@end


@interface ForgetPswViewModel : NSObject

@property(weak, nonatomic)id<ForgetPswViewDelegate> delegate;
@property(copy, nonatomic)NSString *accountStr;
@property(copy, nonatomic)NSString *phoneNum;
@property(copy, nonatomic)NSString *token;

-(void)closePage;
-(void)getVerifyCode:(NSString *)accountStr;
-(void)checkVerifyCode:(NSString *)verifyCode;
-(void)resetPsw:(NSString *)password;

@end


