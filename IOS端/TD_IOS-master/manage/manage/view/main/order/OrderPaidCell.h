//
//  OrderPaidCell.h
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderPaidCell : UITableViewCell

-(void)updateData:(OrderModel *)model;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
