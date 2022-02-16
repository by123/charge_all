//
//  AgentManageViewCell.h
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AgentManageViewCell : UITableViewCell

-(void)updateData:(MerchantModel *)model;
+(NSString *)identify;


@end

NS_ASSUME_NONNULL_END
