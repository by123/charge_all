//
//  ResultViewModel.h
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ResultViewDelegate

-(void)onCopyCallback:(NSString *)userName psw:(NSString *)password;
-(void)onConfirmCallBack;

@end


@interface ResultViewModel : NSObject

@property(weak, nonatomic)id<ResultViewDelegate> delegate;
@property(strong, nonatomic)NSString *mUserNameStr;
@property(strong, nonatomic)NSString *mPswStr;
@property(assign, nonatomic)int mType;

-(void)doCopy;

-(void)doConfirm;

@end

NS_ASSUME_NONNULL_END
