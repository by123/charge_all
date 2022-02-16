//
//  WithdrawWechatCell.h
//  manage
//
//  Created by by.huang on 2019/5/7.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithdrawDetailModel.h"

@interface WithdrawWechatCell : UITableViewCell

-(void)updateData:(WithdrawDetailModel *)model;
+(NSString *)identify;

@end

