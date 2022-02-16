//
//  MsgViewCell.h
//  manage
//
//  Created by by.huang on 2018/11/17.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MsgViewCell : UITableViewCell

-(void)updateData:(MsgModel *)model;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
