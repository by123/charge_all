#import "WhiteListChargeTimeCell.h"


@interface WhiteListChargeTimeCell()

@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UIImageView *selectImageView;


@end

@implementation WhiteListChargeTimeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    _titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    _titleLabel.frame = CGRectMake(0, 0, ScreenWidth, STHeight(50));
    [self.contentView addSubview:_titleLabel];
    
    _selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(31), (STHeight(60) - STWidth(16))/2, STWidth(16), STWidth(16))];
    _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_selectImageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(50)-LineHeight, ScreenWidth, LineHeight)];
    lineView.backgroundColor = cline;
    [self.contentView addSubview:lineView];
}

-(void)updateData:(WTChargeTimeModel *)model{
    _titleLabel.text = [NSString stringWithFormat:@"%d小时",[model.time intValue] / 60];
    if(model.isSelect){
       _selectImageView.image = [UIImage imageNamed:IMAGE_ITEM_SELECT];
    }else{
       _selectImageView.image = [UIImage imageNamed:IMAGE_ITEM_NORMAL];
    }
}

+(NSString *)identify{
    return NSStringFromClass([WhiteListChargeTimeCell class]);
}

@end

