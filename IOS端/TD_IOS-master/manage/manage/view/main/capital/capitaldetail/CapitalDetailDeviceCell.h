//
//  CapitalDetailDeviceCell.h
//  manage
//
//  Created by by.huang on 2019/1/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapitalDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapitalDetailDeviceCell : UITableViewCell


-(void)updateData:(CapitalDetailModel *)model;
+(NSString *)identify;


@end

NS_ASSUME_NONNULL_END
