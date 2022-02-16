//
//  WhiteListView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteListViewModel.h"


@interface WhiteListView : UIView

-(instancetype)initWithViewModel:(WhiteListViewModel *)viewModel;
-(void)updateView:(NSString *)name;
-(void)updateTime:(NSString *)time scale:(NSString *)scale;

@end

