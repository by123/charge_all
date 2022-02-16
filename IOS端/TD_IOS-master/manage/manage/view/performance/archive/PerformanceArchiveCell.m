//
//  PerformanceArchiveCell.m
//  manage
//
//  Created by by.huang on 2019/7/1.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "PerformanceArchiveCell.h"
#import "STTimeUtil.h"

@interface PerformanceArchiveCell()

//时间
@property(strong, nonatomic)UILabel *timeLabel;
//状态
@property(strong, nonatomic)UILabel *statuLabel;
//收益金额
@property(strong, nonatomic)UILabel *profitLabel;
//设备分润收入
@property(strong, nonatomic)UILabel *profitOrderLabel;
//退款分润扣除
@property(strong, nonatomic)UILabel *profitRefundLabel;
//预计收益计提时间
@property(strong, nonatomic)UILabel *withdrawTimeLabel;

@end

@implementation PerformanceArchiveCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(187), ScreenWidth, STHeight(15))];
    view.backgroundColor = cbg;
    [self.contentView addSubview:view];
    
    self.contentView.backgroundColor = cwhite;
    
    NSArray *datas = @[@"收益金额",@"设备分润收入",@"扣款分润扣除",@"预计收益计提时间"];
    for(int i = 0 ; i < datas.count ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:datas[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(63) + STHeight(31) * i, titleSize.width, STHeight(21));
        [self.contentView addSubview:titleLabel];
    }
    
    _timeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_timeLabel];
    
    _statuLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [_statuLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    [self.contentView addSubview:_statuLabel];
    
    _profitLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_profitLabel];
    
    _profitOrderLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_profitOrderLabel];
    
    _profitRefundLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_profitRefundLabel];
    
    _withdrawTimeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_withdrawTimeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(50), STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [self.contentView addSubview:lineView];
    
}

-(void)updateData:(PerformanceArchiveModel *)model{
    
    
    NSString *timeStr = [STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.profitDate] format:@"yyyy-MM-dd"];
    CGSize timeSize = [timeStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _timeLabel.frame = CGRectMake(STWidth(15), STHeight(15), timeSize.width, STHeight(21));
    _timeLabel.text = timeStr;
    
    NSString *statuStr;
    if(model.canWithDrawDate > [[STTimeUtil getCurrentTimeStamp] longLongValue]){
        statuStr = MSG_NOT_TX;
    }else{
        statuStr = MSG_CAN_TX;
    }
    _statuLabel.text = statuStr;
    CGSize statuSize = [statuStr sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_MIDDLE];
    _statuLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- statuSize.width, STHeight(15), statuSize.width, STHeight(21));
    
    _profitLabel.text = [NSString stringWithFormat:@"%.2f元",model.profitOrderYuan - model.profitRefundYuan];
    CGSize profitSize = [_profitLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _profitLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- profitSize.width, STHeight(63), profitSize.width, STHeight(21));
    
    _profitOrderLabel.text = [NSString stringWithFormat:@"%.2f元",model.profitOrderYuan];
    CGSize profitOrderSize = [_profitOrderLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _profitOrderLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- profitOrderSize.width, STHeight(94), profitOrderSize.width, STHeight(21));
    
    _profitRefundLabel.text = [NSString stringWithFormat:@"%.2f元",model.profitRefundYuan];
    CGSize profitRefundSize = [_profitRefundLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _profitRefundLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- profitRefundSize.width, STHeight(125), profitRefundSize.width, STHeight(21));
    
    _withdrawTimeLabel.text = [STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.canWithDrawDate] format:@"yyyy-MM-dd"];
    CGSize withdrawTimeSize = [_withdrawTimeLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _withdrawTimeLabel.frame = CGRectMake(ScreenWidth - STWidth(15)- withdrawTimeSize.width, STHeight(156), withdrawTimeSize.width, STHeight(21));
    
}

+(NSString *)identify{
    return NSStringFromClass([PerformanceArchiveCell class]);
}

@end



