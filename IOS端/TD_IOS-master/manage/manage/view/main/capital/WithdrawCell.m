//
//  WithdrawCell.m
//  manage
//
//  Created by by.huang on 2018/12/6.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawCell.h"
#import "STTimeUtil.h"

@interface WithdrawCell()

//时间
@property(strong, nonatomic)UILabel *timeLabel;
//状态
@property(strong, nonatomic)UILabel *statuLabel;
//账户名称
@property(strong, nonatomic)UILabel *accountNameLabel;
//tx卡号
@property(strong, nonatomic)UILabel *cardNumLabel;
//tx金额
@property(strong, nonatomic)UILabel *withdrawMoneyLabel;
//手续费
@property(strong, nonatomic)UILabel *auxiliaryMoneyLabel;
//实际到账
@property(strong, nonatomic)UILabel *actualMoneyLabel;


@end

@implementation WithdrawCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), STHeight(223-31))];
    view.backgroundColor = cwhite;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowColor = c03.CGColor;
    [self.contentView addSubview:view];
    
    NSArray *datas = @[MSG_ACCOUNT_NAME,MSG_TX_CARD,MSG_TX_MONEY,MSG_SJDZ_MONEY];
    for(int i = 0 ; i < datas.count ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:datas[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(63) + STHeight(31) * i, titleSize.width, STHeight(21));
        [view addSubview:titleLabel];
    }
    
    _timeLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [view addSubview:_timeLabel];
    
    _statuLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [_statuLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    [view addSubview:_statuLabel];
    
    _accountNameLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_accountNameLabel];
    
    _cardNumLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_cardNumLabel];
    
    _withdrawMoneyLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_withdrawMoneyLabel];
    
//    _auxiliaryMoneyLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
//    [view addSubview:_auxiliaryMoneyLabel];
    
    _actualMoneyLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [view addSubview:_actualMoneyLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(51), STWidth(315), LineHeight)];
    lineView.backgroundColor = cline;
    [view addSubview:lineView];
    
}

-(void)updateData:(WithdrawDetailModel *)model{

    NSString *timeStr = [STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.createTime] format:@"yyyy-MM-dd"];
    CGSize timeSize = [timeStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _timeLabel.frame = CGRectMake(STWidth(15), STHeight(15), timeSize.width, STHeight(21));
    _timeLabel.text = timeStr;
    
    NSString *statuStr =[WithdrawDetailModel getStatuStr:model.withdrawState];
    CGSize statuSize = [statuStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _statuLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- statuSize.width, STHeight(15), statuSize.width, STHeight(21));
    _statuLabel.text = statuStr;
    
    _accountNameLabel.text = model.accountName;
    CGSize accountNameSize = [_accountNameLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _accountNameLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- accountNameSize.width, STHeight(63), accountNameSize.width, STHeight(21));
    
    if(model.isPublic == 2){
        _cardNumLabel.text = MSG_BK_WECHAT_TYPE;
    }else{
        _cardNumLabel.text = model.bankId;
    }
    CGSize cardNumSize = [_cardNumLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _cardNumLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- cardNumSize.width, STHeight(94), cardNumSize.width, STHeight(21));
    
    _withdrawMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.withdrawMoneyTotalYuan];
    CGSize withdrawMoneySize = [_withdrawMoneyLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _withdrawMoneyLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- withdrawMoneySize.width, STHeight(125), withdrawMoneySize.width, STHeight(21));
    
//    _auxiliaryMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.auxiliaryExpensesYuan];
//    CGSize auxiliaryMoneySize = [_auxiliaryMoneyLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
//    _auxiliaryMoneyLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- auxiliaryMoneySize.width, STHeight(156), auxiliaryMoneySize.width, STHeight(21));
    
    _actualMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.withdrawMoneyYuan];
    CGSize actualMoneySize = [_actualMoneyLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _actualMoneyLabel.frame = CGRectMake(STWidth(345) - STWidth(15)- actualMoneySize.width, STHeight(156), actualMoneySize.width, STHeight(21));
    
}

+(NSString *)identify{
    return NSStringFromClass([WithdrawCell class]);
}

@end



