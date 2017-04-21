
//   NSObject+Delay.h
//   aerocom
//
//   Created by 丁付德 on 15/7/1.
//   Copyright (c) 2015年 dfd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Delay)

#pragma mark  延迟执行 延迟的时间：秒
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;

#pragma mark  在主线程执行  用于非主线程中更新UI
- (void)performBlockInMain:(void(^)())block;

- (void)performBlockInMain:(void(^)())block afterDelay:(NSTimeInterval)delay;

#pragma mark  转入全局非主线程执行
- (void)performBlockInGlobal:(void(^)())block;

#pragma mark  获取系统版本
- (CGFloat)getIOSVersion;

#pragma mark  获取app名称
- (NSString *)getIOSName;

#pragma mark  延迟执行 (在当前的线程) 延迟的时间：秒
- (void)performBlockInCurrentTheard:(void (^)())block afterDelay:(NSTimeInterval)delay;

#pragma mark  获取导航栏 左右按钮 frame
- (CGRect)getNavFrame;

#pragma mark  获取当前语言环境   1： 中文  2 ： 英文  3：  法文
- (NSInteger)getPreferredLanguage;

#pragma mark  获取当前语言环境   zh： 中文  en ： 英文  fr：  法文
- (NSString *)getPreferredLanguageStr;

#pragma mark  从json文件读取数据
-(NSData *)getFlowerTypeDataFromJSON;

#pragma mark 从json文件读取国家地区数据
-(NSData *)getCountiesAndCitiesrDataFromJSON;

#pragma mark  删除本地通知 根据userinfo中是否还有 name    name为nil时 删除所有
-(void)clearNotification:(NSString *)name;

-(void)addLocalNotification:(NSDate *)date repeat:(NSCalendarUnit)repeat soundName:(NSString *)soundName alertBody:(NSString *)alertBody applicationIconBadgeNumber:(NSInteger)applicationIconBadgeNumber userInfo:(NSDictionary *)userInfo;

#pragma mark   获取图片数据的图片格式
- (NSString *)typeForImageData:(NSData *)data;


#pragma mark  根据label的字体大小， 最大宽度， 文字， 获取需要的高度 不包括上下间距
- (CGFloat)getLabelWidth:(int)fontNumber biggestWidth:(CGFloat)biggestWidth text:(NSString *)text;

#pragma mark  对NSSet进行排序
- (NSMutableArray *)setNSDestByOrder:(NSSet *)set orderStr:(NSString *)orderStr ascending:(BOOL)ascending;

#pragma mark  摄氏温度转化成华氏温度
-(NSInteger)cTof:(NSInteger)c;

#pragma mark   从coreData中获取读片/
-(UIImage *)getImageFromCoreData:(NSString *)name;


-(BOOL)saveImageToDocoment:(NSData *)imageData name:(NSString *)name;

#pragma mark  获取Cache目录/
-(NSString *)getCacheURL;

#pragma mark  获取document目录/
-(NSString *)getDomentURL;

#pragma mark 取得指定目录下的所有文件名
-(NSArray *)getFileNamesFromURL:(NSString *)url;

#pragma mark  判断当前的输入方是否是中文
-(BOOL)isChineseInput;

-(UIImage *)getImageFromName:(NSString *)name;

#pragma mark  返回年的天数
-(int)yearDay:(int)year;

#pragma mark  判断是否是闰年
-(BOOL)isLeapYear:(int)year;

#pragma mark  根据月份获得这个月的所有天的集合
-(NSMutableArray *)getXarrList:(NSInteger)year month:(NSInteger)month;

#pragma mark  把时间间隔转化成日期数组
- (NSMutableArray *)HmF2KIntToDate:(NSInteger)data;

#pragma mark  把日期数组转化成时间间隔
-(int)HmF2KDateToInt:(NSMutableArray *)array;

#pragma mark  把日期数组转化成时间间隔
-(int)HmF2KNSDateToInt:(NSDate *)date;

#pragma mark  把时间值转化成字符串  20150203
-(NSString *)toStringFromDateValue:(NSInteger)dateValue;

#pragma mark  获得具体的月 的有多少天
- (NSInteger)getDaysByYearAndMonth:(NSInteger)year_ month:(NSInteger)month_;

#pragma mark   dic  -- >  str
- (NSString*)dictionaryToJson:(NSDictionary *)dic;

#pragma mark   str  -- > dic
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

#pragma mark  把末尾的 0 过滤掉  如果都是 0 返回空的数组
-(NSMutableArray *)filterArr:(NSMutableArray *)arr;

#pragma mark  检查当前系统时间是否是24小时制
-(BOOL)isSysTime24;

#pragma mark  把复杂的数据集合 转化成json字符串  为上传使用
-(NSString *)toJsonStringForUpload:(NSObject *)obj;

#pragma mark  只执行一次
-(void)onlyOneTime:(void (^)())block;

#pragma mark  从喝水集合中获取喝水总量 (过滤掉相同时间点的数据)
-(NSInteger)getWaterCountFromWater_array:(NSString *)water_array time_array:(NSString *)time_array;

#pragma mark  从喝水集合和时间集合中获取每小时的喝水量集合
-(NSString *)getWater_array_Hour_FromArray:(NSString *)water_array time_array:(NSString *)time_array;

#pragma mark  从时间(datevalue)获取  小时 分 秒 数组
-(NSMutableArray *)getHourMinuteSecondFormDateValue:(int)timeValue;

#pragma mark  把从时间(datevalue)获取 当天的时间
-(NSDate *)getDateTimeFormDateValue:(int)timeValue;

#pragma mark  从int数组 拼接字符串
-(NSString *)intIntsToString:(int[])arr length:(int)length;

#pragma mark  获取喝水最多的时间字符串
-(NSString *)getMaxWaterOnTime:(NSString *)water_array time_array:(NSString *)time_array;

#pragma mark   NSDictionary -> NSData: 
-(NSData *)dicToData:(NSDictionary *)dic;

#pragma mark   NSData -> NSDictionary
-(NSDictionary *)dataTodic:(NSData *)data;

#pragma mark   根据距离00：00 的时间差 获取现在的时候， 返回  NSDate
-(NSDate *)getTimeFromInterval:(NSNumber *)interval;

#pragma mark   根据距离00：00 的时间差 获取现在的时候， 返回  07：21
-(NSString *)getTimeStringFromInterval:(NSNumber *)interval;

#pragma mark   根据传入的时间算出距离当日00：00的间隔（分钟）        和上面是一对
-(NSInteger)getIntervalFromTime:(NSDate *)date;

#pragma mark   进行排序
-(NSMutableArray *)sort:(NSMutableArray *)arr;

#pragma mark   把出入的日期 转化化为  7:13AM   8:45PM
-(NSString *)getTimeStringFromDate:(NSDate *)date;

#pragma mark  字符串转化成日期
-(NSDate *)toDateByString:(NSString *)string;


@end
