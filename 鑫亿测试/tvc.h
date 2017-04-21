//
//  tvc.h
//  欢乐豆Test
//
//  Created by 丁付德 on 15/11/27.
//  Copyright © 2015年 dfd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tvc : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblRSSI;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblUUID;

@end
