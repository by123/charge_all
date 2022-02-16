//
//  MerchantUnBindView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantUnBindViewModel.h"


@interface MerchantUnBindView : UIView

-(instancetype)initWithViewModel:(MerchantUnBindViewModel *)viewModel;
-(void)updateView;

@end

