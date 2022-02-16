//
//  BankView.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankView : UIView

-(instancetype)initWithViewModel:(BankViewModel *)viewModel;
-(void)updateView;
@end

NS_ASSUME_NONNULL_END
