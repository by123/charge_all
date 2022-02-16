//
//  CapitalDetailProfitCell.m
//  manage
//
//  Created by by.huang on 2019/1/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "CapitalDetailProfitCell.h"

@interface CapitalDetailProfitCell()

@property(strong, nonatomic)UILabel *mchNameLabel;
@property(strong, nonatomic)UILabel *refundLabel;
@property(strong, nonatomic)UILabel *profitLabel;

@end

@implementation CapitalDetailProfitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    _mchNameLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_mchNameLabel];
    
    _refundLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_refundLabel];
    
    _profitLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_profitLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(75)-LineHeight, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [self.contentView addSubview:lineView];
    
}


-(void)updateData:(CapitalDetailModel *)model{
    _mchNameLabel.text = model.mchName;
    CGSize mchNameSize = [_mchNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _mchNameLabel.frame = CGRectMake(STWidth(15), STHeight(15), mchNameSize.width, STHeight(20));
    
    NSString *refundStr = [NSString stringWithFormat:@"退款扣除 %.2f元",model.refundProfitForParentYuan];
    NSMutableAttributedString *refundAttrStr=[[NSMutableAttributedString alloc]initWithString:refundStr];
    NSRange range1=[[refundAttrStr string]rangeOfString:@"退款扣除 "];
    [refundAttrStr addAttribute:NSForegroundColorAttributeName value:c11 range:range1];
    _refundLabel.attributedText=refundAttrStr;
    CGSize refundSize = [_refundLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _refundLabel.frame = CGRectMake(STWidth(15), STHeight(45), refundSize.width, STHeight(21));
    
    NSString *profitStr = [NSString stringWithFormat:@"我的收益 %.2f元",model.profitForParentYuan];
    NSMutableAttributedString *profitAttrStr=[[NSMutableAttributedString alloc]initWithString:profitStr];
    NSRange profitRange=[[profitAttrStr string]rangeOfString:@"我的收益 "];
    [profitAttrStr addAttribute:NSForegroundColorAttributeName value:c11 range:profitRange];
    _profitLabel.attributedText=profitAttrStr;
    CGSize profitSize = [_profitLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _profitLabel.frame = CGRectMake(ScreenWidth - STWidth(15) - profitSize.width, STHeight(45), profitSize.width, STHeight(21));
    
}

+(NSString *)identify{
    return NSStringFromClass([CapitalDetailProfitCell class]);
}

@end
