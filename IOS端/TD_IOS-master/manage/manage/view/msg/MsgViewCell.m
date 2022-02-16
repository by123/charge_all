//
//  MsgViewCell.m
//  manage
//
//  Created by by.huang on 2018/11/17.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MsgViewCell.h"
#import "STTimeUtil.h"


@interface MsgViewCell()

//消息标题
@property(strong, nonatomic)UILabel *titleLabel;
//消息内容
@property(strong, nonatomic)UILabel *contentLabel;
//消息时间
@property(strong, nonatomic)UILabel *timeLabel;


@end

@implementation MsgViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
   
    _titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [_titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:STFont(15)]];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_contentLabel];
    
    _timeLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c05 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_timeLabel];
    
   
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(70), STHeight(118), ScreenWidth - STWidth(85), LineHeight)];
    lineView.backgroundColor = cline;
    [self.contentView addSubview:lineView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(15), STWidth(36), STWidth(36))];
    imageView.image = [UIImage imageNamed:IMAGE_MSG_LIST];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
}

-(void)updateData:(MsgModel *)model{

    _titleLabel.text = model.title;
    CGSize titleSize = [_titleLabel.text sizeWithMaxWidth:STWidth(290) font:STFont(15) fontName:@"PingFangSC-Medium"];
    _titleLabel.frame = CGRectMake(STWidth(70), STHeight(15), titleSize.width, STHeight(21));
    
    _contentLabel.text = model.brief;
    CGSize contentSize = [_contentLabel.text sizeWithMaxWidth:STWidth(290) font:STFont(14)];
    _contentLabel.frame = CGRectMake(STWidth(70), STHeight(41), STWidth(284), STHeight(40));
    
    _timeLabel.text = [STTimeUtil generateDate: LongStr(model.publishTime) format:@"yyyy-MM-dd HH:mm:ss"];
    CGSize timeSize = [_timeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    _timeLabel.frame = CGRectMake(STWidth(70), STHeight(86), timeSize.width, STHeight(17));
    
}

+(NSString *)identify{
    return NSStringFromClass([MsgViewCell class]);
}

@end
