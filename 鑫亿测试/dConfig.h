//
//  dConfig.h
//  aerocom
//
//  Created by 丁付德 on 15/6/29.
//  Copyright (c) 2015年 dfd. All rights reserved.
//

#ifndef aerocom_dConfig_h
#define aerocom_dConfig_h

#import <Availability.h>

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif

#ifndef __OPTIMIZE__                             //
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

#define isHaveBalance                       0           // 是否包含电子称功能
#define isDevelemont                        1           // 是否是开发版   （发布版）


#define RGBA(_R,_G,_B,_A)                   [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:_A]
#define RGB(_R,_G,_B)                       RGBA(_R,_G,_B,1)


// ------- App info
#define	kAppDisplayName                     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]        // APP名称
#define	kAppVersion                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]            // 内部版本号
#define	kAppIdentifier                      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]         // 标识符
#define kAppBuildVersion                    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] // 发布版本号

// ------- 本地存储
#define GetUserDefault(key)                 [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SetUserDefault(k, v)                [[NSUserDefaults standardUserDefaults] setObject:v forKey:k]; [[NSUserDefaults standardUserDefaults]  synchronize];
#define RemoveUserDefault(k)                [[NSUserDefaults standardUserDefaults] removeObjectForKey:k]; [[NSUserDefaults standardUserDefaults] synchronize];

#define KeyWindow                           [UIApplication sharedApplication].keyWindow                               // 主视图

// ------- 提示
#define MBShow(message)                     [MBProgressHUD showSuccess:(message) toView:self.view]
#define MBShowInBlock(message)              [MBProgressHUD showSuccess:(message) toView:blockSelf.view]
#define MBShowAll                           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#define MBShowAllInBlock                    [MBProgressHUD showHUDAddedTo:blockSelf.view animated:YES];
#define MBHide                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES]
#define MBHideInBlock                       [MBProgressHUD hideAllHUDsForView:blockSelf.view animated:YES];
#define MBShowOnWindow(message)             [MBProgressHUD showSuccess:(message) toView:KeyWindow]
#define MBHideOnWindow                      [MBProgressHUD hideAllHUDsForView:KeyWindow animated:YES]
#define MBShowAllOnWindow                   [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
#define MBShowSuccess(message)              [MBProgressHUD showSuccess:(message) toView:self.view]
#define MBShowError(message)                [MBProgressHUD showError:(message) toView:self.view]
#define MBShowWarn(message)                 [MBProgressHUD showWarn:(message) toView:self.view]
#define LMBShowSuccess(message)              MBShowSuccess(kString(message))
#define LMBShowError(message)                MBShowError(kString(message))
#define LMBShowWarn(message)                 MBShowWarn(kString(message))


#define LMBShowSuccessInBlock(message)       MBShowInBlock(kString(message))
#define LMBShowErrorInBlock(message)         [MBProgressHUD showError:kString(message) toView:blockSelf.view]
#define LMBShowWarnInBlock(message)          [MBProgressHUD showWarn:kString(message) toView:blockSelf.view]

#define LMBShowSuccessOnWindow(message)      MBShowOnWindow(kString(message))
#define LMBShowErrorOnWindow(message)        MBShowOnWindow(kString(message))
#define LMBShow(message)                     [MBProgressHUD showSuccess:(kString(message)) toView:self.view]
#define LMBShowInBlock(message)              [MBProgressHUD showSuccess:(kString(message)) toView:blockSelf.view]

// ------- 系统相关

#define IPhone4                             (ScreenHeight == 480) 
#define IPhone5                             (ScreenHeight == 568)
#define IPhone6                             (ScreenHeight == 667)
#define IPhone6P                            (ScreenHeight == 736)
#define IPhone6P                            (ScreenHeight == 736)


#define ISIOS                               [[[UIDevice currentDevice] systemVersion] doubleValue]  // 当前系统版本
#define IS_IOS_7                            (ISIOS>=7.0)?YES:NO                  // 系统版本是否是iOS7+
#define IS_Only_IOS_7                       (ISIOS>=7.0 && ISIOS<8.0)?YES:NO     // 系统版本是否是iOS7.
//#define IS_IPad                             [[UIDevice currentDevice].model rangeOfString:@"iPad"].length > 0    // 是否是ipad
#define IS_IPad                             0    // 是否是ipad


// 中英文
#define kString(_S)                            NSLocalizedString(_S, @"")

// ------- 宽高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight                      ((IS_IOS_7)?20:0)
#define NavBarHeight                        ((IS_IOS_7)?64:44)
#define BottomHeight                        ((IS_IOS_7)?49:49)
#define RealHeight(_k)                      ScreenHeight * (_k / 1280.0)
#define RealWidth(_k)                       ScreenWidth * (_k / 720.0)
#define ScreenRadio                         0.562                           // 屏幕宽高比


#define ConentViewWidth                     [UIScreen mainScreen].bounds.size.width                                     // bounds
#define ConentViewHeight                    ((IS_IOS_7)?([UIScreen mainScreen].bounds.size.height - NavBarHeight):([UIScreen mainScreen].bounds.size.height - NavBarHeight -20))
#define MaskViewDefaultFrame                CGRectMake(0,NavBarHeight,ConentViewWidth,ConentViewHeight)
#define MaskViewFullFrame                   CGRectMake(0,0,ConentViewWidth,[UIScreen mainScreen].bounds.size.height-20)

// ------- 控件相关
#define dHeightForBigView                   200
#define dCellHeight                         44
#define dTextSize(_key)                     [UIFont systemFontOfSize:_key]



#define myUserInfo                          [self getUserInfo]
//#define myUserInfo                          [NSObject getUserInfo]
#define myUserInfoInBlock                   ((UserInfo *)[blockSelf getUserInfo])
//#define NavButtonFrame                      [self getNavFrame]
#define NavButtonFrame                      CGRectMake(0, 0, 20, 20)

#define KgToLb                              0.4532
#define CmToFt                              0.0328             // cm -> ft 英尺
#define Picture_Limit_KB                    100
#define DefaultLogo                         @"person_default"
#define DefaultLogo_boy                     @"boy_default"
#define DefaultLogo_girl                    @"girl_default"
#define CurrentLanguage                     @"CurrentLanguage"
#define LoadImage                           @"loading"
#define DefaultLogoImage                    [UIImage imageNamed:DefaultLogo]
#define DefaultLogo_Gender(_k)              [UIImage imageNamed:(_k ? DefaultLogo_girl:DefaultLogo_boy)]
#define LoadingImage                        [UIImage imageNamed:LoadImage]

#define ImageFromLocal(_k)                 [UIImage imageNamed:_k] ? [UIImage imageNamed:_k] : [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", [self getDomentURL], _k]]

// 阿里云 相关
#define ALI_HostId                          @"oss-cn-shenzhen.aliyuncs.com"
#define my_plant_pic                        @"cupcare-user-pic"
#define plant_pic                           @"plant-pic"
#define sourse                              @"Sourse"
#define tokenIng                            1 * 60 * 60                     // token 过期时间 （ 一个小时 ）

#define NONetTip                            @"网络异常,请检查网络"
#define version_Local                       @"version_Local"
#define plant_pic_Name                      @"plant-pic"                    // 保存的zip名称
#define plant_json_Name                     @"flowers"                      // 保存的Json的名称前缀 后面还有添加 zh, en, fr

#define CheckIsOK                           [dic[@"status"] isEqualToString:@"0"]

//#define RequestBeforeCheck(_k)              [self.netManager sharedClient:^(NSInteger netState) { _k }]
//#define RequestCheckAfter(_k)               RequestBeforeCheck(if(netState){ _k }else{ MBHide;LMBShowError(NONetTip);})
//#define RequestCheckAfterNoWaring(_k)       RequestBeforeCheck(if(netState){ _k })
//

//#define RequestCheckAfter(_k)               [self.netManager checkStatus:YES block:^(NSInteger netState) { if (netState) { _k } else{ MBHide;LMBShowError(NONetTip); }}]
//#define RequestCheckNoWaring(_k)            [self.netManager checkStatus:NO block:^(NSInteger netState) { if (netState) { _k } }]
//


#define RequestCheckAfter(_k1, _k2)           __block NetManager *net = [NetManager new];[net checkStatus:YES block:^(NSInteger netState) {if(netState) { _k1 } else{MBHideOnWindow;MBHideInBlock;LMBShowErrorInBlock(NONetTip); NSLog(NONetTip); }}];net.requestFailError = ^(NSError *error){MBHideOnWindow;MBHideInBlock;LMBShowErrorInBlock(NONetTip);NSLog(@"%@\n error:%@", NONetTip, error);};net.responseSuccessDic = ^(NSDictionary *dic){ _k2  };


#define RequestCheckNoWaring(_k1, _k2)        __block NetManager *net = [NetManager new];[net checkStatus:NO block:^(NSInteger netState) { if(netState) {_k1}}];net.requestFailError = ^(NSError *erro){MBHideOnWindow;MBHideInBlock;NSLog(@"%@\n error:%@", NONetTip, erro);};net.responseSuccessDic = ^(NSDictionary *dic){ _k2  };






#define IMG(_k)                             [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [self getDomentURL], _k]]] ? [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [self getDomentURL], _k]]] : [UIImage imageNamed:_k]                          // 优先考虑Document中的文件

#define NextWait(_k, _v)                    [self performBlock:^{ _k } afterDelay:_v]
#define NextWaitInMain(_k)                  [self performBlockInMain:^{ _k }]
#define NextWaitInMainAfter(_k, _v)         [self performBlockInMain:^{ _k } afterDelay:_v]
#define NextWaitInCurrentTheard(_k, _v)     [self performBlockInCurrentTheard:^{ _k } afterDelay:_v]
#define NextWaitInGlobal(_k, _v)            [self performBlockInGlobal:^{ _k }]



#define LastSysDateTime                     (NSDate *)(GetUserDefault(LastSysDateTimeData)[myUserInfo.access])  // 获取上次更新时间




#define plantNameLength                     20                       // 字节不能超过20
#define DidDisconnectColor                  RGBA(51,63,82,1)         // 未连接的颜色  // RGBA(51,63,82,1)         // 未连接的颜色
#define DidConnectColor                     RGBA(19,104,207,0.96)    // 已连接的颜色
#define DidConnectColor_1                   RGB(19,127,207)
#define DidDisconnectColor_1                RGBA(68,81,100,1)         // 未连接的颜色
#define GirlColor                           RGB(252,132,247)         // 粉色
#define DLightGrayBlackGroundColor          RGBA(240,240,240,1)
#define DButtonCurrentColor                 RGBA(170, 170, 170, 0.3)
#define DWhite3                             [UIColor colorWithWhite:255 alpha:0.3]
#define Bigger(_a, _b)                      ((_a) > (_b) ? _a : _b)
#define Smaller(_a, _b)                     ((_a) < (_b) ? _a : _b)
#define Border(_label, _color)              _label.layer.borderWidth = 1; _label.layer.borderColor = _color.CGColor;



#define TipsListPangeCount                  10



// 默认图片地址
#define DEFAULTIMAGEADDRESS                                     @"ios"
#define DEFAULTIMG                                              [UIImage imageNamed:DEFAULTIMAGEADDRESS]

#define DEFAULTLOGOADDRESS                                      @"thedefault"
#define DEFAULTTHTDEFAULT                                       [UIImage imageNamed:DEFAULTLOGOADDRESS]


#define DBefaultContext                                         [NSManagedObjectContext MR_defaultContext]
#define DBSave                                                  [DBefaultContext MR_saveToPersistentStoreAndWait];
#define DLSave                                                  [localContext MR_saveToPersistentStoreAndWait];

//#define DDSave                                                  [DDefaultContext saveToPersistentStoreAndWait]

//  ------------------------------------------------------------  常用颜色 -----
#define DWhite                                                  [UIColor whiteColor]
#define DRed                                                    [UIColor redColor]
#define DBlue                                                   [UIColor blueColor]
#define DBlack                                                  [UIColor blackColor]
#define DYellow                                                 [UIColor yellowColor]
#define DBlack                                                  [UIColor blackColor]
#define DClear                                                  [UIColor clearColor]
#define DLightGray                                              [UIColor lightGrayColor]
#define DWhiteA(_k)                                             [UIColor colorWithWhite:255 alpha:_k]


#define ISFISTRINSTALL                      @"ISFISTRINSTALL"   // 第一次运行标记
#define UserUnit                            @"UserUnit"
#define SystemPromptBegin                   @"SystemPromptBegin"
#define SystemPromptFinish                  @"SystemPromptFinish"
#define RangeUnit                           @"RangeUnit"
#define TemperatureUnit                     @"TemperatureUnit"
#define Latitude_Longitude                  @"Latitude_Longitude"
#define IsGetUserAddress                    @"IsGetUserAddress"
#define IndexData                           @"IndexData"     // 字典 ： key : access  value: 数组  1：水量 2 百分比 3 天
#define isFirstSys                          @"isFirstSys"                   // 默认为1   每次进入app的时候同步 同步完改为0
#define RemindCount                         @"RemindCount"                  // key flowerID string   value : 报警次数 numbe
#define CheckRemind                         @"CheckRemind"
#define HelpUrlVersion                      @"HelpUrlVersion"
#define isNotRealNewBLE                     @"isNotRealNewBLE"              //默认为O  在index设置为1
#define BLEisON                             @"BLEisON"
#define Channel_id                          @"Channel_id"                   // 存在本地的Channel_id 百度 推送ID
#define ChannelIsBack                       @"ChannelIsBack"                // 推送ID回来了
#define IsLogined                           @"IsLogined"                    // 是否登录过  每次打开APP， 都要重新登录 YES 登录过  NO 没有
#define LastSysDateTimeData                 @"LastSysDateTimeData"          // 上次同步的时间  字典 key: access value: 时间
#define LastUpLoadDateTimeData              @"LastUpLoadDateTimeData"       // 上次上传服务器时间  字典 key: access value: 时间
#define DFD_Notif_LongTime                  @"DFD_Notif_LongTime"           // 本地推送 3天不登陆的推送
#define DFD_Notif_Clock                     @"DFD_Notif_Clock"              // 一次性闹钟提醒
#define is24                                @"is24"
#define isFirstReadTimeSection              @"isFirstReadTimeSection"       // 是否是第一次读喝水提醒时间段
#define SysData                             @"SysData"          // 舍弃
#define TipsIn                              @"TipsIn"           //小贴士进入
#define NewPushData                         @"NewPushData"      //有新的推送消息
#define IndexFirstLoad                      @"IndexFirstLoad"   //首页的第一次加载
#define dicRemindWater                      @"dicRemindWater"   // 喝水提醒  key: uuid  value: NSArray[2] 1:工作日 2: 休息日
#define userInfoAccess                      @"userInfoAccess"
#define userInfoData                        @"userInfoData"   // key ：access  value: 数组：0: email 1:密码 2：uerid
#define readBLEBack                         @"readBLEBack"    // 新数据更新
#define DNet                                @"DNet"           // 网络更新
#define DType                               @"DType"          

// 花草 杯垫 欢乐豆
#define GGet(_a, _b, _c)         [GetUserDefault(DType) intValue] == 1 ? _a : ([GetUserDefault(DType) intValue] == 2 ? _b : _c)
#define GGetT(_a, _b, _c, _d)    [GetUserDefault(DType) intValue] == 1 ? _a : ([GetUserDefault(DType) intValue] == 2 ? _b : ([GetUserDefault(DType) intValue] == 3 ? _c : _d))

//  ------------------------------------------------------------  首页列表图片   -----

#define MDIndexType1                                            @"water"
#define MDIndexType2                                            @"water"
#define MDIndexType3                                            @"news"
#define MDIndexType4                                            @"remind"
#define MDIndexType5                                            @"news"
#define MDIndexType6                                            @"news"

#define DrinkWarnIntervel                                       (2 * 60 * 60)   // 多久没喝水 提醒一次
#define orReaderPrefix                                          @"http://www.sz-hema.com/download"


//  ------------------------------------------------------------  分享 -----

// shareSDK ID
#define SHARESDKID                                              @"a5a5acae19a9"
//#define CupcareAPPID                                            1045956307 //  1030210507（Coasters） 1045956307(Cupcare)
#define CupcareAPPID                                            1030210507 //  1030210507（Coasters） 1045956307(Cupcare)
#define ShareContent                                            @""
#define ShareDescription                                        @""
//#define ShareContent                                            @"我在使用 《Aerocom》 应用，大家来一起吧 ! "
//#define ShareDescription                                        @"我在使用 《Aerocom》 应用，大家来一起吧 ! "
#define ShareUrl                                                @"http://www.sz-hema.com/"
//#define ShareUrl                                                @""

#define UmengAppKey                                             @"55e95c24e0f55a7b3300297f"


//  ------------------------------------------------------------------------------新浪  APPKEY  appSecret  回调网址
#define SinaKEY                                                 @"792716411"
#define SinaSECRET                                              @"d0972efe106a47f5341bb2627aab221b"
#define SinaURL                                                 @"http://www.sz-hema.com/"

//  ------------------------------------------------------------------------------QQ APPKEY  appSecret
#define QQKEY                                                   @"1104737683"   // QQ41D8F593
#define QQSECRET                                                @"dpSU9sWfc77s4vXh"

#define WeiXinKEY                                               @"wxe74cf85a732e85af"
#define WeiXinSECRET                                            @"c3aed8a03c36f9e9fee6268993bde6a0"

#define TwitterKEY                                              @"sfFnk1j3viN03KKiM7oueALbN"
#define TwitterSECRET                                           @"hOFtUmBVp4aOmRIIzTC0WqpulCsiVBh46BtEQyrPaADdf7Rhvl"

//#define FacebookKEY                                             @"827076630738335"  // fb827076630738335
//#define FacebookSECRET                                          @"7a1b010bb82aa8b6b5558933fd92e0f8"

#define FacebookKEY                                             @"1512703895720996"  // fb1512703895720996
#define FacebookSECRET                                          @"19ecf8d56c430c52884149649ccb0787"

#define BaiduPushKEY                                            @"CVvcmDZMmQjKh7kd1BQTbMRG"  // 公司
#define BaiduPushSECRET                                         @"hZ10wjQ4FKjU2FKIkcuCdU1012EvsqoM"

//#define BaiduPushKEY                                            @"zls8VkYtZvsWjgu1vGh3F05o"  // 测试          // APPID 6673501
//#define BaiduPushSECRET                                         @"eNULyujFcTSGvUWeg8KHsQfsMDUQvY5P"

//  ------------------------------------------------------------------------------  测试
//#define uuidTest                            @"BA9C3AE7-4A6A-261E-D389-04ADB6782BA0"               // 03   4s
//#define uuidTest                            @"EF7A59F8-F295-45E8-8D28-F82729545048"              // 07  4s

#define uuidTest                            @"FE4D0A3E-8910-0485-03E1-F046AD58B81C"               // 03   5s
//#define uuidTest                            @"8B8FACC5-E8DB-3082-695A-92B72317CAC2"              // 07  5s



/*
 [ShareSDK connectTwitterWithConsumerKey:@"LRBM0H75rWrU9gNHvlEAA2aOy"
 consumerSecret:@"gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G"
 redirectUri:@"http://mob.com"];
 */

#endif
