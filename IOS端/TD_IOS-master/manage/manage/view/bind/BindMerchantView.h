//
//  BindMerchantView.h
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindMerchantViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BindMerchantView : UIView

-(instancetype)initWithViewModel:(BindMerchantViewModel *)viewModel;
-(void)updateView;
-(void)onRequestFail:(NSString *)msg;
-(void)onRequestNoData:(Boolean)hasDatas;

@end

NS_ASSUME_NONNULL_END
