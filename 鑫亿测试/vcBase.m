//
//  vcBace.m
//  欢乐豆Test
//
//  Created by 丁付德 on 15/11/27.
//  Copyright © 2015年 dfd. All rights reserved.
//

#import "vcBase.h"

@interface vcBase () <BLEManagerDelegate>

@end



@implementation vcBase

@synthesize BLE;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"DHL"] forBarMetrics:UIBarMetricsDefault];
    
    BLE = [BLEManager sharedManager];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"DHL"] forBarMetrics:UIBarMetricsDefault];
    self.BLE.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setNavTitle:(UIViewController *)vc title:(NSString *)title
{
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(-100, 0, 100, 30)];
    lblTitle.text = kString(title);
    lblTitle.font = [UIFont systemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor whiteColor];
    
    vc.navigationItem.titleView = lblTitle;
//    Border(vc.navigationItem.titleView, DYellow);
}

-(void)initLeftButton:(NSString *)imgName text:(NSString *)text
{
    NSString *img = imgName ? imgName : @"back";
    if (!text)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 20, 20);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    else
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 22)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.titleLabel.textColor = DWhite;
        
        if([img isEqualToString:@"back"])
        {
            [btn setImage: [UIImage imageNamed:@"back"] forState: UIControlStateNormal];
            [btn setImage: [UIImage imageNamed:@"back02"] forState: UIControlStateHighlighted];
        }
        
        [btn setTitle:kString(text) forState: UIControlStateNormal];
        [btn setImageEdgeInsets: UIEdgeInsetsMake(0, -5, 0, 0)];
        [btn setTitleEdgeInsets: UIEdgeInsetsMake(0, -3, 0, 0)];
        [btn setTitleColor:DWhite forState:UIControlStateNormal];
        [btn setTitleColor:DWhiteA(0.5) forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)Found_CBPeripherals:(NSMutableDictionary *)recivedTxt
{
    
}

-(void)CallBack_ConnetedPeripheral:(NSString *)uuidString
{
    
}

-(void)CallBack_DisconnetedPerpheral:(NSString *)uuidString
{

}

-(void)CallBack_Data:(int)type uuidString:(NSString *)uuidString obj:(NSObject *)obj
{

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
