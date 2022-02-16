//
//  CapitalProfitCell.m
//  manage
//
//  Created by by.huang on 2019/1/16.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "CapitalProfitCell.h"

#import "STTimeUtil.h"

@interface CapitalProfitCell()

//时间
@property(strong, nonatomic)UILabel *timeLabel;

//收益金额
@property(strong, nonatomic)UILabel *profitLabel;


@end

@implementation CapitalProfitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    
    _timeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [self addSubview:_timeLabel];
   
    _profitLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self addSubview:_profitLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(15)-STWidth(12.4), (STHeight(52.5) - STWidth(12.4))/2, STWidth(12.4), STWidth(12.4))];
    arrowImageView.image = [UIImage imageNamed:IMAGE_DARK_NEXT];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(52.5)-LineHeight, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [self addSubview:lineView];
    
}

-(void)updateData:(ProfitModel *)model{
    
    NSString *timeStr = [STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.profitDate] format:@"MM-dd"];
    CGSize timeSize = [timeStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _timeLabel.frame = CGRectMake(STWidth(15), 0, timeSize.width, STHeight(52.5));
    _timeLabel.text = timeStr;
    
    
    _profitLabel.text = [NSString stringWithFormat:@"%.2f元",model.profitOrderYuan - model.profitRefundYuan];
    CGSize profitSize = [_profitLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _profitLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- profitSize.width - STWidth(12.4) - STWidth(8), 0, profitSize.width, STHeight(52.5));
    
    
}

+(NSString *)identify{
    return NSStringFromClass([CapitalProfitCell class]);
}

@end

