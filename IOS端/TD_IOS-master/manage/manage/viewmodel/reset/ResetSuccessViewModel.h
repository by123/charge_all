//
//  ResetSuccessViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResetSuccessViewDelegate<BaseRequestDelegate>

@end


@interface ResetSuccessViewModel : NSObject

@property(weak, nonatomic)id<ResetSuccessViewDelegate> delegate;
@property(copy, nonatomic)NSString *deviceSNStr;

-(void)doCall;

@end


