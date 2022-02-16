//
//  PerformanceActiveCell.m
//  manage
//
//  Created by by.huang on 2019/6/19.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "PerformanceActiveCell.h"
#import "AccountModel.h"
#import "STTimeUtil.h"
#import "AccountManager.h"

@interface PerformanceActiveCell()



//名称
@property(strong, nonatomic)UILabel *nameLabel;
//商户类型
@property(strong, nonatomic)UILabel *typeLabel;
//联系人姓名
@property(strong, nonatomic)UILabel *contactNameLabel;
//激活设备数
@property(strong, nonatomic)UILabel *activeCountLabel;
//查看详情
@property(strong, nonatomic)UIButton *detailBtn;

@property(strong, nonatomic)UIImageView *detailImageView;

@end

@implementation PerformanceActiveCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    NSArray *datas = @[@"代理商名称",@"代理商类型",@"联系人姓名",@"激活设备数"];
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
    
    _contactNameLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_contactNameLabel];
    
    _activeCountLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_activeCountLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [self.contentView addSubview:lineView];
    
    _detailBtn = [[UIButton alloc]initWithFont:STFont(14) text:@"查看更多" textColor:c11 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    _detailBtn.userInteractionEnabled = NO;
    CGSize detailSize = [_detailBtn.titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _detailBtn.frame = CGRectMake(ScreenWidth - STWidth(21) - detailSize.width-STHeight(12), STHeight(135), detailSize.width, STHeight(20));
    [self addSubview:_detailBtn];
    
    _detailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(16) - STHeight(12), STHeight(139), STHeight(12), STHeight(12))];
    _detailImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    _detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_detailImageView];
    
}

-(void)updateData:(PerformanceActiveModel *)model{
    
    _nameLabel.text = model.mchName;
    CGSize nameSize = [_nameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _nameLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- nameSize.width, STHeight(15), nameSize.width, nameSize.height);
    
    _typeLabel.text = [UserModel getMechantName:model.mchType level:model.level];
    CGSize typeSize = [_typeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _typeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- typeSize.width, STHeight(45), typeSize.width, STHeight(20));
    
    _contactNameLabel.text = model.contactUser;
    CGSize saleNameSize = [_contactNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _contactNameLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- saleNameSize.width, STHeight(75), saleNameSize.width, STHeight(20));
    
    _activeCountLabel.text = IntStr(model.activeNum);
    CGSize merchantCountSize = [_activeCountLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _activeCountLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- merchantCountSize.width, STHeight(105), merchantCountSize.width, STHeight(20));
    
    _detailBtn.hidden = (model.mchType == 1);
    _detailImageView.hidden = (model.mchType == 1);
    
}

+(NSString *)identify{
    return NSStringFromClass([PerformanceActiveCell class]);
}

@end
