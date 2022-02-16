//
//  GroupDetailView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetailViewModel.h"


@interface GroupDetailView : UIView

-(instancetype)initWithViewModel:(GroupDetailViewModel *)viewModel;
-(void)updateView;

@end

