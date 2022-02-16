//
//  AchieveDeviceCell.h
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AchieveDeviceCell : UITableViewCell

-(void)updateData:(DeviceModel *)model;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
