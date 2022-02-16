//
//  WTScopeCell.h
//  manage
//
//  Created by by.huang on 2019/3/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTScopeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTScopeCell : UITableViewCell

@property(strong, nonatomic)UIButton *selectBtn;

-(void)updateData:(WTScopeModel *)model position:(NSInteger)position;

+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
