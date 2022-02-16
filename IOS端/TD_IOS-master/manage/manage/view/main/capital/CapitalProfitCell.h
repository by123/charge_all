//
//  CapitalProfitCell.h
//  manage
//
//  Created by by.huang on 2019/1/16.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfitModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapitalProfitCell : UITableViewCell

-(void)updateData:(ProfitModel *)model;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
