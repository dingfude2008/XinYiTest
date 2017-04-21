//
//  NSObject+Delay.m
//  aerocom
//
//  Created by 丁付德 on 15/7/1.
//  Copyright (c) 2015年 dfd. All rights reserved.
//

#import "NSObject+Delay.h"
#import "NSDate+toString.h"
#import "NSObject+numArrToDate.h"

@implementation NSObject (Delay)

/**
 *  延迟执行
 *
 *  @param block 执行的block
 *  @param delay 延迟的时间：秒
 */
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}


// 在主线程执行  用于非主线程中更新UI
- (void)performBlockInMain:(void(^)())block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

- (void)performBlockInMain:(void(^)())block afterDelay:(NSTimeInterval)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

- (void)performBlockInGlobal:(void(^)())block 
{
    dispatch_queue_t centralQueue = dispatch_queue_create("com.xinyi.Coasters", DISPATCH_QUEUE_SERIAL);
    dispatch_async(centralQueue, ^{block();});
}

- (CGFloat)getIOSVersion
{
    //NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];    //获取项目名称
    
    //NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    //NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    //NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return [app_Version doubleValue];
}

- (NSString *)getIOSName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}



/**
 *  延迟执行 (在当前的线程)
 *
 *  @param block 执行的block
 *  @param delay 延迟的时间：秒
 */
- (void)performBlockInCurrentTheard:(void (^)())block afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

- (CGRect)getNavFrame
{
    return CGRectMake(0, 0, 20, 20);
    if (ScreenWidth == 320)
    {
        return CGRectMake(0, 0, 50, 25);
    }
//    else if (ScreenWidth == 375)
//    {
//        return CGRectMake(0, 0, 33, 33);
//    }
//    else
//    {
//        return CGRectMake(0, 0, 40, 40);
//    }
}

- (NSInteger)getPreferredLanguage
{
    NSInteger langIn = [(NSNumber *)GetUserDefault(CurrentLanguage) integerValue];
    if (langIn) return langIn;
    
    NSArray * allLanguages = GetUserDefault(@"AppleLanguages");
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    //NSLog(@"当前语言:%@", preferredLang);
    
    NSString *pre = [preferredLang substringWithRange:NSMakeRange(0, 2)];
    if ([pre isEqualToString:@"zh"]) {
        langIn = 1;
    }
    else if([pre isEqualToString:@"en"])
    {
        langIn =  2;
    }
    else if([pre isEqualToString:@"fr"])
    {
        langIn =  3;
    }
    SetUserDefault(CurrentLanguage, @(langIn));
    return langIn;
}

- (NSString *)getPreferredLanguageStr
{
    NSInteger lang = [self getPreferredLanguage];
    NSString *lanStr = @"";
    switch (lang) {
        case 1:
            lanStr = @"zh";
            break;
        case 2:
            lanStr = @"en";
            break;
        case 3:
            lanStr = @"fr";
            break;
            
        default:
            break;
    }
    return lanStr;
}

-(NSData *)getCountiesAndCitiesrDataFromJSON
{
    NSInteger langIndex =  [self getPreferredLanguage];
    NSString *jsonName = @"";
    switch (langIndex) {
        case 1:
        jsonName = @"city_zh";
        break;
        case 2:
        jsonName = @"city_en";
        break;
        case 3:
        jsonName = @"city_fr";
        break;
        
        default:
        break;
    }
    NSData *data = [self getDataFromJSON:jsonName];
    return data;
}

- (CGFloat)getLabelWidth:(int)fontNumber biggestWidth:(CGFloat)biggestWidth text:(NSString *)text
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = text;
    lbl.font = [UIFont systemFontOfSize:fontNumber]; 
    lbl.numberOfLines = 0;
    
    CGSize title;
    
    CGSize size = CGSizeMake(biggestWidth,MAXFLOAT);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontNumber], NSParagraphStyleAttributeName : style };
    title = [lbl.text boundingRectWithSize:size
                                   options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:attributes context:nil].size;
    
//    if ([lbl.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
//    {
//        CGSize size = CGSizeMake(biggestWidth,MAXFLOAT);
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        [style setLineBreakMode:NSLineBreakByCharWrapping];
//        
//        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontNumber], NSParagraphStyleAttributeName : style };
//        title = [lbl.text boundingRectWithSize:size
//                                       options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                    attributes:attributes context:nil].size;
//    }
//    else
//    {
//        title = [lbl.text sizeWithFont:lbl.font
//                     constrainedToSize:CGSizeMake(biggestWidth, MAXFLOAT)
//                         lineBreakMode:NSLineBreakByWordWrapping];
//    }
    return title.height;
}

-(NSData *)getFlowerTypeDataFromJSON
{
    NSInteger langIndex =  [self getPreferredLanguage];
    NSString *jsonName = @"";
    switch (langIndex) {
        case 1:
        jsonName = @"flowers_zh";
        break;
        case 2:
        jsonName = @"flowers_en";
        break;
        case 3:
        jsonName = @"flowers_fr";
        break;
        
        default:
        break;
    }
    NSData *data = [self getDataFromJSON:jsonName];
    return data;
}

-(NSData *)getDataFromXML:(NSString *)name
{
    NSString *address = [NSString stringWithFormat:@"%@", name];
    NSString *path = [[NSBundle mainBundle]  pathForResource:address ofType:@"xml"];
    NSLog(@"path:%@",path);
//    NSData *jdata = [[NSData alloc] initWithContentsOfFile:path ];
    NSLog(@"length:%lu",(unsigned long)[[[NSData alloc] initWithContentsOfFile:path ] length]);
    //NSError *error = nil;
    NSData * adata = [[NSData alloc] initWithContentsOfFile:path];
    return adata;
}

-(NSData *)getDataFromJSON:(NSString *)name
{
    NSString *address = [NSString stringWithFormat:@"%@", name];
    NSString *path = [[NSBundle mainBundle]  pathForResource:address ofType:@"json"];
    NSLog(@"path:%@",path);
    NSData *jdata = [[NSData alloc] initWithContentsOfFile:path ];
    NSLog(@"length:%lu",(unsigned long)[jdata length]);
    NSError *error = nil;
    if (jdata) {
        NSData * adata = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:&error];
        return adata;
    }
    return nil;
}

-(void)clearNotification:(NSString *)name
{
    if(name)
    {
        NSArray *arrNotification =[[UIApplication sharedApplication] scheduledLocalNotifications];
        for(int i = 0; i  < arrNotification.count ; i++)
        {
            UILocalNotification *not = arrNotification[i];
            if (not.userInfo && [not.userInfo.allKeys containsObject:name])
                [[UIApplication sharedApplication] cancelLocalNotification:not];
        }
    }
    else
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void)addLocalNotification:(NSDate *)date repeat:(NSCalendarUnit)repeat soundName:(NSString *)soundName alertBody:(NSString *)alertBody applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber userInfo:(NSDictionary *)userInfo
{
    UILocalNotification *notifi = [[UILocalNotification alloc]init];
    notifi.repeatInterval = repeat ;
    //    notifi.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];   // 测试 10秒之后
    notifi.fireDate = date;
    notifi.timeZone= [NSTimeZone defaultTimeZone];
    notifi.soundName = soundName;//UILocalNotificationDefaultSoundName;
    notifi.alertBody = alertBody; //kString(@"美好的一天,从清晨的第一杯水开始");
    notifi.applicationIconBadgeNumber = applicationIconBadgeNumber;
    notifi.userInfo = userInfo;//dic;
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        notifi.repeatInterval = NSCalendarUnitDay;
    } else
        notifi.repeatInterval = NSDayCalendarUnit;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notifi];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)typeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
        return @"image/jpeg";
        case 0x89:
        return @"image/png";
        case 0x47:
        return @"image/gif";
        case 0x49:
        case 0x4D:
        return @"image/tiff";
    }
    return nil;
}


- (NSMutableArray *)setNSDestByOrder:(NSSet *)set orderStr:(NSString *)orderStr ascending:(BOOL)ascending
{
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:orderStr ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    NSMutableArray *arrResult = [[set sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    return arrResult;
}

-(NSInteger)cTof:(NSInteger)c
{
    // 华氏度 = 32 + 摄氏度 × 1.8
    double fD = 32 + c * 1.8;
    return (int)fD;
}


-(UIImage *)getImageFromCoreData:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *imageFilePath = [path stringByAppendingPathComponent:name];
    NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
    UIImage *img = [UIImage imageWithData:imageData];
    return img;
}


-(BOOL)saveImageToDocoment:(NSData *)imageData name:(NSString *)name
{
    NSString *norPicPath = [self dataPath:name];
    //NSLog(@"filepath: %@",norPicPath);
    
    BOOL norResult = [imageData writeToFile:norPicPath atomically:YES];
    if (norResult) {
        return YES;
    }else {
        NSLog(@"图片保存不成功");
        return NO;
    }
}

- (NSString *)dataPath:(NSString *)file
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@""];
    //NSString *getDome = [self getDomentURL];
    BOOL bo;
    bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    //NSLog(@"%hhd",bo);
    NSString *result = [path stringByAppendingPathComponent:file];
    return result;
}


-(NSString *)getCacheURL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

-(NSString *)getDomentURL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}


-(NSArray *)getFileNamesFromURL:(NSString *)url
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:url error:nil]];
    return tempFileList;
}


-(UIImage *)getImageFromName:(NSString *)name
{
    UIImage *img = [UIImage imageNamed:name];
    if (!img) {
        NSString *strAAA = [NSString stringWithFormat:@"%@/%@", [self getDomentURL], name];
        img = [UIImage imageNamed:strAAA];
    }
    return img;
}

// 返回年的天数
-(int)yearDay:(int)year
{
    int yearlength=0;
    if([self isLeapYear:year]){
        yearlength=366;
    }else{
        yearlength=365;
    }
    return yearlength;
}

// 判断是否是闰年
-(BOOL)isLeapYear:(int)year
{
    return ((year%4==0)&&(year%100!=0))||(year%400==0);
}


-(NSMutableArray *)getXarrList:(NSInteger)year month:(NSInteger)month;
{
    NSInteger count = [self getDaysByYearAndMonth: year month: month];

    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < count; i++)
        [arr addObject:[NSString stringWithFormat:@"%d", i + 1]];
    return arr;
}


- (NSMutableArray *)HmF2KIntToDate:(NSInteger)data
{
    int times[3];
    times[0]=2000;
    
    while ( data >= [self yearDay:times[0]])
    {
        data-= [self yearDay:times[0]];
        times[0]++;
    }
    
    times[1]=0;
    
    while ( data >= [self monthDays:times[0] month:times[1]])
    {
        data -= [self monthDays:times[0] month:times[1]];
        times[1]++;
    }
    
    times[2]= (int)data;
    NSMutableArray *arr = [NSMutableArray new];
    
    
    [arr addObject:@(times[0])];
    
    [arr addObject:@(++times[1])];
    
    [arr addObject:@(++times[2])];
    return arr;
}

//-(NSDate *)dateValueToDate:(NSInteger)dateValue
//{
//    NSMutableArray *arrDate = [self HmF2KIntToDate: dateValue];
//
//}



-(int)HmF2KDateToInt:(NSMutableArray *)array
{
    int date= [((NSNumber *)array[2]) intValue] - 1;
    int month =  [((NSNumber *)array[1]) intValue] - 1;;
    int year = [((NSNumber *)array[0]) intValue];
    while ( --month >= 0 )
    {
        date += [self monthDays:year month:month];
    }
    while ( --year >= 2000 )
    {
        date += [self yearDay:year];
    }
    return date;
}

-(int)HmF2KNSDateToInt:(NSDate *)date
{
    NSMutableArray *arr = [NSMutableArray new];
    NSInteger year = [date getFromDate:1];
    NSInteger month = [date getFromDate:2];
    NSInteger day = [date getFromDate:3];
    
    [arr addObject:@(year)];
    [arr addObject:@(month)];
    [arr addObject:@(day)];
    
    int dateValue = [self HmF2KDateToInt:arr];
    return dateValue;
}

-(NSString *)toStringFromDateValue:(NSInteger)dateValue
{
    NSMutableArray *arr = [self HmF2KIntToDate:dateValue];
    NSInteger year = [arr[0] integerValue];
    NSInteger month = [arr[1] integerValue];
    NSInteger day = [arr[2] integerValue];
    NSString *strMonth = month < 10 ? [NSString stringWithFormat:@"0%ld", (long)month] : [NSString stringWithFormat:@"%ld", (long)month];
    NSString *strDay = day < 10 ? [NSString stringWithFormat:@"0%ld", (long)day] : [NSString stringWithFormat:@"%ld", (long)day];
    NSString *result = [NSString stringWithFormat:@"%ld%@%@", (long)year, strMonth, strDay];
    return result;
}

// 判断当前的输入方是否是中文
-(BOOL)isChineseInput
{
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-hans"] || [lang isEqualToString:@"zh-hant"])
        return YES;
    return NO;
}


- (int)monthDays:(int)year month:(int)month
{
    int days = 31;
    if ( month == 1 ) 		//	feb
    {
        days=28;
        if([self isLeapYear:year]){
            days+=1;
        }
    }
    else
    {
        if ( month > 6 )		//	8月->7月	 9月->8月...
        {
            month--;
        }
        int s = month&1;
        if (s==1)
        {
            days--;			//	30天
        }
    }
    return days;
}

- (NSInteger)getDaysByYearAndMonth:(NSInteger)year_ month:(NSInteger)month_
{
    NSInteger count = 0;
    if (month_ == 4 || month_ == 6 || month_ == 9 || month_ == 11)
    {
        count = 30;
    }
    else if (month_ == 2)
    {
        if ([self isLeapYear:(int)year_])
            count = 29;
        else
            count = 28;
    }
    else
        count = 31;
    return  count;
}

//  dic  -- >  str
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// 把末尾的 0 过滤掉  如果都是 0 返回空的数组
-(NSMutableArray *)filterArr:(NSMutableArray *)arr
{
    NSMutableArray *arrNew = [NSMutableArray new];
    NSMutableArray* reversedArray = [[[arr reverseObjectEnumerator] allObjects] mutableCopy];
    
    BOOL isNotFi = NO;
    for (int i = 0; i < arr.count; i++)
    {
        NSString *st = reversedArray[i];
        if ([st integerValue] || isNotFi)
        {
            [arrNew addObject:st];
            isNotFi = YES;
        }
        else
        {
            isNotFi = NO;
        }
    }
    NSMutableArray *resultArr = [[[arrNew reverseObjectEnumerator] allObjects] mutableCopy];
    return resultArr;
}

// 检查当前系统时间是否是24小时制
-(BOOL)isSysTime24
{
    NSNumber *sysTime = GetUserDefault(is24);
    if (sysTime) return [sysTime boolValue];
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    SetUserDefault(is24, @(!hasAMPM));
    return !hasAMPM;
}


-(NSString *)toJsonStringForUpload:(NSObject *)obj
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString : @"\r\n" withString : @""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString : @"\n" withString : @"" ];
    jsonString = [jsonString stringByReplacingOccurrencesOfString : @"\t" withString : @"" ];
    jsonString = [jsonString stringByReplacingOccurrencesOfString : @"\\" withString : @"" ];
    return jsonString;
}

// 只执行一次
-(void)onlyOneTime:(void (^)())block
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        block();
    });
}


-(NSInteger)getWaterCountFromWater_array:(NSString *)water_array time_array:(NSString *)time_array
{
    NSArray *arrData = [water_array componentsSeparatedByString:@","];
    NSArray *arrTi = [time_array componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (int i = 0; i < arrData.count; i++) {
        [dic setObject:arrData[i] forKey:[arrTi[i] description]];
    }
    
    NSInteger waterCount = 0;
    for (int i = 0 ; i < dic.count; i++)
    {
        waterCount += [dic.allValues[i] integerValue];
    }
    return waterCount;
}


-(NSString *)getWater_array_Hour_FromArray:(NSString *)water_array time_array:(NSString *)time_array
{
    NSArray *arrWater = [water_array componentsSeparatedByString:@","];
    NSArray *arrTime = [time_array componentsSeparatedByString:@","];
    
    int waterHour[24] = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    
    for (int i = 0 ; i < arrWater.count; i++)
    {
        NSMutableArray *arrDate = [self getHourMinuteSecondFormDateValue: [arrTime[i] intValue]];
        int hour = [arrDate[0] intValue];
        waterHour[hour] += [arrWater[i] intValue];
    }
    
    NSString *str = [self intIntsToString: waterHour length:24];
    return str;
}

-(NSString *)intIntsToString:(int[])arr length:(int)length
{
    NSMutableString *strResult = [NSMutableString new];
    for (int i = 0; i < length; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%d", arr[i]];
        [strResult appendString:str];
        if (i != length - 1)
        {
            [strResult appendString:@","];
        }
    }
    return strResult;
}

-(NSMutableArray *)getHourMinuteSecondFormDateValue:(int)timeValue
{
    int hour = timeValue / 1800;
    int minute = (timeValue - hour * 1800) / 30;
    int second = timeValue - hour * 1800 - minute * 30;
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@(hour), @(minute), @(second), nil];
    return arr;
}

// 把从时间(datevalue)获取 当天的时间
-(NSDate *)getDateTimeFormDateValue:(int)timeValue
{
    NSDate *now = [NSDate date];
    NSInteger year = [now getFromDate:1];
    NSInteger month = [now getFromDate:2];
    NSInteger day = [now getFromDate:3];
    
    NSMutableArray *arrDate6 = [NSMutableArray arrayWithObjects:@(year), @(month), @(day), nil];
    NSMutableArray *arr_3 = [self getHourMinuteSecondFormDateValue:timeValue];
    [arrDate6 addObjectsFromArray:arr_3];
    NSDate *date = [self getDateFromInt:arrDate6];
    return date;
}

-(NSString *)getMaxWaterOnTime:(NSString *)water_array time_array:(NSString *)time_array;
{
    if (!water_array || !time_array) return @"";
    NSArray *arrWater = [water_array componentsSeparatedByString:@","];
    NSArray *arrTime = [time_array componentsSeparatedByString:@","];
    int indexMax = 0;
    int biggestWater = [arrWater[0] intValue];
    for (int i = 0; i < arrWater.count; i++)
    {
        int waterThis = [arrWater[i] intValue];
        if (biggestWater < waterThis)
        {
            biggestWater = waterThis;
            indexMax = i;
        }
    }
    
    int timeValue = [arrTime[indexMax] intValue];
    NSMutableArray *arrHourMinuteSencond = [self getHourMinuteSecondFormDateValue: timeValue];
    int hour = [arrHourMinuteSencond[0] intValue];
    int minute = [arrHourMinuteSencond[1] intValue];
    
    NSString *strHour = hour < 10 ? [NSString stringWithFormat:@"0%d", hour] : [NSString stringWithFormat:@"%d", hour];
    NSString *strMinute = minute < 10 ? [NSString stringWithFormat:@"0%d", minute] : [NSString stringWithFormat:@"%d", minute];
    NSString *result = [NSString stringWithFormat:@"%@:%@", strHour, strMinute];
    return result;
}

#pragma mark   NSDictionary -> NSData:
-(NSData *)dicToData:(NSDictionary *)dic
{
    if (!dic) return nil;
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dic forKey:@"Some Key Value"];
    [archiver finishEncoding];
    return data;
}

#pragma mark   NSData -> NSDictionary
-(NSDictionary *)dataTodic:(NSData *)data
{
    if (!data) return nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"Some Key Value"];
    [unarchiver finishDecoding];
    return myDictionary;
}

#pragma mark   根据距离00：00 的时间差 获取现在的时候， 返回  NSDate
-(NSDate *)getTimeFromInterval:(NSNumber *)interval
{
    NSDate *date0 = [[self getDateFromInt:[@[ @0,@0,@0,@0 ] mutableCopy]] clearTimeZone] ;  // 这是00：00 的时间
    NSDate *dateRemind = [NSDate dateWithTimeInterval:[interval intValue] * 60 sinceDate:date0];
    return dateRemind;
}

#pragma mark   根据距离00：00 的时间差 获取现在的时候， 返回  07：21
-(NSString *)getTimeStringFromInterval:(NSNumber *)interval
{
    //NSDate *date0 = [[self getDateFromInt:[@[ @0,@0,@0,@0 ] mutableCopy]] clearTimeZone] ;  // 这是00：00 的时间
    NSDate *date0 = [self getDateFromInt:[@[ @0,@0,@0,@0 ] mutableCopy]] ;  // 这是00：00 的时间
    NSDate *dateRemind = [NSDate dateWithTimeInterval:[interval intValue] * 60 sinceDate:date0];
    NSString *str = [dateRemind toString: @"HH:mm"];
    str = [self getTimeStringFromDate:dateRemind];
    return str;
}



#pragma mark   根据传入的时间算出距离当日00：00的间隔（分钟）        和上面是一对
-(NSInteger)getIntervalFromTime:(NSDate *)date
{
    NSDate *date0 = [[self getDateFromInt:[@[@0,@0,@0,@0] mutableCopy]] clearTimeZone];
    NSInteger interval = [date timeIntervalSinceDate:date0] / 60;
    return interval;
}


#pragma mark   把出入的日期 转化化为  7:13AM   8:45PM
-(NSString *)getTimeStringFromDate:(NSDate *)date
{
    NSString *result;
    if ([self isSysTime24])
        result = [[date clearTimeZone] toString:@"HH:mm"];
    else
    {
        NSInteger hour = [[date clearTimeZone] getFromDate:4];
        NSInteger minute = [[date clearTimeZone] getFromDate:5];
        result = [NSString stringWithFormat:@"%ld:%@%ld%@", (long)(hour > 12 ? hour - 12 : hour), (minute >= 10 ? @"": @"0"), (long)minute, (hour > 12 ? @"PM":@"AM")];
    }
    return result;
}

#pragma mark   进行排序
-(NSMutableArray *)sort:(NSMutableArray *)arr
{
    NSMutableArray *arrResult = [arr mutableCopy];
    for (int i = 1; i < arr.count; i++)
    {
        for (int j = i + 1; j < arr.count; j++)
        {
            NSDictionary *dicLeft = arr[i];
            NSDictionary *dicRight = arr[j];
            int left = [dicLeft.allKeys[0] intValue];
            int right = [dicRight.allKeys[0] intValue];
            if (left > right) {
                NSDictionary *dicTag = [dicLeft mutableCopy];
                arrResult[i] = [dicRight mutableCopy];
                arrResult[j] = [dicTag mutableCopy];
                arr = [arrResult mutableCopy];
            }
        }
    }
    return arrResult;
}

-(NSDate *)toDateByString:(NSString *)string
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    return [dateFormater dateFromString:string];
}

@end
 /*
  下面是打印出当前设备支持的所有语言：（我设置的时英语，所以第一个元素就是en，其中zh-Hans是简体中文，zh-Hant是繁体中文。。。）
  
  
  (
  
  en,
  
  "zh-Hans",
  
  fr,
  
  de,
  
  ja,
  
  nl,
  
  it,
  
  es,
  
  pt,
  
  "pt-PT",
  
  da,
  
  fi,
  
  nb,
  
  sv,
  
  ko,
  
  "zh-Hant",
  
  ru,
  
  pl,
  
  tr,
  
  uk,
  
  ar,
  
  hr,
  
  cs,
  
  el,
  
  he,
  
  ro,
  
  sk,
  
  th,
  
  id,
  
  ms,
  
  "en-GB",
  
  ca,
  
  hu,
  
  vi
  
  )
  
 
     */