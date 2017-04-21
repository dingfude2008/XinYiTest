//
//  NSDate+toString.h
//  
//
//  Created by apple on 15/4/11.
//  Copyright (c) 2015年 yyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (toString)

/**
 *  时间格式转化  把时间转化成需要的格式
 *
 *  @param stringType 格式  例如： @“YYYY-MM-DD”
 *
 *  @return 字符串
 */
- (NSString *)toString:(NSString *)stringType;

- (NSString *)toString;

/**
 *  从日期中抽取 需要的 年，月，日，小时，分钟，秒，星期
 *
 *  @param type 1年 2月  3日   4小时 5分钟 6秒  7星期
 *
 *  @return int
 */
-(NSInteger)getFromDate:(int)type;

// 转化为当前时区的时间
- (NSDate *)getNowDateFromatAnDate;

// 忽略时区
- (NSDate *)clearTimeZone;

// 判断日期是否是当天
- (BOOL)isToday;








@end
