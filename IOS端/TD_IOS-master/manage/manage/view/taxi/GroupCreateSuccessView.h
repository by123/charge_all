//
//  GroupCreateSuccessView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupCreateSuccessViewModel.h"


@interface GroupCreateSuccessView : UIView

-(instancetype)initWithViewModel:(GroupCreateSuccessViewModel *)viewModel;
-(void)updateView;

@end

