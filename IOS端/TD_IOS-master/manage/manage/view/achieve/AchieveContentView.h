//
//  AchieveContentView.h
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AchieveViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface AchieveContentView : UIView

-(instancetype)initWithType:(AchieveType)type viewModel:(AchieveViewModel *)achieveViewModel;

@end

NS_ASSUME_NONNULL_END
