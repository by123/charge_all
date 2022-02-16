//
//  PerformanceMerchantSubCell.m
//  manage
//
//  Created by by.huang on 2019/6/21.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "PerformanceMerchantSubACell.h"
#import "AccountModel.h"
#import "STTimeUtil.h"
#import "AccountManager.h"

@interface PerformanceMerchantSubACell()

//商户类型
@property(strong, nonatomic)UILabel *typeLabel;
//名称
@property(strong, nonatomic)UILabel *nameLabel;
//拓展代理数量
@property(strong, nonatomic)UILabel *agentCountLabel;
//拓展商户数量
@property(strong, nonatomic)UILabel *merchantCountLabel;

@property(strong, nonatomic)UIButton *detailBtn;
@property(strong, nonatomic)UIImageView *detailImageView;

@end

@implementation PerformanceMerchantSubACell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    NSArray *datas = @[@"代理商名称",@"代理商类型",@"拓展代理数量",@"拓展商户数量"];
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
    
    _agentCountLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_agentCountLabel];
    
    _merchantCountLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_merchantCountLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [self.contentView addSubview:lineView];
    
    _detailBtn = [[UIButton alloc]initWithFont:STFont(14) text:@"查看更多" textColor:c11 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    CGSize detailSize = [_detailBtn.titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _detailBtn.frame = CGRectMake(ScreenWidth - STWidth(21) - detailSize.width-STHeight(12), STHeight(135), detailSize.width, STHeight(20));
    _detailBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:_detailBtn];
    
    UIImageView *detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(16) - STHeight(12), STHeight(139), STHeight(12), STHeight(12))];
    detailImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:detailImageView];
}

-(void)updateData:(PerformanceMerchantModel *)model{
   
    _nameLabel.text = model.mchName;
    CGSize nameSize = [_nameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _nameLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- nameSize.width, STHeight(15), nameSize.width, nameSize.height);
    
    _typeLabel.text = [UserModel getMechantName:model.mchType level:model.level];
    CGSize typeSize = [_typeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _typeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- typeSize.width, STHeight(45), typeSize.width, STHeight(20));
    
    _agentCountLabel.text = IntStr(model.agentCount);
    CGSize agentCountSize = [_agentCountLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _agentCountLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- agentCountSize.width, STHeight(75), agentCountSize.width, STHeight(20));
    
    _merchantCountLabel.text = IntStr(model.tenantCount);
    CGSize merchantCountSize = [_merchantCountLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _merchantCountLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- merchantCountSize.width, STHeight(105), merchantCountSize.width, STHeight(20));
    
    _detailBtn.hidden = (model.mchType == 1);
    _detailImageView.hidden = (model.mchType == 1);
    
}

+(NSString *)identify{
    return NSStringFromClass([PerformanceMerchantSubACell class]);
}

@end
