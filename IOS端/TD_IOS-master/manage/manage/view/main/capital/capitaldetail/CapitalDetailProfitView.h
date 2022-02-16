//
//  CapitalDetailProfitView.h
//  manage
//
//  Created by by.huang on 2019/1/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapitalDetailViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapitalDetailProfitView : UIView

-(instancetype)initWithViewModel:(CapitalDetailViewModel *)viewModel;
-(void)updateView;
-(void)updateNoData;

@end

NS_ASSUME_NONNULL_END
