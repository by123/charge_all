//
//  MerchantSearchCell.h
//  manage
//
//  Created by by.huang on 2019/1/7.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MerchantSearchCell : UITableViewCell

-(void)updateData:(NSString *)result;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
