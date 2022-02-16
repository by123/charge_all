//
//  BindWeChatView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindWeChatViewModel.h"


@interface BindWeChatView : UIView

-(instancetype)initWithViewModel:(BindWeChatViewModel *)viewModel;
-(void)updateView;

@end

