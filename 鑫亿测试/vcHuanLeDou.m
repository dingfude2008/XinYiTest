//
//  vcHuanLeDou.m
//  鑫亿测试
//
//  Created by 丁付德 on 16/1/5.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "vcHuanLeDou.h"

@interface vcHuanLeDou ()
{
    NSTimer *timer;
    BOOL isBackForTime;    // 回来了
    BOOL isBackForReal;    // 回来了
    
}
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;

@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;
@property (weak, nonatomic) IBOutlet UILabel *lbl6;
@property (weak, nonatomic) IBOutlet UILabel *lblSetTimeSuccess;

@end

@implementation vcHuanLeDou

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.BLE.isNotContinueReadTime = NO;
    [self initLeftButton:nil text:self.cbp.name];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [timer stop];
    timer = nil;
    [self.BLE stopLink:self.BLE.cbpLink];
    [super viewWillDisappear:animated];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(readCBPTime) withObject:nil afterDelay:1];
}

-(void)back
{
    // 这里要处理， 还在不停的读取时间 卡住的情况
//    self.BLE.isNotContinueReadTime = YES;
    
    [super back];
}

-(void)readCBPTime
{
    NSLog(@"读取时间");
    self.lblSetTimeSuccess.text = @"正在校验时间";
    isBackForTime = NO;
    
    __block vcHuanLeDou *blockSelf = self;
    NextWait(
             if(!isBackForTime)
             {
                 //                 LMBShowErrorInBlock(@"设置时间失败");
                 //                 blockSelf.lblSetTimeSuccess.text = @"设置时间失败";
                 //
                 [blockSelf back];
             }
             , 3);
    [self.BLE readTime];
}

-(void)readCBPRealData
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(readRealData) userInfo:nil repeats:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CallBack_Data:(int)type uuidString:(NSString *)uuidString obj:(NSObject *)obj
{
    if (type == 1)
    {
        NSDate *date = [(NSDate *)obj clearTimeZone];
        NSLog(@"------- date : %@", date);
        isBackForTime = YES;
        
        //[self performSelectorOnMainThread:@selector(refreshlblCBPTime:) withObject:date waitUntilDone:YES];
        
        __block vcHuanLeDou *blockSelf = self;
        NextWait(
                 blockSelf.lblSetTimeSuccess.text = @"时间校准完成";
                 [blockSelf readCBPRealData];, 0);
        
        
    }
    else if(type == 2)
    {
        [self performSelectorOnMainThread:@selector(refreshRealData:) withObject:obj waitUntilDone:YES];
    }
    
}

//-(void)refreshlblCBPTime:(NSDate *)date
//{
//    self.lblCBPTime.text = [date toString];
//    self.lblInterval.text = [NSString stringWithFormat:@"%.0f", [date timeIntervalSinceDate:[NSDate date]]];
//}

-(void)refreshRealData:(NSArray *)arr
{
    self.lbl1.text = [arr[0] debugDescription];
    //self.lbl2.text = [arr[1] debugDescription];
    self.lbl3.text = [arr[2] debugDescription];
    self.lbl4.text = [arr[3] debugDescription];
//    self.lbl5.text = [arr[4] debugDescription];
//    self.lbl6.text = [arr[5] debugDescription];
    
    switch ([arr[0] intValue]) {
        case 2:
            self.lbl1.text = @"正常工作";
            self.lbl1.textColor = [UIColor greenColor];
            break;
        case 3:
            self.lbl1.text = @"正在校准...";
            self.lbl1.textColor = [UIColor redColor];
            break;
        case 0:
        case 1:
            self.lbl1.text = @"空闲";
            self.lbl1.textColor = [UIColor redColor];
            break;
            
        default:
            break;
    }
    
    
    //self.lblCBPTime.text = [[(NSDate *)arr[6] clearTimeZone] toString];
}


- (IBAction)btnClickReadTime:(id)sender {
    [self readCBPTime];
}

- (IBAction)btnClickSetTime:(id)sender {
    [self.BLE setTime];
}


-(void)readRealData
{
    NSLog(@"不停的读");
    [self.BLE readRealData];
}


- (IBAction)swcChange:(UISwitch *)sender {
    if (sender.isOn) {
        
    }
    else
    {
        [timer stop];
        timer = nil;
    }
    
}

-(void)CallBack_DisconnetedPerpheral:(NSString *)uuidString
{
    [self performSelectorOnMainThread:@selector(back) withObject:nil waitUntilDone:YES];
}

- (IBAction)btnBack:(id)sender {
    [self back];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
