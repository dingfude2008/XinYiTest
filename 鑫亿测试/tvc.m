//
//  tvc.m
//  欢乐豆Test
//
//  Created by 丁付德 on 15/11/27.
//  Copyright © 2015年 dfd. All rights reserved.
//

#import "tvc.h"

@implementation tvc


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"tvc"; // 标识符
    tvc *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"tvc" owner:nil options:nil] lastObject];
    }
    return cell;
}
@end
