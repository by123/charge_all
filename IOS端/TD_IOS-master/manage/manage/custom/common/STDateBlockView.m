//
//  STDateBlockView.m
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STDateBlockView.h"
#import "MSSCalendarViewController.h"
#import "MSSCalendarDefine.h"
#import "STTimeUtil.h"

@interface STDateBlockView()<MSSCalendarViewControllerDelegate>

@property(strong, nonatomic)UILabel *startDateLabel;
@property(strong, nonatomic)UILabel *endDateLabel;
@property(strong, nonatomic)UILabel *tempLabel;
@property(strong, nonatomic)UIImageView *startDateImageView;
@property(strong, nonatomic)UIImageView *endDateImageView;

@property(strong, nonatomic)UIViewController *controller;
@property(assign, nonatomic)int maxDays;

@end

@implementation STDateBlockView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

-(void)initView{

    [self addTarget:self action:@selector(onDateBlockBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _startDateLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self addSubview:_startDateLabel];
    
    _endDateLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self addSubview:_endDateLabel];
    
    _tempLabel = [[UILabel alloc]initWithFont:STFont(14) text:@"至" textAlignment:NSTextAlignmentCenter textColor:c05 backgroundColor:nil multiLine:NO];
    [self addSubview:_tempLabel];
    
    _startDateImageView = [[UIImageView alloc]init];
    _startDateImageView.image = [UIImage imageNamed:IMAGE_REFRESH];
    _startDateImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_startDateImageView];
    
    _endDateImageView = [[UIImageView alloc]init];
    _endDateImageView.image = [UIImage imageNamed:IMAGE_REFRESH];
    _endDateImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_endDateImageView];
    
    NSString *currentStr = [STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy-MM-dd"];
    [self setDate:currentStr endDate:currentStr];
}

-(void)setDate:(NSString *)startDate endDate:(NSString *)endDate{
    CGFloat left = 0;
    _startDateLabel.text = startDate;
    
    CGSize startLabelSize = [_startDateLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    left += startLabelSize.width;
    _startDateLabel.frame = CGRectMake(0, 0, startLabelSize.width, STHeight(20));
    
    left += STWidth(5);
    _startDateImageView.frame =CGRectMake(left, (STHeight(20) - STWidth(13))/2, STWidth(13), STWidth(13));
    
    left += STWidth(13) + STWidth(10);
    CGSize tempSize = [_tempLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _tempLabel.frame = CGRectMake(left, 0, tempSize.width, STHeight(20));
    
    left += STWidth(10) + tempSize.width;
    _endDateLabel.text = endDate;
    CGSize endLabelSize = [_endDateLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _endDateLabel.frame = CGRectMake(left, 0, endLabelSize.width, STHeight(20));

    left += STWidth(5) + endLabelSize.width;
    _endDateImageView.frame =CGRectMake(left, (STHeight(20) - STWidth(13))/2, STWidth(13), STWidth(13));
    
    self.frame = CGRectMake(STWidth(15), self.frame.origin.y, left + STWidth(13), STHeight(20));

}

-(void)setController:(UIViewController *)controller{
    _controller = controller;
}

-(void)onDateBlockBtnClick{
    if(_controller){
        [self onOpenCalendar:_controller];
    }
}


-(void)onOpenCalendar:(UIViewController *)controller{
    MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
    cvc.limitMonth = 12 * 5;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerLastType;
    cvc.beforeTodayCanTouch = YES;// 今天之后的日期是否可以点击
    cvc.afterTodayCanTouch = NO;// 今天之前的日期是否可以点击
    //cvc.startDate = [STTimeUtil getCurrentTimeStamp];// 选中开始时间
    //cvc.endDate = _endDate;// 选中结束时间
    /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
    cvc.showChineseHoliday = YES;// 是否展示农历节日
    cvc.showChineseCalendar = YES;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = YES;// 是否显示提示弹窗
    cvc.delegate = self;
    [controller presentViewController:cvc animated:YES completion:nil];
}


-(void)setMaxSelectDays:(int)days{
    _maxDays = days;
}

-(void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate{
    if(_maxDays > 0){
        long tempData = (endDate - startDate) / (3600 * 24);
        if(tempData > _maxDays){
            [LCProgressHUD showMessage:@"最多可选择30天内"];
            return;
        }
    }
    if(_delegate){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        NSString *startDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startDate]];
        NSString *endDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endDate]];
        
        [self setDate:startDateStr endDate:endDateStr];
        [_delegate onDateBlockSelected:startDateStr endDate:endDateStr];
    }
}

@end
