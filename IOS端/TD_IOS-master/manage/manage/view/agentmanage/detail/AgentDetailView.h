//
//  AgentDetailView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentDetailViewModel.h"


@interface AgentDetailView : UIView

-(instancetype)initWithViewModel:(AgentDetailViewModel *)viewModel;
-(void)updateView;

@end

