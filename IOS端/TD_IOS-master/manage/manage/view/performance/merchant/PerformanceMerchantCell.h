//
//  PerformanceMerchantCell.h
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceMerchantModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceMerchantCell : UITableViewCell
//名称按钮
@property(strong, nonatomic)UIButton *nameBtn;


-(void)updateData:(PerformanceMerchantModel *)model;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
