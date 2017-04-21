//
//  NSObject+numArrToDate.m
//  aerocom
//
//  Created by 丁付德 on 15/7/2.
//  Copyright (c) 2015年 dfd. All rights reserved.
//

#import "NSObject+numArrToDate.h"
#import "NSString+toDate.h"

@implementation NSObject (numArrToDate)

/**
 *  时间数组 转化成 时间
 *
 *  @param anyDate 任意
 *
 *  @return 当前时区的时间
 */
- (NSDate *)getDateFromInt:(NSMutableArray *)arr
{
    NSDate *date;
    if (arr.count == 3)
    {
        NSNumber *year = arr[0];
        NSNumber *month = arr[1];
        NSNumber *day = arr[2];
        NSString *strYear = [NSString stringWithFormat:@"%@", year];
        NSString *strMonth = [month integerValue] < 10 ? [NSString stringWithFormat:@"0%@", month] : [NSString stringWithFormat:@"%@", month];
        NSString *strDay = [day integerValue] < 10 ? [NSString stringWithFormat:@"0%@", day] : [NSString stringWithFormat:@"%@", day];
        
        NSString *strDate = [NSString stringWithFormat:@"%@-%@-%@ 00:00:00 000", strYear, strMonth, strDay];
//        date = [strDate toDate];
        date = [self toDateByString:strDate];
    }
    else if(arr.count == 6)
    {
        NSNumber *year = arr[0];
        NSNumber *month = arr[1];
        NSNumber *day = arr[2];
        NSNumber *hour = arr[3];
        NSNumber *minute = arr[4];
        NSNumber *second = arr[5];
        NSString *strYear = [NSString stringWithFormat:@"%@", year];
        NSString *strMonth = [month integerValue] < 10 ? [NSString stringWithFormat:@"0%@", month] : [NSString stringWithFormat:@"%@", month];
        NSString *strDay = [day integerValue] < 10 ? [NSString stringWithFormat:@"0%@", day] : [NSString stringWithFormat:@"%@", day];
        NSString *strHour = [hour integerValue] < 10 ? [NSString stringWithFormat:@"0%@", hour] : [NSString stringWithFormat:@"%@", hour];
        NSString *strMinute = [minute integerValue] < 10 ? [NSString stringWithFormat:@"0%@", minute] : [NSString stringWithFormat:@"%@", minute];
        NSString *strSecond = [second integerValue] < 10 ? [NSString stringWithFormat:@"0%@", second] : [NSString stringWithFormat:@"%@", second];
        
        NSString *strDate = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@ 000", strYear, strMonth, strDay, strHour, strMinute , strSecond];
        //date = [strDate toDate];
        date = [self toDateByString:strDate];
    }
    else if(arr.count == 4)         //  小时  分  秒      这个不关心年月日
    {
        NSDate *now = [NSDate date];
        NSNumber *year = @([now getFromDate:1]);
        NSNumber *month = @([now getFromDate:2]);
        NSNumber *day = @([now getFromDate:3]);
        NSNumber *hour = arr[0];
        NSNumber *minute = arr[1];
        NSNumber *second = arr[2];
        NSString *strYear = [NSString stringWithFormat:@"%@", year];
        NSString *strMonth = [month integerValue] < 10 ? [NSString stringWithFormat:@"0%@", month] : [NSString stringWithFormat:@"%@", month];
        NSString *strDay = [day integerValue] < 10 ? [NSString stringWithFormat:@"0%@", day] : [NSString stringWithFormat:@"%@", day];
        
        NSString *strHour = ([hour integerValue] < 10) ? [NSString stringWithFormat:@"0%@", hour] : [NSString stringWithFormat:@"%@", hour];
        NSString *strMinute = [minute integerValue] < 10 ? [NSString stringWithFormat:@"0%@", minute] : [NSString stringWithFormat:@"%@", minute];
        NSString *strSecond = [second integerValue] < 10 ? [NSString stringWithFormat:@"0%@", second] : [NSString stringWithFormat:@"%@", second];
        
        NSString *strDate = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@ 000", strYear, strMonth, strDay, strHour, strMinute , strSecond];
        //date = [strDate toDate];
        date = [self toDateByString:strDate];
    }
    return  date;
}
















@end
