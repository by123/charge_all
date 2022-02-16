//
//  RefundView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "RefundView.h"
#import "UITextView+Placeholder.h"
#import "STSinglePickerLayerView.h"
@interface RefundView()<UITextViewDelegate,UITextFieldDelegate,STSinglePickerLayerViewDelegate>

@property(strong, nonatomic)RefundViewModel *mViewModel;

//
@property(strong, nonatomic)UILabel *orderIdLabel;
@property(strong, nonatomic)UILabel *payLabel;
@property(strong, nonatomic)UILabel *depositLabel;
//
@property(strong, nonatomic)UITextField *refundField;
@property(strong, nonatomic)UITextView *reasonTextView;

@property(strong, nonatomic)UIView *contentView;
@property(strong, nonatomic)UILabel *refundReasonLabel;
@property(strong, nonatomic)STSinglePickerLayerView *layerView;
@property(strong, nonatomic)UIView *part3View;
@property(strong, nonatomic)UIView *refundLineView;

@end

@implementation RefundView{
    NSInteger selectPosition;
}

-(instancetype)initWithViewModel:(RefundViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        selectPosition = -1;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _contentView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight)];
    [self addSubview:_contentView];
    
    [self initPart1];
    [self initPart2];
    [self initPart3];
    
    UIButton *refundBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"确定" textColor:c10 backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    [refundBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    refundBtn.frame = CGRectMake(0, ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [refundBtn addTarget:self action:@selector(onRefundClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refundBtn];
    
    [self updateRefundReason];
}

-(void)initPart1{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(10), STWidth(345), STHeight(113))];
    view.backgroundColor = cwhite;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowColor = c03.CGColor;
    view.layer.cornerRadius = 2;
    [_contentView addSubview:view];

    NSArray *titles = @[@"订单编号",@"订单金额",@"设备押金"];
    for(int i= 0 ; i < titles.count ; i ++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:titles[i] textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(15) + STHeight(31) * i, titleSize.width, STHeight(21));
        [view addSubview:titleLabel];
    }
    
    
    _orderIdLabel = [[UILabel alloc]initWithFont:STFont(15) text:_mViewModel.model.orderId textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize orderIdSize = [_orderIdLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _orderIdLabel.frame = CGRectMake(STWidth(330) - orderIdSize.width, STHeight(15), orderIdSize.width, STHeight(21));
    [view addSubview:_orderIdLabel];
    
    _payLabel = [[UILabel alloc]initWithFont:STFont(15) text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.orderPriceYuan] textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize paySize = [_payLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _payLabel.frame = CGRectMake(STWidth(330) - paySize.width, STHeight(46), paySize.width, STHeight(21));
    [view addSubview:_payLabel];
    
    _depositLabel = [[UILabel alloc]initWithFont:STFont(15) text:[NSString stringWithFormat:@"%.2f元",_mViewModel.model.depositPriceYuan] textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize depositSize = [_depositLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _depositLabel.frame = CGRectMake(STWidth(330) - depositSize.width, STHeight(77), depositSize.width, STHeight(21));
    [view addSubview:_depositLabel];
    
}


-(void)initPart2{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(138), STWidth(345), STHeight(99))];
    view.backgroundColor = cwhite;
    view.layer.shadowOffset = CGSizeMake(1, 1);
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowColor = c03.CGColor;
    view.layer.cornerRadius = 2;
    [_contentView addSubview:view];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(51), STWidth(315), LineHeight)];
    lineView.backgroundColor = cline;
    [view addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"退款操作" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_MIDDLE];
    titleLabel.frame = CGRectMake(STWidth(15), STHeight(15), titleSize.width, STHeight(21));
    [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    [view addSubview:titleLabel];
    
    UILabel *refundTitleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"退款金额" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize refundTitleSize = [refundTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    refundTitleLabel.frame = CGRectMake(STWidth(15), STHeight(63), refundTitleSize.width, STHeight(21));
    [view addSubview:refundTitleLabel];
    
    _refundField = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
    _refundField.textAlignment = NSTextAlignmentRight;
    _refundField.keyboardType = UIKeyboardTypeDecimalPad;
    _refundField.delegate = self;
    [_refundField setPlaceholder:@"请输入退款金额" color:c03 fontSize:STFont(15)];
    _refundField.frame = CGRectMake(STWidth(130), STHeight(51), STWidth(200), STHeight(46));
    [_refundField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:_refundField];
    
    UIImageView *tipsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(250), STWidth(14), STWidth(14))];
    tipsImageView.image = [UIImage imageNamed:IMAGE_TIPS];
    tipsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_contentView addSubview:tipsImageView];
    
    double maxValue= _mViewModel.model.orderPriceYuan - _mViewModel.model.depositPriceYuan;
    UILabel *tipsLabel = [[UILabel alloc]initWithFont:STFont(14) text:[NSString stringWithFormat:@"最大退款金额为%.2f元",maxValue] textAlignment:NSTextAlignmentLeft textColor:c05 backgroundColor:nil multiLine:YES];
    CGSize tipsSize = [tipsLabel.text sizeWithMaxWidth:STWidth(325) font:STFont(14)];
    tipsLabel.frame = CGRectMake(STWidth(34), STHeight(250), STWidth(325), tipsSize.height);
    [_contentView addSubview:tipsLabel];
    
}

-(void)initPart3{
    _part3View = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(302), STWidth(345), STHeight(50))];
    _part3View.backgroundColor = cwhite;
    _part3View.layer.shadowOffset = CGSizeMake(1, 1);
    _part3View.layer.shadowOpacity = 0.8;
    _part3View.layer.shadowColor = c03.CGColor;
    _part3View.layer.cornerRadius = 2;
    [_contentView addSubview:_part3View];
    

    
    _refundLineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(51), STWidth(315), LineHeight)];
    _refundLineView.backgroundColor = cline;
    _refundLineView.hidden = YES;
    [_part3View addSubview:_refundLineView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"退款原因" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:cclear multiLine:NO];
    CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_MIDDLE];
    titleLabel.frame = CGRectMake(STWidth(15), STHeight(15), titleSize.width, STHeight(21));
    [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    [_part3View addSubview:titleLabel];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(110), 0, STWidth(235),STHeight(50))];
    [button addTarget:self action:@selector(onSelectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_part3View addSubview:button];
    
    _refundReasonLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"请选择退款原因" textAlignment:NSTextAlignmentCenter textColor:c03 backgroundColor:nil multiLine:NO];
    CGSize contentSize = [_refundReasonLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _refundReasonLabel.frame = CGRectMake(STWidth(345) - STWidth(34) - contentSize.width, 0, contentSize.width, STHeight(50));
    [_part3View addSubview:_refundReasonLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(345) - STWidth(28), (STHeight(50) - STWidth(13))/2, STWidth(13), STWidth(13))];
    arrowImageView.image = [UIImage imageNamed:IMAGE_REFRESH];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_part3View addSubview:arrowImageView];
    
    
    _reasonTextView = [[UITextView alloc]init];
    _reasonTextView.font = [UIFont systemFontOfSize:STFont(15)];
    _reasonTextView.delegate = self;
    _reasonTextView.hidden = YES;
    [_reasonTextView setPlaceholder:@"请输入您的退款原因" placeholdColor:c03];
    _reasonTextView.frame = CGRectMake(STWidth(15), STHeight(63), STWidth(315), STHeight(122));
    [_part3View addSubview:_reasonTextView];

}
    
-(void)onSelectBtnClick{
    _layerView.hidden = NO;
}
    
-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView position:(NSInteger)position{
    selectPosition = position;
    _refundReasonLabel.text = result;
    _refundReasonLabel.textColor = c10;
    CGSize contentSize = [_refundReasonLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _refundReasonLabel.frame = CGRectMake(STWidth(345) - STWidth(34) - contentSize.width, 0, contentSize.width, STHeight(50));
    _layerView.hidden = YES;

    WS(weakSelf)
    if(position == [_layerView getDatas].count - 1){
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.part3View.frame = CGRectMake(STWidth(15), STHeight(302), STWidth(345), STHeight(195));
            weakSelf.refundLineView.hidden = NO;
            weakSelf.reasonTextView.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.part3View.frame = CGRectMake(STWidth(15), STHeight(302), STWidth(345), STHeight(50));
            weakSelf.refundLineView.hidden = YES;
            weakSelf.reasonTextView.hidden = YES;
        }];
    }
}
    
-(void)updateRefundReason{
    
    id result = [STUserDefaults getKeyValue:CONFIG_REFUND_REASON];
    if(result){
        RespondModel *model = [[RespondModel alloc]init];
        model.requestUrl = CONFIG_REFUND_REASON;
        NSMutableArray *datas = [NSMutableArray mj_objectArrayWithKeyValuesArray:result];
        NSMutableArray *reasons = [[NSMutableArray alloc]init];
        for(NSDictionary *dic in datas){
            [reasons addObject:[dic objectForKey:@"title"]];
        }
        _layerView = [[STSinglePickerLayerView alloc]initWithDatas:reasons];
        _layerView.delegate = self;
        _layerView.hidden = YES;
        [self addSubview:_layerView];
    }
    

}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"开始编辑");
    WS(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.frame = CGRectMake(0, -250, ScreenWidth, ContentHeight);
    }];
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    WS(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_refundField resignFirstResponder];
    [_reasonTextView resignFirstResponder];
}


-(void)onRefundClick{
    if(selectPosition == -1){
        [LCProgressHUD showMessage:@"请选择一种退款原因"];
        return;
    }
    if(_mViewModel){
        NSString *reasonStr;
        if(selectPosition == ([_layerView getDatas].count - 1)){
            reasonStr = _reasonTextView.text;
        }else{
            reasonStr =  [[_layerView getDatas] objectAtIndex:selectPosition];
        }
        [_mViewModel requestRefund:reasonStr refundMoney:_refundField.text];
    }
}

-(void)updateView{
    
}

- (void)textFieldDidChange:(UITextField *)textField{
    NSString *content = textField.text;
    if([content containsString:@"."]){
        NSArray *datas = [content componentsSeparatedByString:@"."];
        NSString *intValue = datas[0];
        NSString *pointValue = datas[1];
        if(pointValue.length > 2){
            pointValue = [pointValue substringWithRange:NSMakeRange(0, 2)];
        }
        textField.text = [NSString stringWithFormat:@"%@.%@",intValue,pointValue];
    }
    if(!IS_NS_STRING_EMPTY(content)){
        double value = [content doubleValue];
        double maxValue= _mViewModel.model.orderPriceYuan - _mViewModel.model.depositPriceYuan;
        if(value  > maxValue){
            [LCProgressHUD showMessage:@"超出最大可退款金额"];
            textField.text = MSG_EMPTY;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == _refundField){
        return [self validateNumber:string format:@"0123456789."];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number format:(NSString *)formatStr{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:formatStr];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


@end

