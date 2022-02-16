//
//  CapitalContentVIew.h
//  manage
//
//  Created by by.huang on 2018/11/17.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewModel.h"
#import "CapitalViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapitalContentView : UIView

-(instancetype)initWithViewModel:(CapitalViewModel *)viewModel;

-(void)uploadMore;
-(void)refreshNew;
-(void)updateSuccessData:(id)data;
-(void)updateNoData:(int)type;

@end

NS_ASSUME_NONNULL_END
