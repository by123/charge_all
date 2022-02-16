//
//  PerformanceArchiveCell.h
//  manage
//
//  Created by by.huang on 2019/7/1.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PerformanceArchiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PerformanceArchiveCell : UITableViewCell

-(void)updateData:(PerformanceArchiveModel *)model;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
