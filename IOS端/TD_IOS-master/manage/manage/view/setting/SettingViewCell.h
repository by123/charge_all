//
//  SettingViewCell.h
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingViewCell : UITableViewCell

-(void)updateData:(NSString *)title line:(Boolean)line;

+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
