//
//  AgentManageViewCell.m
//  manage
//
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AgentManageViewCell.h"
#import "AccountModel.h"
#import "STTimeUtil.h"
#import "AccountManager.h"

@interface AgentManageViewCell()

//商户类型
@property(strong, nonatomic)UILabel *typeLabel;
//名称
@property(strong, nonatomic)UILabel *nameLabel;
//代理商账号
@property(strong, nonatomic)UILabel *accountLabel;
//联系人
@property(strong, nonatomic)UILabel *contactUserLabel;


@end

@implementation AgentManageViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    
    UIView *bodyView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), STHeight(144))];
    bodyView.backgroundColor = cwhite;
    bodyView.layer.shadowOffset = CGSizeMake(1, 1);
    bodyView.layer.shadowOpacity = 0.8;
    bodyView.layer.shadowColor = c03.CGColor;
    [self.contentView addSubview:bodyView];
    
    NSArray *datas = @[@"代理商类型",@"代理商名称",@"代理商账号",@"联系人"];
    for(int i = 0 ; i < 4 ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:datas[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(15) + STHeight(31) * i, titleSize.width, STHeight(21));
        [bodyView addSubview:titleLabel];
    }
    
    _typeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentRight textColor:c10 backgroundColor:nil multiLine:NO];
    [bodyView addSubview:_typeLabel];
    
    _nameLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentRight textColor:c10 backgroundColor:nil multiLine:NO];
    [bodyView addSubview:_nameLabel];
    
    _accountLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentRight textColor:c10 backgroundColor:nil multiLine:NO];
    [bodyView addSubview:_accountLabel];
    
    _contactUserLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentRight textColor:c10 backgroundColor:nil multiLine:NO];
    [bodyView addSubview:_contactUserLabel];
    
    
    
}

-(void)updateData:(MerchantModel *)model{
    NSString *typeStr = [UserModel getMechantName:model.mchType level:model.level];
    CGSize typeSize = [typeStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _typeLabel.frame = CGRectMake(STWidth(100), STHeight(15) + (STHeight(21) - typeSize.height)/2, STWidth(230), typeSize.height);
    _typeLabel.text = typeStr;
    
    _nameLabel.text = model.mchName;
    CGSize nameSize = [model.mchName sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _nameLabel.frame = CGRectMake(STWidth(100), STHeight(46) + (STHeight(21) - nameSize.height)/2, STWidth(230), nameSize.height);
    
    
    NSString *accountStr = model.mchId;
    CGSize accountSize = [accountStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _accountLabel.frame = CGRectMake(STWidth(100), STHeight(77) + (STHeight(21) - accountSize.height)/2, STWidth(230), accountSize.height);
    _accountLabel.text = accountStr;
    
    if(IS_NS_STRING_EMPTY(model.contactUser)){
        _contactUserLabel.text = @"未关联";
    }else{
        _contactUserLabel.text = model.contactUser;
    }
    CGSize contactUserSize = [_contactUserLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _contactUserLabel.frame = CGRectMake(STWidth(100), STHeight(108) + (STHeight(21) - contactUserSize.height)/2, STWidth(230), contactUserSize.height);
    
}

+(NSString *)identify{
    return NSStringFromClass([AgentManageViewCell class]);
}

@end
