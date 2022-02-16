//
//  AchieveProfitCell.h
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfitModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AchieveProfitCell : UITableViewCell

-(void)updateData:(ProfitModel *)model;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
