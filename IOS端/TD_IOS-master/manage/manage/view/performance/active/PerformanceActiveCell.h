//
//  PerformanceActiveCell.h
//  manage
//
//  Created by by.huang on 2019/6/19.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceActiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceActiveCell : UITableViewCell
//名称按钮
@property(strong, nonatomic)UIButton *nameBtn;

-(void)updateData:(PerformanceActiveModel *)model;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
