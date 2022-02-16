//
//  BindWeChatViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BindWeChatViewDelegate<BaseRequestDelegate>

-(void)onDoWeChatAuth;

@end


@interface BindWeChatViewModel : NSObject

@property(weak, nonatomic)id<BindWeChatViewDelegate> delegate;

-(void)doWeChatAuth;
-(void)bindWeChat:(NSString *)code;

@end


