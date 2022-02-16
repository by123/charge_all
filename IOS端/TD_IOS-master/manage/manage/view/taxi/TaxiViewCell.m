

#import "TaxiViewCell.h"

@interface TaxiViewCell()

@property(strong, nonatomic)UILabel *groupNameLabel;

@property(strong, nonatomic)UILabel *profitLabel;
@property(strong, nonatomic)UILabel *ruleLabel;
@property(strong, nonatomic)UILabel *salemanLabel;


@property(strong, nonatomic)UILabel *deviceCountLabel;
@property(strong, nonatomic)UILabel *activeCountLabel;
@property(strong, nonatomic)UILabel *driverCountLabel;

@end

@implementation TaxiViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    
    UIImageView *taxiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(22), STHeight(20), STHeight(20))];
    taxiImageView.image = [UIImage imageNamed:IMAGE_CAR_TEAM];
    taxiImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:taxiImageView];
    
    _groupNameLabel = [[UILabel alloc]initWithFont:STFont(17) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [_groupNameLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(17)]];
    [self.contentView addSubview:_groupNameLabel];
    
    [self initCardView];
    
    
    NSArray *titles = @[MSG_TAXI_PERCENT,MSG_TAXI_RULE,MSG_TAXI_SALEMAN];
    for(int i = 0; i < titles.count ; i++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:titles[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(162) + STHeight(31) * i, titleSize.width, STHeight(21));
        [self addSubview:titleLabel];
    }
    
    _profitLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_profitLabel];
    
    _ruleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_ruleLabel];
    
    _salemanLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_salemanLabel];
    
    
    _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(280), STHeight(22), STWidth(95), STHeight(21))];
    [self.contentView addSubview:_moreBtn];
    
    
    UILabel *addDeviceLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_UPDATE textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize addDeviceSie = [addDeviceLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    addDeviceLabel.frame = CGRectMake(STWidth(95)- STWidth(36) - addDeviceSie.width, 0, addDeviceSie.width, STHeight(21));
    [_moreBtn addSubview:addDeviceLabel];
    
    UIImageView *addDeviceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(95)- STWidth(28),  STHeight(4), STWidth(13), STWidth(13))];
    addDeviceImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    addDeviceImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_moreBtn addSubview:addDeviceImageView];
    
    
    _addDeviceBtn = [[UIButton alloc]initWithFont:STFont(16) text:MSG_TITLE_ADD_DEVICE textColor:c10 backgroundColor:cwhite corner:2 borderWidth:LineHeight borderColor:c10];
    _addDeviceBtn.frame = CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(265), STWidth(100), STHeight(38));
    [self.contentView addSubview:_addDeviceBtn];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(323), ScreenWidth, STHeight(15))];
    view.backgroundColor = cbg;
    [self.contentView addSubview:view];

}


-(void)initCardView{
    UIView *cardView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(54), STWidth(345), STHeight(93))];
    cardView.backgroundColor = cwhite;
    cardView.layer.shadowOffset = CGSizeMake(1, 1);
    cardView.layer.shadowOpacity = 0.8;
    cardView.layer.shadowColor = c03.CGColor;
    cardView.layer.cornerRadius = 2;
    [self.contentView addSubview:cardView];
    
    NSArray *titles = @[MSG_TAXI_DEVICE_TOTAL,MSG_TAXI_ACTIVE_TOTAL,MSG_TAXI_DRIVE_TOTAL];
    for(int i = 0; i < titles.count ; i++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(14) text:titles[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        titleLabel.frame = CGRectMake(STWidth(115) * i, STHeight(50), STWidth(115), STHeight(21));
        [cardView addSubview:titleLabel];
        
        if(i != 0){
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(i * STWidth(115)-LineHeight, STHeight(30), LineHeight, STHeight(33))];
            lineView.backgroundColor = cline;
            [cardView addSubview:lineView];
        }
    }
    
    _deviceCountLabel = [[UILabel alloc]initWithFont:STFont(20) text:@"0" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    _deviceCountLabel.frame = CGRectMake(0, STHeight(22), STWidth(115), STHeight(28));
    [cardView addSubview:_deviceCountLabel];
    
    _activeCountLabel = [[UILabel alloc]initWithFont:STFont(20) text:@"0" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    _activeCountLabel.frame = CGRectMake(STWidth(115), STHeight(22), STWidth(115), STHeight(28));
    [cardView addSubview:_activeCountLabel];
    
    _driverCountLabel = [[UILabel alloc]initWithFont:STFont(20) text:@"0" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    _driverCountLabel.frame = CGRectMake(STWidth(230), STHeight(22), STWidth(115), STHeight(28));
    [cardView addSubview:_driverCountLabel];
    

    
}
-(void)updateData:(GroupModel *)model{
    
    _groupNameLabel.text = model.groupName;
    CGSize nameSize = [_groupNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(17) fontName:FONT_MIDDLE];
    _groupNameLabel.frame = CGRectMake(STWidth(44), STHeight(20), nameSize.width, STHeight(24));
    
    
    _profitLabel.text = [NSString stringWithFormat:@"%.2f%%",model.profitPercentTaxi];
    CGSize profitSize = [_profitLabel.text sizeWithMaxWidth:STWidth(345) font:STFont(15)];
    _profitLabel.frame = CGRectMake(ScreenWidth - STWidth(30) - profitSize.width, STHeight(162), profitSize.width, STHeight(21));
    
    NSMutableArray *scales = [STConvertUtil jsonToDic:model.service];
    if(!IS_NS_COLLECTION_EMPTY(scales)){
        NSDictionary *dic = [scales objectAtIndex:0];
        NSString *price = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"price"] doubleValue] / 100];
        NSString *time = IntStr([[dic objectForKey:@"time"] intValue] / 60);
        _ruleLabel.text = [NSString stringWithFormat:@"%@元%@小时",price,time];
        CGSize ruleSize = [_ruleLabel.text sizeWithMaxWidth:STWidth(345) font:STFont(15)];
        _ruleLabel.frame = CGRectMake(ScreenWidth - STWidth(30) - ruleSize.width, STHeight(162+31), ruleSize.width, STHeight(21));
    }
   
    _salemanLabel.text = model.salesName;
    CGSize salemanSize = [_salemanLabel.text sizeWithMaxWidth:STWidth(345) font:STFont(15)];
    _salemanLabel.frame = CGRectMake(ScreenWidth - STWidth(30) - salemanSize.width, STHeight(162 + 62), salemanSize.width, STHeight(21));
    
    _deviceCountLabel.text = IntStr(model.deviceTotal);
    _activeCountLabel.text = IntStr(model.deviceTotalActive);
    _driverCountLabel.text = IntStr(model.taxiNum);

    
}

+(NSString *)identify{
    return NSStringFromClass([TaxiViewCell class]);
}

@end

