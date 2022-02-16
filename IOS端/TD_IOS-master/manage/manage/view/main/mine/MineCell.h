//
//  MineCell.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineCell : UITableViewCell

-(void)updateData:(NSString *)title imgSrc:(NSString *)imgSrc;

+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
