//
//  WhiteListRecordView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteListRecordViewModel.h"


@interface WhiteListRecordView : UIView

-(instancetype)initWithViewModel:(WhiteListRecordViewModel *)viewModel;
-(void)updateView;
-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data;
-(void)onRequestNoData;

@end

