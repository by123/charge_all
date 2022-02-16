//
//  WTRecordCell.h
//  manage
//
//  Created by by.huang on 2019/3/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTRecordCell : UITableViewCell
@property(strong, nonatomic)UIButton *changeBtn;
@property(strong, nonatomic)UIButton *editBtn;
@property(strong, nonatomic)UIButton *cpBtn;

-(void)updateData:(WTRecordModel *)model;

+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
