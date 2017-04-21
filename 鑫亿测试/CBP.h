//
//  CBP.h
//  欢乐豆Test
//
//  Created by 丁付德 on 15/11/27.
//  Copyright © 2015年 dfd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBP : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *uuid;

@property (nonatomic, assign) NSInteger RSSI;

@property (nonatomic, strong) CBPeripheral *cbp;



@end
