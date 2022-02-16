//
//  STTimeUtil.h
//  gogo
//
//  Created by by.huang on 2017/11/5.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STTimeUtil : NSObject

#pragma mark 格式化时间（yyyy年MM月dd日 HH:mm）
+(NSString *)generateAll : (NSString *)timestamp;

#pragma mark 格式化时间（自定格式）
+(NSString *)generateDate:(NSString *)timestamp format:(NSString *)formatStr;

#pragma mark 格式化日期（yyyy年MM月dd日）
+(NSString *)generateDate_CH : (NSString *)timestamp;

#pragma mark 格式化时间（yyyy.MM.dd)
+(NSString *)generateDate_EN : (NSString *)timestamp;

#pragma mark 格式化时间（HH:mm）
+(NSString *)generateTime : (NSString *)timestamp;

#pragma mark 格式化时间（x秒前，x分前...）
+(NSString *)formateTime : (NSString *)timestamp;

#pragma mark 获取当前时间戳
+(NSString *)getCurrentTimeStamp;

#pragma mark 获取几天后的时间戳
+(NSString *)getTimeStampWithDays:(int)days;

#pragma mark 获取昨天的日期
+(NSString *)getLastDate;

#pragma mark 获取今天的日期
+(NSString *)getTodayDate;

#pragma mark 获取明天的日期
+(NSString *)getTomorrowDate;

#pragma mark 获取n天前日期
+(NSString *)getLastDates:(int)day;

#pragma mark 获取今天星期几
+(NSString *)getCurrentWeek:(NSDate *)date;

#pragma mark 获取从今天开始一周
+(NSMutableArray *)getOneWeeks;

#pragma mark 将日期转为时间戳
+(long)getTimeStamp:(NSString *)dateStr format:(NSString *)format;

#pragma mark 将秒转为(00:00)
+(NSString *)getCallTime:(long)count;

#pragma mark 自然月计算(如2018-11-12转为2018-12-01)
+(NSString *)generateCourseDate:(NSString *)date;

#pragma mark 获取某年某月的最大天数
+(NSUInteger)getMaxDay:(NSString *)year month:(NSString *)month;

@end
