//
//  ResetViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResetViewDelegate<BaseRequestDelegate>

@end


@interface ResetViewModel : NSObject

@property(weak, nonatomic)id<ResetViewDelegate> delegate;
@property(copy, nonatomic)NSString *deviceSNStr;
@property(copy, nonatomic)NSString *psw;

-(void)doReset;
-(void)confirmReset;
-(void)doCall;

@end


