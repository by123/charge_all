
#import <UIKit/UIKit.h>
#import "GroupModel.h"


@interface TaxiViewCell : UITableViewCell

@property(strong, nonatomic)UIButton *addDeviceBtn;
@property(strong, nonatomic)UIButton *moreBtn;

-(void)updateData:(GroupModel *)model;
+(NSString *)identify;

@end
