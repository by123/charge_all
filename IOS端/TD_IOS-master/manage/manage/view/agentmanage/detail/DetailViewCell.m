//
//  DetailViewCell.m
//  manage
//
//  Created by by.huang on 2019/1/11.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "DetailViewCell.h"
#import "ZScrollLabel.h"

@interface DetailViewCell()

@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)ZScrollLabel *contentLabel;
@property(strong, nonatomic)UIView *lineView;

@end


@implementation DetailViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [self addSubview:_titleLabel];
    
    
    _contentLabel = [[ZScrollLabel alloc] initWithFrame:CGRectMake(ScreenWidth/3-STWidth(15), (STHeight(50) - STHeight(21))/2, ScreenWidth*2/3, STHeight(21))];
    _contentLabel.textColor = c10;
    _contentLabel.labelAlignment = ZScrollLabelAlignmentRight;
    _contentLabel.font = [UIFont systemFontOfSize:STFont(15)];
    [self addSubview:_contentLabel];

   
    _lineView = [[UIView alloc]init];
    _lineView.frame = CGRectMake(STWidth(15), STHeight(50)-LineHeight, STWidth(345), LineHeight);
    _lineView.backgroundColor = cline;
    [self addSubview:_lineView];
    
}

-(void)updateData:(TitleContentModel *)model lineHidden:(Boolean)lineHidden{
    
    _titleLabel.text =model.title;
    CGSize titleSize = [model.title sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _titleLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(50));
    
    _contentLabel.text =model.content;
    
    _lineView.hidden = lineHidden;
    
}

+(NSString *)identify{
    return NSStringFromClass([DetailViewCell class]);
}


@end
