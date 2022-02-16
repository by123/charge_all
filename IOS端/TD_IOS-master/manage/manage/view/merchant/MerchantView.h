//
//  MerchantView.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantViewModel.h"
#import "LocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MerchantView : UIView

-(instancetype)initWithViewModel:(MerchantViewModel *)viewModel;
//-(void)createScaleDatas;
-(void)updateChildChain;
//-(void)updateLocation:(AMapPOI *)poi;

@end

NS_ASSUME_NONNULL_END
