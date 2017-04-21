//
//  vcBace.h
//  欢乐豆Test
//
//  Created by 丁付德 on 15/11/27.
//  Copyright © 2015年 dfd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vcBase : UIViewController

@property (nonatomic, strong) BLEManager *BLE;         //对象

-(void)setNavTitle:(UIViewController *)vc title:(NSString *)title;

-(void)initLeftButton:(NSString *)imgName text:(NSString *)text;

-(void)back;

@end
