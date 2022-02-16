//
//  MsgDetailPage.h
//  by
//
//  Created by by.huang on block.
//  Copyright © 2018 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MsgDetailPage : BaseViewController

+(void)show:(BaseViewController *)controller msgId:(NSString *)msgId;
@property(copy, nonatomic)NSString *msgId;
@end

