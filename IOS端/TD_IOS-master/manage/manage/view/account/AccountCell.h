//
//  AccountCell.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountCell : UITableViewCell

-(void)updateData:(TitleContentModel *)model;

+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
