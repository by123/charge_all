//
//  PerformanceMerchantCell.m
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "PerformanceMerchantCell.h"
#import "AccountModel.h"
#import "STTimeUtil.h"
#import "AccountManager.h"

@interface PerformanceMerchantCell()

//商户类型
@property(strong, nonatomic)UILabel *typeLabel;
//名称
@property(strong, nonatomic)UILabel *nameLabel;
//联系人姓名
@property(strong, nonatomic)UILabel *contactLabel;
//开通日期
@property(strong, nonatomic)UILabel *createTimeLabel;
//关联业务员
@property(strong, nonatomic)UILabel *salesNameLabel;

@property(strong, nonatomic)UIButton *detailBtn;
@property(strong, nonatomic)UIImageView *detailImageView;

@end

@implementation PerformanceMerchantCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    NSArray *datas = @[@"代理商名称",@"代理商类型",@"联系人",@"开通日期",@"关联业务员"];
    for(int i = 0 ; i < 5 ; i ++){
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
    
    _contactLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_contactLabel];
    
    _createTimeLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_createTimeLabel];
    
    _salesNameLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_salesNameLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [self.contentView addSubview:lineView];
    
    _detailBtn = [[UIButton alloc]initWithFont:STFont(14) text:@"查看更多" textColor:c11 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    CGSize detailSize = [_detailBtn.titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _detailBtn.frame = CGRectMake(ScreenWidth - STWidth(21) - detailSize.width - STHeight(12), STHeight(165), detailSize.width, STHeight(20));
    _detailBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_detailBtn];
    
    _detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(16) - STHeight(12), STHeight(169), STHeight(12), STHeight(12))];
    _detailImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    _detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_detailImageView];
    
}

-(void)updateData:(PerformanceMerchantModel *)model{
    
    
    _nameLabel.text = model.mchName;
    CGSize nameSize = [_nameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _nameLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- nameSize.width, STHeight(15), nameSize.width, nameSize.height);
    
    _typeLabel.text = [UserModel getMechantName:model.mchType level:model.level];
    CGSize typeSize = [_typeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _typeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- typeSize.width, STHeight(45), typeSize.width, STHeight(20));
    
    _contactLabel.text = model.contactUser;
    CGSize contactSize = [_contactLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _contactLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- contactSize.width, STHeight(75), contactSize.width, STHeight(20));
    
    _createTimeLabel.text = [STTimeUtil generateDate:LongStr(model.createTime) format:@"yyyy-MM-dd HH:mm:ss"];
    CGSize createTimeSize = [_createTimeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _createTimeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- createTimeSize.width, STHeight(105), createTimeSize.width, STHeight(20));
    
    _salesNameLabel.text = model.salesName;
    CGSize saleNameSize = [_salesNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _salesNameLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- saleNameSize.width, STHeight(135), saleNameSize.width, STHeight(20));
    
    
    _detailBtn.hidden = (model.mchType == 1);
    _detailImageView.hidden = (model.mchType == 1);
    
}

+(NSString *)identify{
    return NSStringFromClass([PerformanceMerchantCell class]);
}

@end
