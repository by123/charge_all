//
//  MineView.h
//  manage
//
//  Created by by.huang on 2018/10/26.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewModel.h"


@interface MineView : UIView

-(instancetype)initWithViewModel:(MainViewModel *)viewModel;
-(void)updateView;
@end

