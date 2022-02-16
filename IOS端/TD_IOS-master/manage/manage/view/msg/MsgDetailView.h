//
//  MsgDetailView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgDetailViewModel.h"


@interface MsgDetailView : UIView

-(instancetype)initWithViewModel:(MsgDetailViewModel *)viewModel;
-(void)updateView;

@end

