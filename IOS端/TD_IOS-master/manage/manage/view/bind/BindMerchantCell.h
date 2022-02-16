//
//  BindMerchantCell.h
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BindMerchantCell : UITableViewCell

-(void)updateData:(MerchantModel *)model;

+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
