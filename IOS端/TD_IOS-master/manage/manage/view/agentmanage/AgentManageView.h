//
//  AgentManageView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentManageViewModel.h"


@interface AgentManageView : UIView

-(instancetype)initWithViewModel:(AgentManageViewModel *)viewModel;
-(void)updateView;
-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data;
-(void)onRequestFail:(NSString *)msg;
-(void)onRequestNoData:(Boolean)hasDatas;
@end

