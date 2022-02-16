//
//  SettingViewCell.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "SettingViewCell.h"



@interface SettingViewCell()

@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UIView *lineView;

@end


@implementation SettingViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self addSubview:_titleLabel];
    
    
    UIImageView *arrowImageView = [[UIImageView alloc]init];
    arrowImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    arrowImageView.frame = CGRectMake(ScreenWidth - STWidth(23), (STHeight(50) - STWidth(12))/2, STWidth(8), STWidth(12));
    [self addSubview:arrowImageView];
    
    _lineView = [[UIView alloc]init];
    _lineView.frame = CGRectMake(STWidth(15), STHeight(50)-LineHeight, STWidth(345), LineHeight);
    _lineView.backgroundColor = cline;
    [self addSubview:_lineView];
    
}

-(void)updateData:(NSString *)title line:(Boolean)line{
    
    _titleLabel.text =title;
    CGSize titleSize = [title sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _titleLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(50));
    
    _lineView.hidden = line;
    
}

+(NSString *)identify{
    return NSStringFromClass([SettingViewCell class]);
}


@end
