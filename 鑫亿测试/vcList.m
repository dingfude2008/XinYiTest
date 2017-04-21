//
//  vcList.m
//  鑫亿测试
//
//  Created by 丁付德 on 16/1/4.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "vcList.h"
#import "tvc.h"
#import "vcBeiDian.h"
#import "vcHuaCao.h"
#import "vcHuanLeDou.h"



@interface vcList()<UITableViewDataSource, UITableViewDelegate>
{
    NSDate *beginDate;
    CBP *cbpCurrent;
    BOOL isLeft;
    NSString *identifier;
}


@property (weak, nonatomic) IBOutlet UILabel *lblScanStatus;

@property (weak, nonatomic) IBOutlet UITableView *tabView;


@property (nonatomic, strong) NSMutableArray *arrData;         // 数据源

@end

@implementation vcList

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:self title:@"鑫亿科技测试"];
    
    
    [self initLeftButton:@"back" text:nil];
    self.arrData = [NSMutableArray new];
    
    NSString *title;
    switch (self.TestType) {
        case 1:
            title = @"C2花草测试";
            identifier = @"huacao";
            break;
        case 2:
            title = @"C1杯垫测试";
            identifier = @"beidian";
            break;
        case 3:
            title = @"N2欢乐豆测试";
            identifier = @"huanledou";
            break;
        case 5:
            title = @"K9欢乐豆测试";
            identifier = @"huanledou";
            break;
    }
    [self setNavTitle:self title:title];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isLeft = NO;
    [self beginScan];
}

-(void)viewWillDisappear:(BOOL)animated
{
    isLeft = YES;
    [super viewWillDisappear:animated];
}


-(void)beginScan
{
    beginDate = [NSDate date];
    self.lblScanStatus.text = @"正在扫描";
    
    [self.arrData removeAllObjects];
    [self.tabView reloadData];
    
    [self.BLE startScan];
}

-(void)stopScan
{
    [self.BLE stopScan];
    self.lblScanStatus.text = @"已经停止";
    //    [self.view removeGestureRecognizer:recognizer];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.arrData.count;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tvc *cell = [tvc cellWithTableView:tableView];
    CBP *cbp = self.arrData[indexPath.row];
    cell.lblName.text = cbp.name;
    cell.lblRSSI.text = [NSString stringWithFormat:@"%ld", (long)cbp.RSSI];
    
    float juli = powf(10, (labs(cbp.RSSI) - 59) / (10 * 2.0));
    cell.lblDistance.text = [NSString stringWithFormat:@"%.2f", juli];
    cell.lblUUID.text = [[[cbp.cbp identifier ] UUIDString] substringToIndex:3];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    cbpCurrent = self.arrData[indexPath.row];
    CBPeripheral *cbp = cbpCurrent.cbp;
    
    
    NSLog(@"name: %@", cbp.name);
    MBShowAll;
    NSLog(@"正在连接 %@ uuid :%@", cbp.name,[cbp.identifier UUIDString]);
    //        [self.BLE retrievePeripheral:[cbp.identifier UUIDString]];
    
    __block vcList *blockSelf = self;
    NextWait(
             if(!blockSelf.BLE.cbpLink)
             {
                 MBHideInBlock;
                 LMBShowError(@"连接失败");
             }
             MBHideInBlock, 3);
    
    [self.BLE connectDevice:cbp];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (IBAction)btnAgainScan:(id)sender {
    
    
    [self beginScan];
}

- (IBAction)stopScan:(id)sender {
    [self stopScan];
}


-(void)Found_CBPeripherals:(NSMutableDictionary *)recivedTxt
{
    [self performSelectorOnMainThread:@selector(refresh:) withObject:recivedTxt waitUntilDone:YES];
}

-(void)refresh:(NSMutableDictionary *)recivedTxt
{
    NSDate *now = [NSDate date];
    NSMutableArray * arr = [NSMutableArray new];
    
    for (int i = 0; i < recivedTxt.count; i++)
    {
        [arr addObject:recivedTxt.allValues[i]];
        //        CBP *c = recivedTxt.allValues[i];
        //        NSLog(@"name:%@, RSSI:%ld", c.name, (long)c.RSSI);
    }
    
    if (arr > 0 && [now timeIntervalSinceDate:beginDate] > 1.5)
    {
        beginDate = [NSDate date];
        [self.arrData removeAllObjects];
        self.arrData = [arr mutableCopy];
        [self startArraySortA];
        [self.tabView reloadData];
    };
}

-(void)CallBack_ConnetedPeripheral:(NSString *)uuidString
{
    NSLog(@"已经连接 uuid ： %@",  uuidString);
    CBP *c;
    for (int i = 0; i < self.arrData.count; i++) {
        c = self.arrData[i];
        if ([c.uuid isEqualToString:uuidString]) {
            break;
        }
    }
    
    NSLog(@"name: %@  uuid : %@  identifier:%@", c.name, c.uuid, identifier);
    
    
    
    NextWait(
             MBHide;
             if(!isLeft)
             {
                 [self performSegueWithIdentifier:identifier sender:c];
             }
             , 1);
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"huacao"])
    {
        vcHuaCao *vc = (vcHuaCao *)segue.destinationViewController;
        vc.cbp = sender;
    }
    else if([segue.identifier isEqualToString:@"beidian"])
    {
        vcBeiDian *vc = (vcBeiDian *)segue.destinationViewController;
        vc.cbp = sender;
    }
    else if([segue.identifier isEqualToString:@"huanledou"])
    {
        vcHuanLeDou *vc = (vcHuanLeDou *)segue.destinationViewController;
        vc.cbp = sender;
    }
}


-(void)startArraySortA
{
    NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:@"RSSI" ascending:NO];
    self.arrData  = [[NSMutableArray alloc]initWithArray:[self.arrData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByA]]];
}



@end
