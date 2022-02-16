//
//  OrderCell.m
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderCell.h"
#import "STTimeUtil.h"
#import "STLineDashView.h"

@interface OrderCell()

//时间
@property(strong, nonatomic)UILabel *timeLabel;
//状态
@property(strong, nonatomic)UILabel *statuLabel;
//订单编号
@property(strong, nonatomic)UILabel *orderIdLabel;
//设备编号
@property(strong, nonatomic)UILabel *deviceIdLabel;
//商户名称
@property(strong, nonatomic)UILabel *merchantLabel;
//待支付金额
@property(strong, nonatomic)UILabel *waitPayLabel;
//下级收益
@property(strong, nonatomic)UILabel *nextProfitLabel;
//我的收益
@property(strong, nonatomic)UILabel *myProfitLabel;
//待支付
@property(strong, nonatomic)UILabel *waitPayTitleLabel;


@end

@implementation OrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    
    self.contentView.backgroundColor = cbg;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), STHeight(282))];
    view.backgroundColor = cwhite;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowColor = c03.CGColor;
    [self.contentView addSubview:view];
    
    _timeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [view addSubview:_timeLabel];
    
    _statuLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_statuLabel];
    
    UILabel *orderIdTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"订单编号" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize orderIdSize = [orderIdTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    orderIdTitleLabel.frame = CGRectMake(STWidth(15), STHeight(58), orderIdSize.width, STHeight(21));
    [view addSubview:orderIdTitleLabel];
    
    _orderIdLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_orderIdLabel];
    
    UILabel *deviceTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"设备编号" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize deviceSize = [deviceTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    deviceTitleLabel.frame = CGRectMake(STWidth(15), STHeight(89), deviceSize.width, STHeight(21));
    [view addSubview:deviceTitleLabel];
    
    _deviceIdLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_deviceIdLabel];
    
    UILabel *merchantTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"商户名称" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize merchantSize = [merchantTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    merchantTitleLabel.frame = CGRectMake(STWidth(15), STHeight(120), merchantSize.width, STHeight(21));
    [view addSubview:merchantTitleLabel];
    
    _merchantLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentRight textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_merchantLabel];
    
    _waitPayTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"待支付金额" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize waitPaySize = [_waitPayTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _waitPayTitleLabel.frame = CGRectMake(STWidth(15), STHeight(163), waitPaySize.width, STHeight(21));
    [view addSubview:_waitPayTitleLabel];
    
    _waitPayLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_waitPayLabel];
    
    UILabel *nextProfitTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"下级收益" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize nextProfitSize = [merchantTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    nextProfitTitleLabel.frame = CGRectMake(STWidth(15), STHeight(194), nextProfitSize.width, STHeight(21));
    [view addSubview:nextProfitTitleLabel];
    
    _nextProfitLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_nextProfitLabel];
    
    UILabel *myProfitTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"我的收益" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize myProfitSize = [myProfitTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    myProfitTitleLabel.frame = CGRectMake(STWidth(15), STHeight(239), myProfitSize.width, STHeight(21));
    [view addSubview:myProfitTitleLabel];
    
    _myProfitLabel = [[UILabel alloc]initWithFont:STFont(30) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_myProfitLabel];
    
    UILabel *myProfitUnitLabel  = [[UILabel alloc]initWithFont:STFont(15) text:@"元" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    myProfitUnitLabel.frame = CGRectMake(STWidth(345) - STWidth(30), STHeight(235), STWidth(15), STHeight(21));
    [view addSubview:myProfitUnitLabel];
    
    for(int i = 0 ; i < 2 ; i++){
        STLineDashView *lineView = [[STLineDashView alloc] initWithFrame:CGRectMake(STWidth(15), STHeight(46) + STHeight(105) * i, STWidth(315), LineHeight)
                                                  lineDashPattern:@[@2, @2]
                                                        endOffset:0.495];
        lineView.backgroundColor = cline;
        [view addSubview:lineView];
    }
    
    CGFloat radius = STWidth(20);
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(5), STHeight(36), radius, radius)];
    leftView.backgroundColor = cbg;
    leftView.layer.masksToBounds = YES;
    leftView.layer.cornerRadius = STWidth(10);
    [self.contentView addSubview:leftView];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(25), STHeight(36), radius, radius)];
    rightView.backgroundColor = cbg;
    rightView.layer.masksToBounds = YES;
    rightView.layer.cornerRadius = STWidth(10);
    [self.contentView addSubview:rightView];
}

-(void)updateData:(OrderModel *)model{
    
    [self setOrderTitle:model];
    [self setOrderStatu:model];
    
    NSString *timeStr = [STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.payTime] format:MSG_TIME_FORMAT];
    CGSize timeSize = [timeStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _timeLabel.frame = CGRectMake(STWidth(15), 0, timeSize.width, STHeight(46));
    _timeLabel.text = timeStr;


    _orderIdLabel.text = model.orderId;
    CGSize orderSize = [_orderIdLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _orderIdLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- orderSize.width, STHeight(58), orderSize.width, STHeight(21));

    _deviceIdLabel.text = model.deviceSn;
    CGSize deviceSize = [_deviceIdLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _deviceIdLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- deviceSize.width, STHeight(89), deviceSize.width, STHeight(21));

    NSString *mchName = model.mchName;
    if(!IS_NS_STRING_EMPTY(model.taxiDriverName) && !IS_NS_STRING_EMPTY(model.taxiDriverPhone)){
        mchName = [NSString stringWithFormat:@"%@%@(出租车)",model.taxiDriverName,model.taxiDriverPhone];
    }
    _merchantLabel.text = mchName;
    _merchantLabel.frame = CGRectMake(STWidth(100), STHeight(120),STWidth(230), STHeight(21));

    if(model.orderStateWeb == OrderType_Refunding){
        _waitPayLabel.text = [NSString stringWithFormat:@"%.2f元",model.refundingMoneyYuan];
    }else if(model.orderStateWeb == OrderType_Refunded){
        _waitPayLabel.text = [NSString stringWithFormat:@"%.2f元",model.refundMoneyYuan];
    }else{
        _waitPayLabel.text = [NSString stringWithFormat:@"%.2f元",model.orderPriceYuan];
    }
    CGSize waitPayeSize = [_waitPayLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _waitPayLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- waitPayeSize.width, STHeight(163), waitPayeSize.width, STHeight(21));
    
    _nextProfitLabel.text = [NSString stringWithFormat:@"%.2f元",model.descendantsTotalProfit];
    CGSize nextProfitSize = [_nextProfitLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _nextProfitLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- nextProfitSize.width, STHeight(194), nextProfitSize.width, STHeight(21));
    
    _myProfitLabel.text = [NSString stringWithFormat:@"%.2f",model.myProfit];
    CGSize myProfitSize = [_myProfitLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(30)];
    _myProfitLabel.frame = CGRectMake(STWidth(345) - STWidth(35)- myProfitSize.width, STHeight(223), myProfitSize.width, STHeight(42));
    
}

-(void)setOrderTitle:(OrderModel *)model{
    NSString *titleStr;
    if(model.orderStateWeb == OrderType_WaitPay || model.orderStateWeb == OrderType_Cancel){
        titleStr = @"待支付金额";
    }else if(model.orderStateWeb == OrderType_Refunding || model.orderStateWeb == OrderType_Refunded){
        titleStr = @"退款金额";
    }
    _waitPayTitleLabel.text = titleStr;
    CGSize waitPaySize = [_waitPayTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _waitPayTitleLabel.frame = CGRectMake(STWidth(15), STHeight(163), waitPaySize.width, STHeight(21));
}

-(void)setOrderStatu:(OrderModel *)model{
    NSString *statuStr;
    if(model.orderStateWeb == OrderType_WaitPay){
        statuStr =@"待支付";
    }else if(model.orderStateWeb == OrderType_Cancel){
        statuStr =@"已取消";
    }else if(model.orderStateWeb == OrderType_Refunding){
        statuStr =@"退款中";
    }else if(model.orderStateWeb == OrderType_Refunded){
        statuStr =@"退款完成";
    }
    CGSize statuSize = [statuStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _statuLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- statuSize.width, 0, statuSize.width, STHeight(46));
    _statuLabel.text = statuStr;
}

+(NSString *)identify{
    return NSStringFromClass([OrderCell class]);
}


@end

