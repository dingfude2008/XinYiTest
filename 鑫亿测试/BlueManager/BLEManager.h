//
//  BLEManager.h
//  BLE
//
//  Created by 丁付德 on 15/5/24.
//  Copyright (c) 2015年 丁付德. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSData+ToString.h"
#import "NSTimer+stop.h"
#import "NSDate+toString.h"
#import "NSString+toDate.h"
#import "NSObject+numArrToDate.h"

// 蓝牙协议
@protocol BLEManagerDelegate <NSObject>  // 回调函数


@optional // -------------------------------------------------------  根据需要实现的代理方法（ 可以不实现 ）
/**
 *  扫描到的设备字典
 *
 *  @param recivedTxt 字典： key ： uuidString  value: CBPeripheral(设备)
 */
-(void)Found_CBPeripherals:(NSMutableDictionary *)recivedTxt;

// ------------------------------------------------------- 蓝牙的系统回调

/**
 *  连接上设备的回调
 *
 *  @param uuidString 设备的uuidString
 */
-(void)CallBack_ConnetedPeripheral:(NSString *)uuidString;


/**
 *  断开了设备的回调
 *
 *  @param uuidString 设备的uuidString
 */
-(void)CallBack_DisconnetedPerpheral:(NSString *)uuidString;


// ------------------------------------------------------- 根据业务的需要，自定义的回调

/**
 *  业务回调
 *
 *  @param uuidString 设备的uuidString
 *
 *  @param uuidString
 */
-(void)CallBack_Data:(int)type uuidString:(NSString *)uuidString obj:(NSObject *)obj;



@end

@interface BLEManager : NSObject
{
    NSMutableDictionary *dic;                //  过滤后的蓝牙设备  key:uuidString  value: CBPeripheral_D 对象
    
    NSDate *beginDate;                       //  私有时间日期，用于记录重发，和重连  时间比较
    
    NSInteger num;                           //  私有次数变量，用于记录重发，和重连  次数比较
    
    NSMutableDictionary *dicSysData;         //  这是 204 返回的暂放数据  （ key: uuidString  value : 数组）
    
    NSInteger todayIndexInSysData;           //  今天在数据中的索引
    
    NSMutableArray *shieldCountOfDay;        //  屏蔽那些下标的数据
    
    NSTimer *timeRealTime;                   //  实时监控循环器
    
    NSTimer *timeCall;                       //  来电闹钟循环器
    
    BOOL isRest;                             //  重置
    
    NSDate *lastDateInAll;                   //  最后的喝水记录
    
    NSData *data204ExceptToday;              //  除了今天之外， 全部屏蔽的204数据
    
    NSMutableDictionary *dicDateAll;         //  所有的喝水记录时间集合
    
    NSInteger waterCount;                    //  204 今天的喝水总量
    NSInteger newWaterCount;                 //  206 最新的喝水总量
    
    BOOL isOnlySetClock;                     //  是否只是设置闹钟
    BOOL isOnlySetUserInfo;                  //  是否只是设置用户信息
    
    NSMutableArray *arrWorkRemindTime;       //  工作日提醒时间集合
                                             //  16 个对象 第一个为NString 为1111111  8位表示星期
                                             //  后面的为  (字典Key:开始时间距离00：00分的间隔 value:结束时间距离00：00分的间隔） * 15
    NSMutableArray *arrRestRemindTime;       //
}

@property (nonatomic, strong) id<BLEManagerDelegate>      delegate;

@property (nonatomic, strong) CBCentralManager *        Bluetooth;              // 中心设备实例

@property (nonatomic, strong) NSMutableDictionary *     dicConnected;           // 连接中的设备集合  key:uuidString  value:连接的对象

@property (nonatomic, strong) CBPeripheral *            per;                    // 当前的设备处理对象

@property (nonatomic, copy)   NSString *                filter;                 //  过滤条件 （名字）

@property (nonatomic, assign) NSInteger                 connetNumber;           //  重连的次数

@property (nonatomic, assign) NSInteger                 connetInterval;         //  重连的时间间隔 （单位：秒）

@property (nonatomic, assign) NSInteger                 sendNumber;             //  重发的次数

@property (nonatomic, assign) NSInteger                 sendInterval;           //  重发的时间间隔 （单位：秒）

@property (nonatomic, assign) BOOL                      isFailToConnectAgain;   //  是否断开重连

@property (nonatomic, assign) BOOL                      isSendRepeat;           //  是否在没收到回复的时候 重新发送指令

@property (nonatomic, assign) BOOL                      isLock;                 //   加锁  用于读取数据过程中

@property (nonatomic, assign) BOOL                      isBeginOK;              //   是否正常开始了 （ 读时间是否有回来 ）

@property (nonatomic, assign) BOOL                      isSysIng;               // 正在同步中

@property (nonatomic ,assign) BOOL                       isLink;                 // 当前是否连接上

@property (nonatomic ,assign) BOOL                       isOn;                   // 蓝牙是否开启

@property (nonatomic ,assign) BOOL                       isReRead;               // 是否重新设置屏蔽位


@property (nonatomic ,strong) CBPeripheral*              cbpLink;               // 当前连接的对象



//实例化 单例方法
+ (BLEManager *)sharedManager;

//开始扫描 （ 初始化中心设备，会导致已经连接的设备断开 ）
-(void)startScan;

//开始扫描 （ 保持之前连接的对象 ）
-(void)startScanNotInit;

//连接设备
- (void)connectDevice:(CBPeripheral *)peripheral;

//主动断开的设备。如果为nil，会断开所有已经连接的设备
-(void)stopLink:(CBPeripheral *)peripheral;

//停止扫描
- (void)stopScan;

//置空
+ (BLEManager *)returnNil;

/**
 *  自动重连
 *
 *  @param uuidString uuidString
 */
-(void)retrievePeripheral:(NSString *)uuidString;

///**
// *  自动重连
// *
// *  @param uuidString uuidString
// */
//-(void)retrievePeripheralByName:(NSString *)name;


/**
 *  读取特性值
 *
 *  @param uuidString
 *  @param charUUID   特性值UUID
 */
-(void)readChara:(NSString *)uuidString charUUID:(NSString *)charUUID;


// 读取时间
-(void)readTime;

-(void)setTime;

-(void)readRealData;


@end
