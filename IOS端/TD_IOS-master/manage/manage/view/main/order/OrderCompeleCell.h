//
//  OrderCompeleCell.h
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@protocol OrderCompeleDelegate <NSObject>

-(void)OnClickRefundBtn:(NSInteger)position;

@end
NS_ASSUME_NONNULL_BEGIN

@interface OrderCompeleCell : UITableViewCell

@property(weak, nonatomic)id<OrderCompeleDelegate> delegate;

-(void)updateData:(OrderModel *)model position:(NSInteger)position;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
