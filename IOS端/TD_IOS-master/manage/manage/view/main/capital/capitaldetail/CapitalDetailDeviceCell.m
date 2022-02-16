//
//  CapitalDetailDeviceCell.m
//  manage
//
//  Created by by.huang on 2019/1/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "CapitalDetailDeviceCell.h"

@interface CapitalDetailDeviceCell()

@property(strong, nonatomic)UILabel *mchNameLabel;
@property(strong, nonatomic)UILabel *deviceActiveNumLabel;
@property(strong, nonatomic)UILabel *orderNumLabel;
@property(strong, nonatomic)UILabel *orderLabel;

@end

@implementation CapitalDetailDeviceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    _mchNameLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_mchNameLabel];
    
    UILabel *title1 = [[UILabel alloc]initWithFont:STFont(15) text:@"激活设备数" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize title1Size = [title1.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    title1.frame = CGRectMake(STWidth(15), STHeight(40),title1Size.width , STHeight(21));
    [self.contentView addSubview:title1];
    
    _deviceActiveNumLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_deviceActiveNumLabel];
    
    UILabel *title2 = [[UILabel alloc]initWithFont:STFont(15) text:@"订单数" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize title2Size = [title2.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    title2.frame = CGRectMake((ScreenWidth - title2Size.width ) /2, STHeight(40),title2Size.width , STHeight(21));
    [self.contentView addSubview:title2];
    
    _orderNumLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_orderNumLabel];
    
    UILabel *title3 = [[UILabel alloc]initWithFont:STFont(15) text:@"订单金额" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize title3Size = [title3.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    title3.frame = CGRectMake(ScreenWidth - STWidth(15) - title3Size.width, STHeight(40),title3Size.width , STHeight(21));
    [self.contentView addSubview:title3];
    
    _orderLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_orderLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(97)-LineHeight, STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [self.contentView addSubview:lineView];
    
}


-(void)updateData:(CapitalDetailModel *)model{
    _mchNameLabel.text = model.mchName;
    CGSize mchNameSize = [_mchNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _mchNameLabel.frame = CGRectMake(STWidth(15), STHeight(15), mchNameSize.width, STHeight(20));
    
    CGSize tempSize = [@"激活设备数" sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _deviceActiveNumLabel.text = [NSString stringWithFormat:@"%d",model.activeDeviceTotalNum];
    CGSize deviceActiveSize = [_mchNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _deviceActiveNumLabel.frame = CGRectMake(STWidth(15) + tempSize.width/2 - deviceActiveSize.width/2, STHeight(61), deviceActiveSize.width, STHeight(21));
    
    _orderNumLabel.text = [NSString stringWithFormat:@"%d",model.orderNum];
    CGSize orderNumSize = [_orderNumLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _orderNumLabel.frame = CGRectMake(ScreenWidth /2 - orderNumSize.width/2, STHeight(61), orderNumSize.width, STHeight(21));
    
    CGSize temp2Size = [@"订单金额" sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _orderLabel.text = [NSString stringWithFormat:@"%.2f元",model.orderServiceNumYuan];
    CGSize orderSize = [_orderLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _orderLabel.frame = CGRectMake(ScreenWidth - STWidth(15) - temp2Size.width/2 - orderSize.width/2, STHeight(61), orderSize.width, STHeight(21));
    
}

+(NSString *)identify{
    return NSStringFromClass([CapitalDetailDeviceCell class]);
}

@end
