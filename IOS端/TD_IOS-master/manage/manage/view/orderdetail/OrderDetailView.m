//
//  OrderDetailView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderDetailView.h"
#import "STTimeUtil.h"
#import "ZScrollLabel.h"
#import "AccountManager.h"

@interface OrderDetailView()

@property(strong, nonatomic)OrderDetailViewModel *mViewModel;
@property(strong, nonatomic)UIScrollView *scrollView;

@property(strong, nonatomic)UILabel *orderIdLabel;

@end

@implementation OrderDetailView

-(instancetype)initWithViewModel:(OrderDetailViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = cbg;
    
    
}


-(void)buildCardView:(NSString *)mainTitle title:(NSString *)titleStr subs:(NSArray *)subs datas:(NSArray *)datas height:(CGFloat)height{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), height, STWidth(345), STHeight(68) + subs.count * STHeight(31))];
    view.backgroundColor = cwhite;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowColor = c03.CGColor;
    view.layer.cornerRadius = 2;
    [_scrollView addSubview:view];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(51), STWidth(315), LineHeight)];
    lineView.backgroundColor = cline;
    [view addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:mainTitle textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_MIDDLE];
    titleLabel.frame = CGRectMake(STWidth(15), STHeight(15), titleSize.width, STHeight(21));
    [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    [view addSubview:titleLabel];
    
    _orderIdLabel = [[UILabel alloc]initWithFont:STFont(15) text:titleStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize orderSize = [_orderIdLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _orderIdLabel.frame = CGRectMake(STWidth(330) - orderSize.width, STHeight(15), orderSize.width, STHeight(21));
    [view addSubview:_orderIdLabel];
    
     for(int i= 0 ; i < subs.count ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:subs[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(63) + STHeight(31) * i, titleSize.width, STHeight(21));
        [view addSubview:titleLabel];
        
         
         ZScrollLabel *contentLabel = [[ZScrollLabel alloc] initWithFrame:CGRectMake(STWidth(100), STHeight(63) + STHeight(31) * i, STWidth(230), STHeight(21))];
         contentLabel.textColor = c10;
         contentLabel.labelAlignment = ZScrollLabelAlignmentRight;
         contentLabel.font = [UIFont systemFontOfSize:STFont(15)];
         contentLabel.text = datas[i];
        [view addSubview:contentLabel];
    }
}


-(void)updateView{
    if(_scrollView != nil){
        [_scrollView removeFromSuperview];
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];

    switch (_mViewModel.model.orderStateWeb) {
        case OrderType_WaitPay:
        case OrderType_Cancel:
            [self addWaitAndCancel];
            break;
        case OrderType_Paid:
            [self addPaid];
            break;
        case OrderType_Completed:
            [self addCompeleted];
            break;
        case OrderType_Refunding:
        case OrderType_Refunded:
            [self addRefundingAndRefunded];
            break;
        default:
            break;
    }
}



//待支付
-(void)addWaitAndCancel{
    [self buildCardView:@"订单编号"
                  title:_mViewModel.orderId
                   subs: @[@"订单状态",@"下单时间",@"用户昵称"]
                  datas:@[[OrderDetailModel getOrderStatu:_mViewModel.model.orderStateWeb],
                          _mViewModel.model.createTime,
                          _mViewModel.model.userName
                          ]
                 height:STHeight(10)];
    
    [self buildCardView:@"分润信息"
                  title:MSG_EMPTY
                   subs:@[@"分润信息"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.myProfilt]]
                 height:STHeight(185)];
    
    [self buildCardView:@"交易信息"
                  title:MSG_EMPTY
                   subs:@[@"待支付金额"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.orderPriceYuan]]
                 height:STHeight(299)];
    
    
    if(IS_NS_STRING_EMPTY(_mViewModel.model.groupName)){
        [self buildCardView:@"设备信息"
                      title:MSG_EMPTY
                       subs:@[@"设备编号",@"所属商户",@"使用位置"]
                      datas:@[_mViewModel.model.deviceSn,
                              [self getMchName],
                              (IS_NS_STRING_EMPTY(_mViewModel.model.location) ? @"无" : _mViewModel.model.location)]
                     height:STHeight(413)];
    }else{
        [self buildCardView:@"设备信息"
                      title:MSG_EMPTY
                       subs:@[@"设备编号",@"所属商户",@"分组名称",@"使用位置"]
                      datas:@[_mViewModel.model.deviceSn,
                              [self getMchName],
                              [self getGroupName],
                              (IS_NS_STRING_EMPTY(_mViewModel.model.location) ? @"无" : _mViewModel.model.location)]
                     height:STHeight(413)];
    }

    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(620+31))];

}


//已支付
-(void)addPaid{
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    CGFloat height = 0;
    if(model.mchType  == 2){
        height = STHeight(31);
        [self buildCardView:@"订单编号"
                      title:_mViewModel.orderId
                       subs: @[@"订单状态",@"下单时间",@"订单密码",@"用户昵称",@"充电开始时间"]
                      datas:@[[OrderDetailModel getOrderStatu:_mViewModel.model.orderStateWeb],
                              _mViewModel.model.createTime,
                               _mViewModel.model.pwd,
                              _mViewModel.model.userName,
                              _mViewModel.model.startTime
                              ]
                     height:STHeight(10)];
    }else{
        [self buildCardView:@"订单编号"
                      title:_mViewModel.orderId
                       subs: @[@"订单状态",@"下单时间",@"用户昵称",@"充电开始时间"]
                      datas:@[[OrderDetailModel getOrderStatu:_mViewModel.model.orderStateWeb],
                              _mViewModel.model.createTime,
                              _mViewModel.model.userName,
                              _mViewModel.model.startTime
                              ]
                     height:STHeight(10)];
    }
    
    [self buildCardView:@"分润信息"
                  title:MSG_EMPTY
                   subs:@[@"我的收益",@"下级收益"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.myProfilt],
                          [NSString stringWithFormat:@"%.2f元",_mViewModel.model.descendantsTotalProfit]]
                 height:STHeight(216+height)];
    
    [self buildCardView:@"交易信息"
                  title:MSG_EMPTY
                   subs:@[@"订单金额",@"支付时间",@"支付方式",@"支付流水"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.orderPriceYuan],
                          _mViewModel.model.platformPayTime,
                          ((_mViewModel.model.payType == 0) ? @"微信支付" : @"支付宝支付"),
                          (IS_NS_STRING_EMPTY(_mViewModel.model.transactionId) ? @"无" : _mViewModel.model.transactionId)]
                 height:STHeight(325+31+height)];
    
    [self buildCardView:@"押金信息"
                  title:MSG_EMPTY
                   subs:@[@"设备押金",@"押金状态"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.depositPriceYuan],
                          _mViewModel.model.refundDepositState]
                 height:STHeight(527+31+height)];
    
    if(IS_NS_STRING_EMPTY(_mViewModel.model.groupName)){
        [self buildCardView:@"设备信息"
                      title:MSG_EMPTY
                       subs:@[@"设备编号",@"所属商户",@"使用位置"]
                      datas:@[_mViewModel.model.deviceSn,
                              [self getMchName],
                              (IS_NS_STRING_EMPTY(_mViewModel.model.location) ? @"无" : _mViewModel.model.location)]
                     height:STHeight(667+31+height)];
    }else{
        [self buildCardView:@"设备信息"
                      title:MSG_EMPTY
                       subs:@[@"设备编号",@"所属商户",@"分组名称",@"使用位置"]
                      datas:@[_mViewModel.model.deviceSn,
                              [self getMchName],
                              [self getGroupName],
                              (IS_NS_STRING_EMPTY(_mViewModel.model.location) ? @"无" : _mViewModel.model.location)]
                     height:STHeight(667+31+height)];
    }
    
    UIButton *refundBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"退款" textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    [refundBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    refundBtn.frame = CGRectMake(ScreenWidth/4, STHeight(1007+31+31)-STHeight(100), ScreenWidth/2, STHeight(50));
    [refundBtn addTarget:self action:@selector(onRefundClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:refundBtn];
    refundBtn.hidden = !_mViewModel.model.canRefund;
    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(1007+31+31))];
    
}



//已完成
-(void)addCompeleted{
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    CGFloat height = 0;
    if(model.mchType  == 2){
        height = STHeight(31);
        [self buildCardView:@"订单编号"
                      title:_mViewModel.orderId
                       subs: @[@"订单状态",@"订单时间",@"订单密码",@"用户昵称",@"充电开始时间",@"充电结束时间"]
                      datas:@[[OrderDetailModel getOrderStatu:_mViewModel.model.orderStateWeb],
                              _mViewModel.model.createTime,
                              _mViewModel.model.pwd,
                              _mViewModel.model.userName,
                              _mViewModel.model.startTime,
                              _mViewModel.model.actualEndTime]
                     height:STHeight(10)];
    }else{
        [self buildCardView:@"订单编号"
                      title:_mViewModel.orderId
                       subs: @[@"订单状态",@"订单时间",@"用户昵称",@"充电开始时间",@"充电结束时间"]
                      datas:@[[OrderDetailModel getOrderStatu:_mViewModel.model.orderStateWeb],
                              _mViewModel.model.createTime,
                              _mViewModel.model.userName,
                              _mViewModel.model.startTime,
                              _mViewModel.model.actualEndTime]
                     height:STHeight(10)];
    }
    
    [self buildCardView:@"分润信息"
                  title:MSG_EMPTY
                   subs:@[@"我的收益",@"下级收益"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.myProfilt],
                          [NSString stringWithFormat:@"%.2f元",_mViewModel.model.descendantsTotalProfit]]
                 height:STHeight(247+height)];
    
    [self buildCardView:@"交易信息"
                  title:MSG_EMPTY
                   subs:@[@"订单金额",@"支付时间",@"支付方式",@"支付流水"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.orderPriceYuan],
                          _mViewModel.model.platformPayTime,
                          ((_mViewModel.model.payType == 0) ? @"微信支付" : @"支付宝支付"),
                          (IS_NS_STRING_EMPTY(_mViewModel.model.transactionId) ? @"无" : _mViewModel.model.transactionId)]
                 height:STHeight(356+31+height)];
    
    [self buildCardView:@"押金信息"
                  title:MSG_EMPTY
                   subs:@[@"设备押金",@"押金状态",@"押金退款时间",@"押金退款方式",@"押金退款流水"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.depositPriceYuan],
                          _mViewModel.model.refundDepositState,
                          _mViewModel.model.refundDepositTime,
                          @"原路返回",
                          _mViewModel.model.refundDepositId]
                 height:STHeight(558+31+height)];
    if(IS_NS_STRING_EMPTY(_mViewModel.model.groupName)){
        [self buildCardView:@"设备信息"
                      title:MSG_EMPTY
                       subs:@[@"设备编号",@"所属商户",@"使用位置"]
                      datas:@[_mViewModel.model.deviceSn,
                              [self getMchName],
                              (IS_NS_STRING_EMPTY(_mViewModel.model.location) ? @"无" : _mViewModel.model.location)]
                     height:STHeight(791+31+height)];
    }
    else{
        [self buildCardView:@"设备信息"
                      title:MSG_EMPTY
                       subs:@[@"设备编号",@"所属商户",@"分组名称",@"使用位置"]
                      datas:@[_mViewModel.model.deviceSn,
                              [self getMchName],
                              [self getGroupName],
                              (IS_NS_STRING_EMPTY(_mViewModel.model.location) ? @"无" : _mViewModel.model.location)]
                     height:STHeight(791+31+height)];
    }
    
    
    UIButton *refundBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"退款" textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    [refundBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    refundBtn.frame = CGRectMake(ScreenWidth/4, STHeight(1193)-STHeight(100), ScreenWidth/2, STHeight(50));
    [refundBtn addTarget:self action:@selector(onRefundClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:refundBtn];
    refundBtn.hidden = !_mViewModel.model.canRefund;
    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(1193))];
}


-(void)onRefundClick{
    if(_mViewModel){
        [_mViewModel goRefundPage:_mViewModel.model];
    }
}


//退款中和已退款
-(void)addRefundingAndRefunded{
    UserModel *model = [[AccountManager sharedAccountManager] getUserModel];
    CGFloat height = 0;
    if(model.mchType  == 2){
        height = STHeight(31);
        [self buildCardView:@"订单编号"
                      title:_mViewModel.orderId
                       subs: @[@"订单状态",@"订单时间",@"订单密码",@"用户昵称",@"充电开始时间",@"充电结束时间"]
                      datas:@[[OrderDetailModel getOrderStatu:_mViewModel.model.orderStateWeb],
                              _mViewModel.model.createTime,
                              _mViewModel.model.pwd,
                              _mViewModel.model.userName,
                              _mViewModel.model.startTime,
                              _mViewModel.model.actualEndTime
                              ]
                     height:STHeight(10)];
    }else{
        [self buildCardView:@"订单编号"
                      title:_mViewModel.orderId
                       subs: @[@"订单状态",@"订单时间",@"用户昵称",@"充电开始时间",@"充电结束时间"]
                      datas:@[[OrderDetailModel getOrderStatu:_mViewModel.model.orderStateWeb],
                              _mViewModel.model.createTime,
                              _mViewModel.model.userName,
                              _mViewModel.model.startTime,
                              _mViewModel.model.actualEndTime
                              ]
                     height:STHeight(10)];
    }
    
    [self buildCardView:@"分润信息"
                  title:MSG_EMPTY
                   subs:@[@"我的收益",@"下级收益"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.myProfilt],
                          [NSString stringWithFormat:@"%.2f元",_mViewModel.model.descendantsTotalProfit]]
                 height:STHeight(247+height)];
    
    [self buildCardView:@"交易信息"
                  title:MSG_EMPTY
                   subs:@[@"订单金额",@"支付时间",@"支付方式",@"支付流水"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.orderPriceYuan],
                          _mViewModel.model.platformPayTime,
                          ((_mViewModel.model.payType == 0) ? @"微信支付" : @"支付宝支付"),
                          (IS_NS_STRING_EMPTY(_mViewModel.model.transactionId) ? @"无" : _mViewModel.model.transactionId)]
                 height:STHeight(356+31+height)];
    
    [self buildCardView:@"押金信息"
                  title:MSG_EMPTY
                   subs:@[@"设备押金",@"押金状态",@"押金退款时间",@"押金退款方式",@"押金退款流水"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.depositPriceYuan],
                          _mViewModel.model.refundDepositState,
                           _mViewModel.model.refundDepositTime,
                          @"原路返回",
                          _mViewModel.model.refundDepositId]
                 height:STHeight(558+31+height)];
    
    [self buildCardView:@"退款信息"
                  title:MSG_EMPTY
                   subs:@[@"退款金额",@"退款时间",@"退款方式",@"退款流水",@"发起退款账号",@"退款原因"]
                  datas:@[[NSString stringWithFormat:@"%.2f元",_mViewModel.model.refundMoneyYuan],
                          _mViewModel.model.refundTime,
                          @"原路返回",
                          _mViewModel.model.refundId,
                          [NSString stringWithFormat:@"%@/%@",_mViewModel.model.refundOperatorId,_mViewModel.model.refundOperatorName],
                          _mViewModel.model.refundReason]
                 height:STHeight(791+31+height)];
    
    if(IS_NS_STRING_EMPTY(_mViewModel.model.groupName)){
        [self buildCardView:@"设备信息"
                      title:MSG_EMPTY
                       subs:@[@"设备编号",@"所属商户",@"使用位置"]
                      datas:@[_mViewModel.model.deviceSn,[self getMchName],
                              (IS_NS_STRING_EMPTY(_mViewModel.model.location) ? @"无" : _mViewModel.model.location)]
                     height:STHeight(993+62+31+height)];
    }else{
        [self buildCardView:@"设备信息"
                      title:MSG_EMPTY
                       subs:@[@"设备编号",@"所属商户",@"分组名称",@"使用位置"]
                      datas:@[_mViewModel.model.deviceSn,[self getMchName],
                              [self getGroupName],
                              (IS_NS_STRING_EMPTY(_mViewModel.model.location) ? @"无" : _mViewModel.model.location)]
                     height:STHeight(993+62+31+height)];
    }

    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(1195+62+62+height))];
}


-(NSString *)getMchName{
    NSString *mchName = _mViewModel.model.mchName;
    if(!IS_NS_STRING_EMPTY(_mViewModel.model.taxiDriverName) && !IS_NS_STRING_EMPTY(_mViewModel.model.taxiDriverPhone)){
        mchName = [NSString stringWithFormat:@"%@%@(出租车)",_mViewModel.model.taxiDriverName,_mViewModel.model.taxiDriverPhone];
    }
    return mchName;
}

-(NSString *)getGroupName{
    return (IS_NS_STRING_EMPTY(_mViewModel.model.groupName) ? @"无" : _mViewModel.model.groupName);
}

@end

