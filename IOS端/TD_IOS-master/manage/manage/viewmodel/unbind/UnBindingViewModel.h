//
//  UnBindingViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UnBindingViewDelegate<BaseRequestDelegate>

-(void)onGoScanBindPage;
-(void)onGoMerchantBindPage;

@end


@interface UnBindingViewModel : NSObject

@property(weak, nonatomic)id<UnBindingViewDelegate> delegate;

-(void)goScanBindPage;
-(void)goMerchantBindPage;

@end


