//
//  AccountView.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountView : UIView

-(instancetype)initWithViewModel:(AccountViewModel *)viewModel;
-(void)updateData;

@end

NS_ASSUME_NONNULL_END
