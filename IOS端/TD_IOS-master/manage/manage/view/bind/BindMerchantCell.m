//
//  BindMerchantCell.m
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BindMerchantCell.h"
@interface BindMerchantCell()

@property(strong, nonatomic)UILabel *nameLabel;
@property(strong, nonatomic)UIImageView *selectImageView;

@end

@implementation BindMerchantCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    _nameLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [self addSubview:_nameLabel];
    
    _selectImageView = [[UIImageView alloc]init];
    _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    _selectImageView.image = [UIImage imageNamed:IMAGE_SELECT_NOAMAL];
    _selectImageView.frame = CGRectMake(ScreenWidth -  STWidth(35), (STHeight(60) - STWidth(20))/2, STWidth(20), STWidth(20));
    [self addSubview:_selectImageView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(STWidth(15), STHeight(60)-LineHeight, STWidth(345), LineHeight);
    lineView.backgroundColor = cline;
    [self addSubview:lineView];
    
}


-(void)updateData:(MerchantModel *)model{
    _nameLabel.text = model.mchName;
    CGSize nameSize = [_nameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _nameLabel.frame = CGRectMake(STWidth(15), 0, nameSize.width, STHeight(60));
    if(model.isSelected){
        _selectImageView.image = [UIImage imageNamed:IMAGE_SELECT_ALL];
    }else{
        _selectImageView.image = [UIImage imageNamed:IMAGE_SELECT_NOAMAL];
    }
    
   
}

+(NSString *)identify{
    return NSStringFromClass([BindMerchantCell class]);
}

@end
