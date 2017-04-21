//
//  NSString+toDate.m
//  aerocom
//
//  Created by 丁付德 on 15/7/1.
//  Copyright (c) 2015年 dfd. All rights reserved.
//

#import "NSString+toDate.h"
#import "NSObject+numArrToDate.h"

@implementation NSString (toDate)

- (NSDate *)toDate
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *str = [self mutableCopy];
    NSDate *currentDate = [dateFormater dateFromString:str];  //  !!!泄露
    return currentDate;
}

- (NSDate *)toDate: (NSString *)intString
{
    NSMutableArray *arr;
    if (intString.length == 8)
    {
        int year = [[intString substringWithRange:NSMakeRange(0, 4)] intValue];
        int month = [[intString substringWithRange:NSMakeRange(4, 2)] intValue];
        int day = [[intString substringWithRange:NSMakeRange(6, 2)] intValue];
        
        arr = [@[ @(year),@(month),@(day) ] mutableCopy];
    }
    else if (intString.length == 16)
    {
        int year = [[intString substringWithRange:NSMakeRange(0, 4)] intValue];
        int month = [[intString substringWithRange:NSMakeRange(4, 2)] intValue];
        int day = [[intString substringWithRange:NSMakeRange(6, 2)] intValue];
        int hour = [[intString substringWithRange:NSMakeRange(8, 4)] intValue];
        int minute = [[intString substringWithRange:NSMakeRange(10, 2)] intValue];
        int second = [[intString substringWithRange:NSMakeRange(12, 2)] intValue];
        
        arr = [@[ @(year),@(month),@(day),@(hour),@(minute),@(second) ] mutableCopy];
    }
    
    
    NSDate *date = [self getDateFromInt:arr];
    if (!date) {
        NSLog(@"尼玛  日期错误啦 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        return [NSDate date];
    }
    return  date;
}

@end
