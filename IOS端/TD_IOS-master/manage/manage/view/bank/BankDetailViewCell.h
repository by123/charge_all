//
//  BankDetailViewCell.h
//  manage
//
//  Created by by.huang on 2018/12/4.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankDetailViewCell : UITableViewCell

-(void)updateData:(TitleContentModel *)model;

+(NSString *)identify;


@end

NS_ASSUME_NONNULL_END
