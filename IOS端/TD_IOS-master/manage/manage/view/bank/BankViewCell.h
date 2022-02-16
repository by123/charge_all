
#import <UIKit/UIKit.h>
#import "BankModel.h"

@interface BankViewCell : UITableViewCell

-(void)updateData:(BankModel *)model;
+(NSString *)identify;

@end
