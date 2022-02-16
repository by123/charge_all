//
//  DetailViewCell.h
//  manage
//
//  Created by by.huang on 2019/1/11.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewCell : UITableViewCell

-(void)updateData:(TitleContentModel *)model lineHidden:(Boolean)lineHidden;

+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
