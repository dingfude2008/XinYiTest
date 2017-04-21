//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"
#import <unistd.h>

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    UIView *viewContent = [[UIView alloc] init];
    UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    imv.frame = CGRectMake(0, 0, 37, 37);
    [viewContent addSubview:imv];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = text;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor = [UIColor whiteColor];
    lbl.numberOfLines = 0;
    [viewContent addSubview:lbl];
    
    CGSize title;
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width * 0.7,MAXFLOAT);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : style };
    title = [lbl.text boundingRectWithSize:size
                                   options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:attributes context:nil].size;
//    if ([lbl.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
//    {
//        CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width * 0.7,MAXFLOAT);
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        [style setLineBreakMode:NSLineBreakByCharWrapping];
//        
//        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : style };
//        title = [lbl.text boundingRectWithSize:size
//                                       options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                    attributes:attributes context:nil].size;
//    }
//    else
//    {
//        title = [lbl.text sizeWithFont:lbl.font
//                     constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width * 0.7, MAXFLOAT)
//                         lineBreakMode:NSLineBreakByWordWrapping];
//    }
    
    lbl.frame = CGRectMake(0, 37, title.width, title.height);
    viewContent.frame = CGRectMake(0, 0, title.width > 40 ? title.width : 40,  title.height + 40);
    imv.center = CGPointMake(viewContent.frame.size.width / 2, 3);
    
    HUD.customView = viewContent;
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];

}

#pragma mark 显示信息 重载方法(加入自定义延迟时间)
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view  delay:(NSInteger)delay
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = text;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor = [UIColor whiteColor];
    lbl.numberOfLines = 0;
    
    CGSize title;
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width * 0.7,MAXFLOAT);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : style };
    title = [lbl.text boundingRectWithSize:size
                                   options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:attributes context:nil].size;
    
//    if ([lbl.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
//    {
//        CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width * 0.7,MAXFLOAT);
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        [style setLineBreakMode:NSLineBreakByCharWrapping];
//        
//        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : style };
//        title = [lbl.text boundingRectWithSize:size
//                                       options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                    attributes:attributes context:nil].size;
//    }
//    else
//    {
//        title = [lbl.text sizeWithFont:lbl.font
//                     constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width * 0.7, MAXFLOAT)
//                         lineBreakMode:NSLineBreakByWordWrapping];
//    }
    
    lbl.frame = CGRectMake(0, 0, title.width, title.height);
    hud.customView = lbl;
    hud.mode = MBProgressHUDModeCustomView;
    
    //hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (void)showWarn:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"warning.png" view:view];
}

#pragma mark 显示错误信息 重载方法(加入自定义延迟时间)
+ (void)showError:(NSString *)error toView:(UIView *)view delay:(NSInteger)delay
{
    [self show:error icon:@"error.png" view:view delay:delay];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view delay:(NSInteger)delay
{
    [self show:success icon:@"success.png" view:view delay:delay];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = message;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textColor = [UIColor whiteColor];
    lbl.numberOfLines = 0;
    
    CGSize title;
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width * 0.7,MAXFLOAT);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName : style };
    title = [lbl.text boundingRectWithSize:size
                                   options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:attributes context:nil].size;
    
    lbl.frame = CGRectMake(0, 0, title.width, title.height);
    hud.customView = lbl;
    hud.mode = MBProgressHUDModeCustomView;
    //hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    return hud;
}







@end
