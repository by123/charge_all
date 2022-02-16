//
//  MerchantUnBindResultView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantUnBindResultViewModel.h"


@interface MerchantUnBindResultView : UIView

-(instancetype)initWithViewModel:(MerchantUnBindResultViewModel *)viewModel;
-(void)updateView;

@end

