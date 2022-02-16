//
//  AchieveContentCell.m
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AchieveMerchantCell.h"
#import "AccountModel.h"
#import "STTimeUtil.h"
#import "AccountManager.h"

@interface AchieveMerchantCell()

//商户类型
@property(strong, nonatomic)UILabel *typeLabel;
//名称
@property(strong, nonatomic)UILabel *nameLabel;
//关联业务员
@property(strong, nonatomic)UILabel *saleNameLabel;
//开通时间
@property(strong, nonatomic)UILabel *timeLabel;

@end

@implementation AchieveMerchantCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    NSArray *datas = @[@"代理商类型",@"代理商名称",@"关联业务员",@"开通时间"];
    for(int i = 0 ; i < 4 ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:datas[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(15) + STHeight(31) * i, titleSize.width, STHeight(21));
        [self.contentView addSubview:titleLabel];
    }
    
    _typeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_typeLabel];
    
    _nameLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentRight textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_nameLabel];
    
    _saleNameLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_saleNameLabel];
    
    _timeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_timeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(144), ScreenWidth, STHeight(15))];
    lineView.backgroundColor = cbg;
    [self.contentView addSubview:lineView];

}

-(void)updateData:(MerchantModel *)model{
    NSString *typeStr = [UserModel getMechantName:model.mchType level:model.level];
    CGSize typeSize = [typeStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _typeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- typeSize.width, STHeight(15), typeSize.width, STHeight(21));
    _typeLabel.text = typeStr;
    
    _nameLabel.text = model.mchName;
    CGSize nameSize = [model.mchName sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _nameLabel.frame = CGRectMake(ScreenWidth/3-STWidth(15), STHeight(46) + (STHeight(21) - nameSize.height)/2, ScreenWidth * 2/3, nameSize.height);

    if(IS_NS_STRING_EMPTY(model.salesName)){
        _saleNameLabel.text = @"未关联";
    }else{
        _saleNameLabel.text = model.salesName;
    }
    CGSize saleNameSize = [_saleNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _saleNameLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- saleNameSize.width, STHeight(77), saleNameSize.width, STHeight(21));

    
    NSString *timeStr = [STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.createTime] format:@"yyyy-MM-dd"];
    CGSize timeSize = [timeStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _timeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- timeSize.width, STHeight(108), timeSize.width, STHeight(21));
    _timeLabel.text = timeStr;

}

+(NSString *)identify{
    return NSStringFromClass([AchieveMerchantCell class]);
}

@end
