//
//  WhiteListEditView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteListEditViewModel.h"


@interface WhiteListEditView : UIView

-(instancetype)initWithViewModel:(WhiteListEditViewModel *)viewModel;
-(void)updateView;
-(void)updateTime:(NSString *)time scale:(NSString *)scale;

@end

