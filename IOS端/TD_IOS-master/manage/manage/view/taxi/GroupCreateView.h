//
//  GroupCreateView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupCreateViewModel.h"


@interface GroupCreateView : UIView

-(instancetype)initWithViewModel:(GroupCreateViewModel *)viewModel;
-(void)updateSaleSelectView;

@end

