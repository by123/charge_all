//
//  PerformanceMerchantSubCell.m
//  manage
//
//  Created by by.huang on 2019/6/21.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "PerformanceMerchantSubMCell.h"
#import "AccountModel.h"
#import "STTimeUtil.h"
#import "AccountManager.h"

@interface PerformanceMerchantSubMCell()

//商户类型
@property(strong, nonatomic)UILabel *typeLabel;
//名称
@property(strong, nonatomic)UILabel *nameLabel;
//设备数
@property(strong, nonatomic)UILabel *deviceLabel;
//开通日期
@property(strong, nonatomic)UILabel *createTimeLabel;

@end

@implementation PerformanceMerchantSubMCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    NSArray *datas = @[@"代理商名称",@"代理商类型",@"设备数",@"开通时间"];
    for(int i = 0 ; i < 4 ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(14) text:datas[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(15) + STHeight(31) * i, titleSize.width, STHeight(20));
        [self.contentView addSubview:titleLabel];
    }
    
    _nameBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*2/3, 0, ScreenWidth/3, STHeight(45))];
    [self.contentView addSubview:_nameBtn];
    
    _nameLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentRight textColor:c12 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_nameLabel];
    
    
    _typeLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_typeLabel];
    
    _deviceLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_deviceLabel];
    
    _createTimeLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_createTimeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [self.contentView addSubview:lineView];

    
}

-(void)updateData:(PerformanceMerchantModel *)model{
    
    _nameLabel.text = model.mchName;
    CGSize nameSize = [_nameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _nameLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- nameSize.width , STHeight(15), nameSize.width, nameSize.height);
    
    _typeLabel.text = [UserModel getMechantName:model.mchType level:model.level];
    CGSize typeSize = [_typeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _typeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- typeSize.width, STHeight(45), typeSize.width, STHeight(20));
    
    _deviceLabel.text = IntStr(model.deviceCount);
    CGSize deviceSize = [_deviceLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _deviceLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- deviceSize.width, STHeight(75), deviceSize.width, STHeight(20));
    
    _createTimeLabel.text = [STTimeUtil generateDate:LongStr(model.createTime) format:@"yyyy-MM-dd"];
    CGSize createTimeSize = [_createTimeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _createTimeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- createTimeSize.width, STHeight(105), createTimeSize.width, STHeight(20));
    
    
}

+(NSString *)identify{
    return NSStringFromClass([PerformanceMerchantSubMCell class]);
}

@end
