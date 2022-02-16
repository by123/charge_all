//
//  MineCell.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "MineCell.h"

@interface MineCell()

@property(strong, nonatomic)UILabel *menuLabel;
@property(strong, nonatomic)UIImageView *menuImageView;

@end


@implementation MineCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _menuLabel = [[UILabel alloc]initWithFont:STFont(16) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self addSubview:_menuLabel];
    
    _menuImageView = [[UIImageView alloc]init];
    _menuImageView.contentMode = UIViewContentModeScaleAspectFill;
    _menuImageView.frame = CGRectMake(STWidth(15), STHeight(21), STWidth(20), STWidth(20));
    [self addSubview:_menuImageView];
    
    
    UIImageView *arrowImageView = [[UIImageView alloc]init];
    arrowImageView.image = [UIImage imageNamed:IMAGE_DARK_NEXT];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    arrowImageView.frame = CGRectMake(ScreenWidth - STWidth(23), STHeight(25), STWidth(8), STHeight(12));
    [self addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(STWidth(15), STHeight(62)-LineHeight, STWidth(345), LineHeight);
    lineView.backgroundColor = cline;
    [self addSubview:lineView];
    
}

-(void)updateData:(NSString *)title imgSrc:(NSString *)imgSrc{

    _menuLabel.text =title;
    CGSize menuSize = [title sizeWithMaxWidth:ScreenWidth font:STFont(16)];
    _menuLabel.frame = CGRectMake(STWidth(45), 0, menuSize.width, STHeight(62));
    
    _menuImageView.image = [UIImage imageNamed:imgSrc];
}

+(NSString *)identify{
    return NSStringFromClass([MineCell class]);
}


@end
