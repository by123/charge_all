//
//  BankDetailViewCell.m
//  manage
//
//  Created by by.huang on 2018/12/4.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BankDetailViewCell.h"


@interface BankDetailViewCell()

@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UILabel *contentLabel;

@end


@implementation BankDetailViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [self addSubview:_titleLabel];
    
    
    _contentLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self addSubview:_contentLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(STWidth(15), STHeight(50)-LineHeight, STWidth(345), LineHeight);
    lineView.backgroundColor = cline;
    [self addSubview:lineView];
    
}

-(void)updateData:(TitleContentModel *)model{
    
    _titleLabel.text =model.title;
    CGSize titleSize = [model.title sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _titleLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(50));
    
    _contentLabel.text =model.content;
    CGSize contentSize = [model.content sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _contentLabel.frame = CGRectMake(ScreenWidth - STWidth(15) - contentSize.width, 0, contentSize.width, STHeight(50));
    
}

+(NSString *)identify{
    return NSStringFromClass([BankDetailViewCell class]);
}


@end
