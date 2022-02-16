//
//  STTimeUtil.m
//  gogo
//
//  Created by by.huang on 2017/11/5.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "STTimeUtil.h"

@implementation STTimeUtil

+(NSString *)generateAll : (NSString *)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)generateDate:(NSString *)timestamp format:(NSString *)formatStr{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)generateDate_CH : (NSString *)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)generateDate_EN:(NSString *)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)generateTime : (NSString *)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString* timeString = [formatter stringFromDate:date];
    return timeString;
}

+(NSString *)getTomorrowDate{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval=[dat timeIntervalSince1970];
    timeInterval += 3600 * 24;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getTodayDate{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval=[dat timeIntervalSince1970];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)getLastDate{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval=[dat timeIntervalSince1970];
    timeInterval -= 3600 * 24;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}



+ (NSString *)getLastDates:(int)day{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval=[dat timeIntervalSince1970];
    timeInterval -=  3600 * 24  * (day-1);
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}


+(NSString *)formateTime : (NSString *)timestamp{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval createTime = [timestamp longLongValue]/1000;
    NSTimeInterval time = currentTime - createTime;
    long sec = time/60;
    if(sec == 0){
        return @"刚刚";
    }
    
    if (sec<60) {
        return [NSString stringWithFormat:@"%ld分钟前",sec];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

+(NSString *)getCurrentTimeStamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%f", a];
}

+(NSString *)getTimeStampWithDays:(int)days{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    a += 3600 * 24 * 1000 * days;
    return [NSString stringWithFormat:@"%f", a];
}


+(NSString *)getCurrentWeek:(NSDate *)date{
    long now = [[self getCurrentTimeStamp] longLongValue];
    long time = [date timeIntervalSince1970]*1000;
    long per = 3600 * 24 * 1000;
    if(time - now > 0 &&  time - now <= per){
        return @"今天";
    }
    if(time - now <= 2 * per && time - now > per){
        return @"明天";
    }
    if(time - now <= 3 * per && time - now > 2 * per){
        return @"后天";
    }
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];
    NSArray *weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    return weekArray[weekday-1];
}


+(NSMutableArray *)getOneWeeks{
    NSMutableArray *datas =[[NSMutableArray alloc]init];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval=[dat timeIntervalSince1970]*1000;
    for(int i = 0 ; i < 7 ; i ++){
        timeInterval += 3600 * 24 * 1000;
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000.0];
        NSString *dateStr = [self generateDate_CH:[NSString stringWithFormat:@"%.f",timeInterval]];
        NSString *weakStr = [self getCurrentWeek:date];
        dateStr = [dateStr substringWithRange:NSMakeRange(5, dateStr.length - 5)];
        NSString *result = [NSString stringWithFormat:@"%@ %@",dateStr,weakStr];
        [datas addObject:dateStr];
        [STLog print:result];
    }
    return datas;
}


+(long)getTimeStamp:(NSString *)dateStr format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSDate* date = [formatter dateFromString:dateStr];
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return (long)timeSp;
}

+(NSString *)getCallTime:(long)count{
    return [self generateDate:[NSString stringWithFormat:@"%ld",count * 1000] format:@"mm:ss"];
}


+(NSString *)generateCourseDate:(NSString *)date{
    if(!IS_NS_STRING_EMPTY(date) && [date containsString:@"-"]){
        NSArray *dates = [date componentsSeparatedByString:@"-"];
        int year = [dates[0] intValue];
        int month = [dates[1] intValue];
        if(month == 12){
            return [NSString stringWithFormat:@"%02d-01-01",year+1];
        }
        return [NSString stringWithFormat:@"%02d-%02d-01",year,month+1];
    }
    return MSG_EMPTY;
}

+(NSUInteger)getMaxDay:(NSString *)year month:(NSString *)month{
    NSString *dateStr =[NSString stringWithFormat:@"%@-%@",year,month];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate * date = [dateFormatter dateFromString:dateStr];
    
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 通过该方法计算特定日期月份的天数
    NSRange monthRange =  [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return monthRange.length;
}


@end
