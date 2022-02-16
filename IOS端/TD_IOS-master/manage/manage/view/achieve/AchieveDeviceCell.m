//
//  AchieveDeviceCell.m
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AchieveDeviceCell.h"
#import "STTimeUtil.h"

@interface AchieveDeviceCell()

//激活时间
@property(strong, nonatomic)UILabel *activeTimeLabel;
//激活数量
@property(strong, nonatomic)UILabel *activeCountLabel;
//商户名称
@property(strong, nonatomic)UILabel *nameLabel;


@end

@implementation AchieveDeviceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    NSArray *datas = @[@"激活时间",@"激活数量",@"商户名称"];
    for(int i = 0 ; i < datas.count ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:datas[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(15) + STHeight(31) * i, titleSize.width, STHeight(21));
        [self.contentView addSubview:titleLabel];
    }
    
    _activeTimeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_activeTimeLabel];
    
    _activeCountLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_activeCountLabel];
    
    _nameLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentRight textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_nameLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(113), ScreenWidth, STHeight(15))];
    lineView.backgroundColor = cbg;
    [self.contentView addSubview:lineView];
    
}

-(void)updateData:(DeviceModel *)model{
    NSString *timeStr = model.activeDate;
    CGSize timeSize = [timeStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _activeTimeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- timeSize.width, STHeight(15), timeSize.width, STHeight(21));
    _activeTimeLabel.text = timeStr;
    
    NSString *countStr = [NSString stringWithFormat:@"%d",model.count];
    CGSize countSize = [countStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _activeCountLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- countSize.width, STHeight(46), countSize.width, STHeight(21));
    _activeCountLabel.text = countStr;
    
    _nameLabel.text = model.mchName;
//    CGSize nameSize = [model.mchName sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _nameLabel.frame = CGRectMake(STWidth(100), STHeight(77), STWidth(260), STHeight(21));
    
    
}

+(NSString *)identify{
    return NSStringFromClass([AchieveDeviceCell class]);
}

@end



