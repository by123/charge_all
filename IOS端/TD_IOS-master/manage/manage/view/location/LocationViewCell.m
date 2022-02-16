//#import "LocationViewCell.h"
//
//@interface LocationViewCell()
//
//@property(strong, nonatomic)UILabel *titleLabel;
//@property(strong, nonatomic)UILabel *detailLabel;
//@property(strong, nonatomic)UIView *lineView;
//@property(strong, nonatomic)UIImageView *selectImageView;
//
//@end
//
//@implementation LocationViewCell
//
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
//        [self initView];
//    }
//    return self;
//}
//
//
//-(void)initView{
//    _titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"" textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:YES];
//    [self.contentView addSubview:_titleLabel];
//    
//    _detailLabel = [[UILabel alloc]initWithFont:STFont(11) text:@"" textAlignment:NSTextAlignmentLeft textColor:c05 backgroundColor:nil multiLine:YES];
//    [self.contentView addSubview:_detailLabel];
//    
//    _lineView = [[UIView alloc]init];
//    _lineView.backgroundColor = cline;
//    [self.contentView addSubview:_lineView];
//    
//    _selectImageView = [[UIImageView alloc]init];
//    _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.contentView addSubview:_selectImageView];
//}
//
//-(void)updateData:(LocationModel *)model position:(NSInteger)position{
//
//    AMapPOI *poi = model.poi;
//    _titleLabel.text = poi.name;
//    CGSize titleSize = [_titleLabel.text sizeWithMaxWidth:ScreenWidth-STWidth(30) font:STFont(15)];
//    _titleLabel.frame = CGRectMake(STWidth(15), STHeight(15), titleSize.width, STHeight(21));
//
//    _detailLabel.text = poi.address;
//    CGSize detailSize = [_titleLabel.text sizeWithMaxWidth:ScreenWidth-STWidth(30) font:STFont(15)];
//    _detailLabel.frame = CGRectMake(STWidth(15), STHeight(41), detailSize.width, STHeight(16));
//    
//    if(position == 0){
//        _lineView.frame = CGRectMake(STWidth(15),STHeight(51)-LineHeight , ScreenWidth - STWidth(30), LineHeight);
//        _selectImageView.frame = CGRectMake(ScreenWidth - STWidth(31), (STHeight(51) - STWidth(16))/2, STWidth(16), STWidth(16));
//        _detailLabel.hidden = YES;
//    }else{
//        _lineView.frame = CGRectMake(STWidth(15),STHeight(72)-LineHeight , ScreenWidth - STWidth(30), LineHeight);
//        _selectImageView.frame = CGRectMake(ScreenWidth - STWidth(31), (STHeight(72) - STWidth(16))/2, STWidth(16), STWidth(16));
//        _detailLabel.hidden = NO;
//    }
//    
//    if(model.isSelect){
//        _selectImageView.image = [UIImage imageNamed:IMAGE_ITEM_SELECT];
//    }else{
//        _selectImageView.image = [UIImage imageNamed:IMAGE_ITEM_NORMAL];
//    }
//}
//
//+(NSString *)identify{
//    return NSStringFromClass([LocationViewCell class]);
//}
//
//@end
//
