//
//  OrderSearchView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderSearchViewModel.h"


@interface OrderSearchView : UIView

-(instancetype)initWithViewModel:(OrderSearchViewModel *)viewModel;
-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data;
-(void)onRequestFail:(NSString *)msg;
-(void)onRequestNoData;
-(void)onRequestNoData:(Boolean)hasDatas;

@end

