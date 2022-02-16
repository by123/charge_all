//
//  AccountCell.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AccountCell.h"

@interface AccountCell()

@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UILabel *contentLabel;

@end


@implementation AccountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [self addSubview:_titleLabel];
    

    _contentLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentRight textColor:c10 backgroundColor:nil multiLine:YES];
    [self addSubview:_contentLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(STWidth(15), STHeight(52)-LineHeight, STWidth(345), LineHeight);
    lineView.backgroundColor = cline;
    [self addSubview:lineView];
    
}

-(void)updateData:(TitleContentModel *)model{
    
    _titleLabel.text =model.title;
    CGSize titleSize = [model.title sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _titleLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(52));
    
    _contentLabel.text =model.content;
    CGSize contentSize = [model.content sizeWithMaxWidth:ScreenWidth*2/3 font:STFont(15)];
    _contentLabel.frame = CGRectMake(ScreenWidth/3-STWidth(15), (STHeight(52) - contentSize.height)/2, ScreenWidth*2/3, contentSize.height);
    
}

+(NSString *)identify{
    return NSStringFromClass([AccountCell class]);
}


@end
