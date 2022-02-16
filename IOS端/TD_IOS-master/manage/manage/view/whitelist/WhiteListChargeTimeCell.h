
#import <UIKit/UIKit.h>
#import "WTChargeTimeModel.h"

@interface WhiteListChargeTimeCell : UITableViewCell

-(void)updateData:(WTChargeTimeModel *)model;
+(NSString *)identify;

@end
