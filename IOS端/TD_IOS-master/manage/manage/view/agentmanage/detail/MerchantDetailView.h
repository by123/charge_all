//
//  MerchantDetailView.h
//  manage
//
//  Created by by.huang on 2019/1/11.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentDetailViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MerchantDetailView : UIView

-(instancetype)initWithViewModel:(AgentDetailViewModel *)viewModel;
-(void)updateView;

@end

NS_ASSUME_NONNULL_END
