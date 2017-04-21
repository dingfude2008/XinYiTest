//
//  BLEManager.m
//  BLE
//
//  Created by 丁付德 on 15/5/24.
//  Copyright (c) 2015年 丁付德. All rights reserved.
//

#import "BLEManager.h"
#import "CBP.h"

static BLEManager *manager;
@interface BLEManager()<CBCentralManagerDelegate,CBPeripheralDelegate>

@end


@implementation BLEManager


//@synthesize    delegate;
//@synthesize        Bluetooth;              // 中心设备实例
//@synthesize      dicConnected;           // 连接中的设备集合  key:uuidString  value:连接的对象
//@synthesize             per;                    // 当前的设备处理对象
//@synthesize   filter;                 //  过滤条件 （名字）
//@synthesize   connetNumber;           //  重连的次数
//@synthesize   connetInterval;         //  重连的时间间隔 （单位：秒）
//@synthesize    sendNumber;             //  重发的次数
//@synthesize   sendInterval;           //  重发的时间间隔 （单位：秒）
//@synthesize    isFailToConnectAgain;   //  是否断开重连
//@synthesize   isSendRepeat;           //  是否在没收到回复的时候 重新发送指令
//@synthesize    isLock;                 //   加锁  用于读取数据过程中
//@synthesize   isBeginOK;              //   是否正常开始了 （ 读时间是否有回来 ）
//@synthesize  isSysIng;               // 正在同步中
//@synthesize     isLink;                 // 当前是否连接上
//@synthesize    isOn;                   // 蓝牙是否开启
//@synthesize    isReRead;               // 是否重新设置屏蔽位

+(BLEManager *)sharedManager
{
    @synchronized(self)
    {
        if (!manager)
        {
            manager = [[BLEManager alloc] init];
            manager -> dic = [[NSMutableDictionary alloc] init];
            manager -> dicSysData = [[NSMutableDictionary alloc] init];
            manager -> beginDate = [NSDate date];
            manager -> num = 0;
            manager.connetNumber = 100000000;
            manager.connetInterval = 1;
            manager.dicConnected = [[NSMutableDictionary alloc] init];
            manager.isFailToConnectAgain = YES;
            manager.isSendRepeat = NO;
            manager -> dicDateAll = [NSMutableDictionary new];
            manager.isReRead = YES;
            manager.isBeginOK = NO;
            manager -> isRest = YES;
        }
        return manager;
    }
}

-(void)setIsOn:(BOOL)isOn  // 这里加锁， 防止崩溃
{
    @synchronized(self) {
        _isOn = isOn;
    }
}

//
//-(BOOL)isBeginOK
//{
//    return isBeginOK;
//}


-(void)startScan
{
    NSLog(@"----------------正在扫描");
    dispatch_queue_t centralQueue = dispatch_queue_create("com.xinyi.Coasters", DISPATCH_QUEUE_SERIAL);
    if (!self.Bluetooth)
        self.Bluetooth = [[CBCentralManager alloc]initWithDelegate:self queue:centralQueue];
    self.Bluetooth.delegate = self;
    dic = [[NSMutableDictionary alloc]init];
    [self.Bluetooth scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
}

-(void)startScanNotInit
{
    NSLog(@"----------------正在扫描");
    self.Bluetooth.delegate = self;
    dic = [[NSMutableDictionary alloc]init];
    [self.Bluetooth scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
}

- (void)stopScan
{
    if (self.Bluetooth)
    {
        NSLog(@"扫描结束");
        [self.Bluetooth stopScan];
    }
}

- (void)connectDevice:(CBPeripheral *)peripheral
{
    if (peripheral) {
        [_Bluetooth connectPeripheral:peripheral options:nil];
    }
}

-(void)stopLink:(CBPeripheral *)peripheral
{
    self.isFailToConnectAgain = NO;
    __block BLEManager *blockSelf = self;
    NextWaitInCurrentTheard(blockSelf.isFailToConnectAgain = YES;, 1);
    if (peripheral)
    {
        [_Bluetooth cancelPeripheralConnection:peripheral];
        [self.dicConnected removeObjectForKey:[[peripheral identifier] UUIDString]];
    }
    else
    {
        for (int i = 0; i < self.dicConnected.count ; i++)
            [_Bluetooth cancelPeripheralConnection:self.dicConnected.allValues[i]];
    }
}

+ (BLEManager *)returnNil
{
    @synchronized(self)
    {
        if (manager)
        {
            manager = nil;
        }
        return manager;
    }
}

/**
 *  自动连接
 *
 *  @param uuidString uuidString
 */
-(void)retrievePeripheral:(NSString *)uuidString
{
    NSUUID *nsUUID = [[NSUUID UUID] initWithUUIDString:uuidString];
    if(nsUUID)
    {
        NSArray *peripheralArray = [self.Bluetooth retrievePeripheralsWithIdentifiers:@[nsUUID]];
        //NSLog(@"uuidArray.count=%lu", (unsigned long)peripheralArray.count);
        if([peripheralArray count] > 0)
        {
            for(CBPeripheral *peripheral in peripheralArray)
            {
                peripheral.delegate = self;
                [self stopScan];
                [self startScan];
                 __block BLEManager *blockSelf = self;
                NextWaitInCurrentTheard([blockSelf.Bluetooth connectPeripheral:peripheral options:nil];, 0.5);
            }
        }
        else
        {
            CBUUID *cbUUID = [CBUUID UUIDWithNSUUID:nsUUID];
            NSArray *connectedPeripheralArray = [self.Bluetooth retrieveConnectedPeripheralsWithServices:@[cbUUID]];
            //NSLog(@"cuuidArray.count=%lu", (unsigned long)connectedPeripheralArray.count);
            if([connectedPeripheralArray count] > 0)
            {
                for(CBPeripheral *peripheral in connectedPeripheralArray)
                {
                    peripheral.delegate = self;
                    [_Bluetooth connectPeripheral:peripheral options:nil];
                }
            }
            else
            {
                //NSLog(@"自动连接--- 重新扫描");
                [self startScan];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([dic.allKeys containsObject:uuidString]) {
                        //NSLog(@"已经找到--- 开始连接");
                        [self connectDevice:dic[uuidString]];
                    }
                });
            }
        }
    }
}
#pragma mark - CBCentralManagerDelegate 中心设备代理

/**
 *  当Central Manager被初始化，我们要检查它的状态，以检查运行这个App的设备是不是支持BLE
 *
 *  @param central 中心设备
 */
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    @synchronized(self)
    {
        if (![self isMemberOfClass:[BLEManager class]])return;
        switch (_Bluetooth.state) {
            case CBCentralManagerStatePoweredOff:// 蓝牙未打开
            {
                @try {
                    self.isBeginOK = NO;
                    self.isLink    = NO;
                    self.isOn      = NO;
                    SetUserDefault(BLEisON, @(0));
                    [self.dicConnected removeAllObjects];
                }
                @catch (NSException *exception) {
                    NSLog(@"这里报错，  蓝牙开关");
                }
                @finally {}
            }
                break;
            case CBCentralManagerStatePoweredOn:
            {
                // 开始扫描
                @try {
                    self.isOn = YES;
                    SetUserDefault(BLEisON, @(1));
                    [_Bluetooth scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
                }
                @catch (NSException *exception) {
                    NSLog(@"这里报错，  蓝牙开关");
                }
                @finally {}
                
                
            }
                break;
            default:
                break;
        }
    }  
}


/**
 *  扫描到设备的回调
 *
 *  @param central           中心设备
 *  @param peripheral        扫描到的外设
 *  @param advertisementData 外设的数据集
 *  @param RSSI              信号
 */
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (peripheral.name && ([peripheral.name rangeOfString:Filter_Name].length || [peripheral.name rangeOfString:Filter_Other_Name].length))
    {
        if ([peripheral respondsToSelector:@selector(identifier)])
        {
            
            CBP *cbp = [CBP new];
            cbp.name = peripheral.name;
            cbp.uuid = [[peripheral identifier] UUIDString];
            cbp.RSSI = [RSSI integerValue] > 90 ? -999 : [RSSI integerValue];
            cbp.cbp = peripheral;
            
            if ([RSSI integerValue] <= 90)
            {
                [dic setObject:cbp forKey:[peripheral.identifier UUIDString]];
//                float juli = powf(10, (abs([RSSI integerValue]) - 59) / (10 * 2.0));
//                NSLog(@"name : %@ -- %@, 距离 %f", peripheral.name, [peripheral.identifier UUIDString], juli);
            }
        }
    }
    
    if (dic.count > 0 && [self.delegate respondsToSelector:@selector(Found_CBPeripherals:)])
        [self.delegate Found_CBPeripherals:dic];
}


/**
 *  连接设备成功的方法回调
 *
 *  @param central    中央设备
 *  @param peripheral 外设
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.Bluetooth stopScan];
    peripheral.delegate = self;
    [peripheral discoverServices:nil];      // 扫描服务
    
    NSString *uuidString = [peripheral.identifier UUIDString];
    self.cbpLink = peripheral;
    
    CBP *cbp = [CBP new];
    cbp.name = peripheral.name;
    cbp.uuid = uuidString;
    cbp.RSSI = 9999;
    [self.dicConnected setObject:cbp forKey:uuidString];
    
    if ([self.delegate respondsToSelector:@selector(CallBack_ConnetedPeripheral:)])
    {
        [self.delegate CallBack_ConnetedPeripheral:uuidString];
    }
    self.isLink = YES;
    //NSLog(@"连接成功了, uuidString: %@", [[peripheral identifier] UUIDString]);
}


/**
 *  连接失败的回调
 *
 *  @param central    中心设备
 *  @param peripheral 外设
 *  @param error      error
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"无法连接");
    if (self.isFailToConnectAgain)
        [self beginLinkAgain:peripheral];
}


/**
 *  被动断开
 *
 *  @param central    中心设备
 *  @param peripheral 外设
 *  @param error      error
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接被断开了");
    
    NSString *uuidString = [[peripheral identifier] UUIDString];
    //[self.dicConnected setObject:peripheral forKey:uuidString];
    self.cbpLink = nil;
    
    self.isLink = NO;
    [self.dicConnected removeObjectForKey:uuidString];
    if ([self.delegate respondsToSelector:@selector(CallBack_DisconnetedPerpheral:)])
        [self.delegate CallBack_DisconnetedPerpheral:uuidString];
    if (self.isFailToConnectAgain)
        [self beginLinkAgain:peripheral];
}

/**
 *  发现服务 扫描特性
 *
 *  @param peripheral 外设
 *  @param error      error
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error)
    {
        peripheral.delegate = self;
        for (CBService *service in peripheral.services)
        {
            [peripheral discoverCharacteristics:nil forService:service];  // 扫描特性
        }
    }
    else
    {
        //NSLog(@"error:%@",error);
    }
}

/**
 *  发现特性 订阅特性    ----------------  IOS9  这里可能不会触发回调
 *
 *  @param peripheral 外设
 *  @param service    服务
 *  @param error      error
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error//4
{
    //
//    if (!error)
//    {
//        for (CBCharacteristic *chara in [service characteristics])
//        {
//            
//            NSString *uuidString = [chara.UUID UUIDString];
//            if ([Arr_R_UUID containsObject:uuidString]) {
//                [peripheral setNotifyValue:YES forCharacteristic:chara];   // 订阅特性
//            }
//        }
//    }
}


/**
 *  订阅结果回调，我们订阅和取消订阅是否成功
 *
 *  @param peripheral     外设
 *  @param characteristic 特性
 *  @param error          error
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        //NSLog(@"error  %@",error.localizedDescription);
    }
    else
    {
        [peripheral readValueForCharacteristic:characteristic];
        //读取服务 注意：不是所有的特性值都是可读的（readable）。通过访问 CBCharacteristicPropertyRead 可以知道特性值是否可读。如果一个特性的值不可读，使用 peripheral:didUpdateValueForCharacteristic:error:就会返回一个错误。
    }
    
//    NSString *uuidString = [characteristic.UUID UUIDString];
//      如果不是我们要特性就退出
//    if (![uuidString isEqualToString:FeiTu_TIANYIDIAN_ReadUUID] &&
//        ![uuidString isEqualToString:FeiTu_YUNZU_ReadUUID] &&
//        ![uuidString isEqualToString:FeiTu_YUNDONG_ReadUUID] &&
//        ![uuidString isEqualToString:FeiTu_YUNCHENG_ReadUUID] &&
//        ![uuidString isEqualToString:FeiTu_YUNHUAN_ReadUUID])
//    {
//        return;
//    }
    
    if (characteristic.isNotifying)
    {
        //NSLog(@"外围特性通知开始");
    }
    else
    {
        //NSLog(@"外围设备特性通知结束，也就是用户要下线或者离开%@",characteristic);
    }
}


/**
 *  当我们订阅的特性值发生变化时 （ 就是， 外设向我们发送数据 ）
 *
 *  @param peripheral     外设
 *  @param characteristic 特性
 *  @param error          error
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error//6
{
    NSData *data = characteristic.value;   // 数据集合   长度和协议匹配
    //NSString *uu = [characteristic.UUID UUIDString];
    
    
    NSMutableArray *arrUUID = [NSMutableArray new];
    for (NSString *uuid in Arr_R_UUID)
    {
        CBUUID *cbuuid = [CBUUID UUIDWithString:uuid];
        [arrUUID addObject:cbuuid];
    }
    
//    [data LogDataAndPrompt:uu];
    if ([arrUUID containsObject:characteristic.UUID ])
    {
        [self setData:data peripheral:peripheral charaUUID:characteristic.UUID ];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSString *uu = [characteristic.UUID UUIDString];
    uu = uu;
    NSLog(@"%@ 写入成功",uu);
}

-(void)readChara:(NSString *)uuidString charUUID:(NSString *)charUUID
{
     NSArray *arry = [self.cbpLink services];
     if (!arry || !arry.count)
     {
         NSLog(@"这里为空   charUUID:%@", charUUID);
         return;
     }
     for (CBService *ser in arry)
     {
         CBUUID *cbuuid = [CBUUID UUIDWithString:ServerUUID];
         
         if ([cbuuid isEqual:ser.UUID])
         {
             for (CBCharacteristic *chara in [ser characteristics])
             {
                 CBUUID *cbuuid2 = [CBUUID UUIDWithString:charUUID];
                 if ([cbuuid2 isEqual:chara.UUID]) {
                     NSLog(@"开始读  %@", charUUID);
                     [self.cbpLink readValueForCharacteristic:chara];
                     break;
                 }
             }
         }
     }
}


/**
 *  写入数据
 *
 *  @param data      数据集
 *  @param charaUUID  写入的特性值
 */
-(void)Command:(NSData *)data uuidString:(NSString *)uuidString charaUUID:(NSString *)charaUUID
{
    NSArray *arry = [self.cbpLink services];
    for (CBService *ser in arry)
    {
//        NSString *serverUUID = [ser.UUID UUIDString];
        
        CBUUID *serverUUID = [CBUUID UUIDWithString:ServerUUID];
        if ([ser.UUID isEqual:serverUUID])
        {
            for (CBCharacteristic*chara in [ser characteristics])
            {
                CBUUID *cbuuid = [CBUUID UUIDWithString:charaUUID];
                if ([cbuuid isEqual:chara.UUID])
                {
                    NSString *uuid = [[self.cbpLink identifier] UUIDString];
                    [data LogDataAndPrompt:uuid promptOther:[NSString stringWithFormat:@"- %@ -->", charaUUID]];
                    [self.cbpLink writeValue:data
                           forCharacteristic:chara
                                        type:CBCharacteristicWriteWithResponse];
                    break;
                }
                
            }
            break;
        }
    }
}

         
-(void)setData:(NSData *)data peripheral:(CBPeripheral *)peripheral charaUUID:(CBUUID *)charaUUID
{
    NSString *uuid = [[peripheral identifier] UUIDString];
    
//    NSString *name =  peripheral.name;
    Byte *bytes = (Byte *)data.bytes;
    
    [data LogData];
    
    if ([self checkData:data])
    {
        if ([charaUUID isEqual:[CBUUID UUIDWithString:RW_DateTime_UUID]])
        {
            if([GetUserDefault(DType) intValue] < 3)
            {
                NSNumber *year  = [NSNumber numberWithInt:2000 + bytes[1]];
                NSNumber *month = [NSNumber numberWithInt:1 + bytes[2]];
                NSNumber *day   = [NSNumber numberWithInt:1 + bytes[3]];
                NSNumber *hour  = [NSNumber numberWithInt:bytes[4]];
                NSNumber *minute = [NSNumber numberWithInt:bytes[5]];
                //NSNumber *second = [NSNumber numberWithInt:bytes[6]];
                NSMutableArray *arrNumb = [[NSMutableArray alloc] initWithObjects:year, month, day, hour, minute, @(0), nil];
                NSDate *date = [self getDateFromInt:arrNumb];
                
                NSLog(@"---- 解析后的时间为 :%@", date);
                NSDate *now = [NSDate date];
                now = [now getNowDateFromatAnDate];
                double inter = [now timeIntervalSinceDate:date];
                NSLog(@"间隔：%f", inter);
                
                if (fabs(inter) > 59)
                {
                    [self setDate];
                    __block BLEManager *blockSelf = self;
                    NextWaitInCurrentTheard([blockSelf readTime];, 1);
                }
                else
                {
                    [self.delegate CallBack_Data:1 uuidString:uuid obj:date];
                }
            }
            else
            {
                // 欢乐豆 N2  K9
                NSNumber *year      = @(2000 + bytes[1]);
                NSNumber *month     = @(bytes[2]);
                NSNumber *day       = @(bytes[3]);
                NSNumber *hour      = @(bytes[4]);
                NSNumber *minute    = @(bytes[5]);
                NSNumber *second    = @(bytes[6]);
                NSMutableArray *arrNumb = [[NSMutableArray alloc] initWithObjects:year, month, day, hour, minute, second, nil];
                NSDate *date = [self getDateFromInt:arrNumb];
                
                NSLog(@"---- 解析后的时间为 :%@", date);
                NSDate *now = [NSDate date];
                now = [now getNowDateFromatAnDate];
                double inter = [now timeIntervalSinceDate:date];
                NSLog(@"间隔：%f", inter);
                
                if (inter > 50 || inter < -59)
                {
//                    if (!self.isNotContinueReadTime)
//                    {
                        [self setTime];
                        __block BLEManager *blockSelf = self;
                        NextWaitInCurrentTheard([blockSelf readTime];, 1.5);
//                    }
                }
                else
                {
                    [self.delegate CallBack_Data:1 uuidString:uuid obj:date];
                }
            }
        }
        else if([charaUUID isEqual:[CBUUID UUIDWithString:R_RealData_UUID]]) //
        {
            //  花草 杯垫 欢乐豆
            switch ([GetUserDefault(DType) intValue]) {
                case 1:
                {
                    int temp = bytes[7];
                    int soil = bytes[8];
                    int light = bytes[9];
                    [self.delegate CallBack_Data:2 uuidString:uuid obj:@[ @(temp - 50),@(soil),@(light)]];
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                case 3:
                case 5:
                {
                    NSNumber *year = @(2000 + bytes[1]);
                    NSNumber *month = @(bytes[2]);
                    NSNumber *day = @(bytes[3]);
                    NSNumber *hour = @(bytes[4]);
                    NSNumber *minute = @(bytes[5]);
                    NSNumber *second = @(bytes[6]);
                    NSMutableArray *arrNumb = [[NSMutableArray alloc] initWithObjects:year, month, day, hour, minute, second, nil];
                    NSDate *date = [self getDateFromInt:arrNumb];
                    
                    NSLog(@"----实时数据的 解析后的时间为 :%@", date);
                    
                    /*
                     03:校准状态
                     02:正常工作状态
                     01:空闲状态,已经设置好芽的时间
                     00:空闲状态,芽的时间未设置
                     */
                    
                    int WORK_MODE           = [self convert: bytes[7]];     //
                    int CALIBRATE_OFFSET    = [self convert: bytes[8]];     // 校准偏移角。按下芽的“十”字键时的角度。范围:[-45°,+45°]。
                    int ORIGINA_ANGLE       = [self convert: bytes[9]];     // 未校准的实时角度。范围:[-125°,+125°]。
                    int CALIBRATE_ANGLE     = [self convert: bytes[10]];    // 已校准的实时角度。范围:[-90°,+90°]。 = ORIGINA_ANGLE - CALIBRATE_OFFSET;
                    int PREV_ANGLE          = [self convert: bytes[11]];    // 上一分钟的角度。(实时角度在一分钟内的综合处理后的结果)
                    int THIS_ANGLE          = [self convert: bytes[12]];    // 当前分钟的角度。(实时角度在一分钟内的综合处理后的结果)
                    
                    
                    
                    /*
                     该数据包 APP 根据需要可频繁被读取,例如 1 秒钟一次。
                     该数据包中的 ORIGINA_ANGLE,CALIBRATE_ANGLE 实时更新(不是 1 分钟更新一次)。 该数据包中的 PREV_ANGLE,THIS_ANGLE 1 分钟更新一次。
                     该数据包中的 CALIBRATE_OFFSET 校准时更新。
                     */
                    
                    [self.delegate CallBack_Data:2 uuidString:uuid obj:@[@(WORK_MODE),@(CALIBRATE_OFFSET),@(ORIGINA_ANGLE),@(CALIBRATE_ANGLE),@(PREV_ANGLE),@(THIS_ANGLE),date]];
                }
                    break;
                case 4:
                {
                    
                }
                    break;
            }
        }
    }
    else
    {
        NSLog(@"数据校验不正确");
    }
}

-(int)convert:(char)intValue
{
    int byteValue;
    int temp = intValue % 256;
    if ( intValue < 0) {
        byteValue =  temp < -128 ? 256 + temp : temp;
    }
    else {
        byteValue =  temp > 127 ? temp - 256 : temp;
    }
    return byteValue;
}




// ------------------------------------------------------------------------------

// ----------------------------- 私有方法 ----------------------------------------

// ------------------------------------------------------------------------------

/**
 *  开始断开重连
 *
 *  @param peripheral 要重新连接的设备
 */
-(void)beginLinkAgain:(CBPeripheral *)peripheral
{
//    [self retrievePeripheral:[peripheral.identifier UUIDString]];
//    NSTimer *timR;
//    timR = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(link:) userInfo:peripheral repeats:YES];
    //[self.Bluetooth connectPeripheral:peripheral options:nil];
}

-(void)link:(NSTimer *)timerR
{
    NSLog(@"被动断开后，重新");
    CBPeripheral *cp = timerR.userInfo;
    [self retrievePeripheral:[cp.identifier UUIDString]];
}


// ------------------------------------------------------------------------------

// ----------------------------- 帮助方法 ----------------------------------------

// ------------------------------------------------------------------------------



- (void)begin:(NSString *)uuid
{
    if (!uuid || !uuid.length) return;
    NSLog(@"----------  开始了， uuid:%@", uuid);
    _isLock = YES;
    if (!_isBeginOK) { //  && self.isReRead
        [self readChara:uuid charUUID:RW_DateTime_UUID];
    }
    
//    self.isBeginOK = NO;
    
    // 这里开始读的时候， 可能链接还不稳定，  如果在一定时间内，没有返回数据，  应该再次读取    2秒
     __block BLEManager *blockSelf = self;
    NextWaitInCurrentTheard(if(!_isBeginOK){ [blockSelf begin:uuid]; };, 2);
}


// 写入时间
-(void)setDate
{
    NSDate *now = [NSDate date];
//    now = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
    
    NSLog(@"now:%@", now);
    NSUInteger year = [now getFromDate:1];
    NSUInteger month = [now getFromDate:2];
    NSUInteger day = [now getFromDate:3];
    NSUInteger hour = [now getFromDate:4];
    NSUInteger minute = [now getFromDate:5];
    NSUInteger second = [now getFromDate:6];
    
    char data[8];
    data[0] = DataFirst;
    data[1] = (year - 2000) & 0xFF;
    data[2] = (month - 1) & 0xFF;
    data[3] = (day - 1) & 0xFF;
    data[4] = hour & 0xFF;
    data[5] = minute & 0xFF;
    data[6] = second & 0xFF;
    
    int sum = 0;
    for (int i = 1; i < 7; i++) {
        sum += (data[i]) ^ i;
    }
    data[7] = sum & 0xFF;
    
    NSData *dataPush = [NSData dataWithBytes:data length:8];
    [self Command:dataPush uuidString:[self.cbpLink.identifier UUIDString] charaUUID:RW_DateTime_UUID];
}



// 验证数据是否正确
-(BOOL)checkData:(NSData *)data
{
    if (!data) {
        return  NO;
    }
    NSUInteger count = data.length;
    Byte *bytes = (Byte *)data.bytes;
    int sum = 0;
    
    for (int i = 1; i < count - 1; i++) {
        sum += (bytes[i]) ^ i;
    }
    BOOL isTrue = (sum & 0xFF) == bytes[count - 1];
    return isTrue;
}

// 读取时间
-(void)readTime
{
    [self readChara:[self.cbpLink.identifier UUIDString] charUUID:RW_DateTime_UUID];
}

-(void)setTime
{
    if([GetUserDefault(DType) intValue] < 3 || [GetUserDefault(DType) intValue] == 5)
    {
        NSDate *now = [NSDate date];
        
        NSLog(@"now:%@", now);
        int year = (int)[now getFromDate:1];
        int month = (int)[now getFromDate:2];
        int day = (int)[now getFromDate:3];
        int hour = (int)[now getFromDate:4];
        int minute = (int)[now getFromDate:5];
        int second = (int)[now getFromDate:6];
        
        NSLog(@"发送的时间为 %d-%d-%d %d:%d:%d", year, month, day, hour, minute, second);
        char data[16];
        
        data[0] = DataFirst;
        data[1] = (year - 2000) & 0xFF;
        data[2] = month & 0xFF;
        data[3] = day& 0xFF;
        data[4] = hour & 0xFF;
        data[5] = minute & 0xFF;
        data[6] = second & 0xFF;
        data[7] =  data[8] =  data[9] =  data[10] =  data[11] =  data[12] =  data[13] =  data[14] = 0;
        
        int sum = 0;
        for (int i = 1; i < 15; i++) {
            sum += (data[i]) ^ i;
        }
        data[15] = sum & 0xFF;
        
        NSData *dataPush = [NSData dataWithBytes:data length:16];
        [self Command:dataPush uuidString:[self.cbpLink.identifier UUIDString] charaUUID:RW_DateTime_UUID];
    }
    else
    {
        NSDate *now = [NSDate date];
        NSLog(@"now:%@", now);
        int year = (int)[now getFromDate:1];
        int month = (int)[now getFromDate:2];
        int day =(int)[now getFromDate:3];
        int hour = (int)[now getFromDate:4];
        int minute = (int)[now getFromDate:5];
        int second = (int)[now getFromDate:6];
        
        NSLog(@"发送的时间为 %d-%d-%d %d:%d:%d", year, month, day, hour, minute, second);
        char data[16];
        
        data[0] =  [GetUserDefault(DType) intValue] == 3 ? 0xF5 : 0xF3;
        data[1] = (year - 2000) & 0xFF;
        data[2] = month & 0xFF;
        data[3] = day& 0xFF;
        data[4] = hour & 0xFF;
        data[5] = minute & 0xFF;
        data[6] = second & 0xFF;
        data[7] =  data[8] =  data[9] =  data[10] =  data[11] =  data[12] =  data[13] =  data[14] = 0;
        
        int sum = 0;
        for (int i = 1; i < 15; i++) {
            sum += (data[i]) ^ i;
        }
        data[15] = sum & 0xFF;
        
        NSData *dataPush = [NSData dataWithBytes:data length:16];
        [self Command:dataPush uuidString:[self.cbpLink.identifier UUIDString] charaUUID:RW_DateTime_UUID];
    }
}



-(void)readRealData
{
    [self readChara:[self.cbpLink.identifier UUIDString] charUUID:R_RealData_UUID];
}









@end
