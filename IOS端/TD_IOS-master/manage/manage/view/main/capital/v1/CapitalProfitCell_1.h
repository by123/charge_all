//
//  CapitalProfitCell_1.h
//  manage
//
//  Created by by.huang on 2018/11/17.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfitModel.h"

@interface CapitalProfitCell_1: UITableViewCell

-(void)updateData:(ProfitModel *)model;
+(NSString *)identify;

@end
