//
//  UpdatePswViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol UpdatePswViewDelegate<BaseRequestDelegate>


@end

@interface UpdatePswViewModel : NSObject

@property(weak, nonatomic)id<UpdatePswViewDelegate> delegate;

-(void)updatePsw:(NSString *)oldPsw newPsw:(NSString *)newPsw reNewPsw:(NSString *)reNewPsw;

@end

NS_ASSUME_NONNULL_END
