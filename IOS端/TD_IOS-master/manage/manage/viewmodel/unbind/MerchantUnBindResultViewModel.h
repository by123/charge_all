//
//  MerchantUnBindResultViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MerchantUnBindResultViewDelegate<BaseRequestDelegate>

-(void)onBankHome;

@end


@interface MerchantUnBindResultViewModel : NSObject
@property(assign, nonatomic)int count;
@property(assign, nonatomic)Boolean isSuccess;

@property(weak, nonatomic)id<MerchantUnBindResultViewDelegate> delegate;

-(void)bankHome;

@end


