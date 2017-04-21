//
//  vcIndex.m
//  鑫亿测试
//
//  Created by 丁付德 on 16/1/4.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "vcIndex.h"
#import "vcList.h"

@interface vcIndex()
{
    int TestType;
}

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@end


@implementation vcIndex

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:self title:@"鑫亿科技生产测试"];
    
    
    self.lblVersion.text = [NSString stringWithFormat:@"版本:%.1f 日期:%d-%d-%d",  [self getIOSVersion],
                            (int)[[NSDate date] getFromDate:1],
                            (int)[[NSDate date] getFromDate:2],
                            (int)[[NSDate date] getFromDate:3]];
    
    self.btn1.layer.cornerRadius =
    self.btn2.layer.cornerRadius =
    self.btn3.layer.cornerRadius =
    self.btn5.layer.cornerRadius =  5;
    
    self.btn1.layer.masksToBounds =
    self.btn2.layer.masksToBounds =
    self.btn3.layer.masksToBounds =
    self.btn5.layer.masksToBounds = YES;
    

}
- (IBAction)btnClick:(UIButton *)sender
{
    TestType = (int)sender.tag;
    [self performSegueWithIdentifier:@"a" sender:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    vcList *vc = (vcList *)segue.destinationViewController;
    vc.TestType = TestType;
    SetUserDefault(DType, @(TestType));
}





@end
