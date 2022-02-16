
#import <UIKit/UIKit.h>
#import "BankModel.h"


@interface BankSelectViewCell : UITableViewCell

@property(strong, nonatomic)UIImageView *selectImageView;

-(void)updateData:(BankModel *)model;
+(NSString *)identify;

@end
