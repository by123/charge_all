//
//  MsgView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgViewModel.h"


@interface MsgView : UIView

-(instancetype)initWithViewModel:(MsgViewModel *)viewModel;
-(void)updateView;
-(void)updateNoDatas:(Boolean)hasDatas;

@end

