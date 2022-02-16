//
//  MainView.h
//  bus
//
//  Created by by.huang on 2018/9/13.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewModel.h"
#import "MainModel.h"
@interface MainView : UIView

-(instancetype)initWithViewModel:(MainViewModel *)viewModel;
-(void)updateData:(MainModel *)model;
-(void)updateView;
-(void)updateBroadcast:(NSString *)imgUrl content:(NSString *)content;
-(void)updateNewMsg;

@end
