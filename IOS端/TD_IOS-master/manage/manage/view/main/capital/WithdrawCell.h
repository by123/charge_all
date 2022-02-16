//
//  WithdrawCell.h
//  manage
//
//  Created by by.huang on 2018/12/6.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawDetailModel.h"

@interface WithdrawCell : UITableViewCell

-(void)updateData:(WithdrawDetailModel *)model;
+(NSString *)identify;

@end


