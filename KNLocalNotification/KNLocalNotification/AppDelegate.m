//
//  AppDelegate.m
//  KNLocalNotification
//
//  Created by 柯南 on 16/8/16.
//  Copyright © 2016年 柯南. All rights reserved.
//
/**
 *     监听用户点击通知
 *
 *   1.app处于前台
 *   此时不会弹框通知用户通知的到达，但是还是会调用对应的代理方法
 *
 *  2.app并没有关闭，一直隐藏在后台时
 *   此时用户点击通知信息后,会让app进入前台，并会调用AppDelegate的下面方法  application: didReceiveLocalNotification:
 *
 *  3.app已经被关闭（进程已死）
 *   此时用户点击通知信息后,会启动app，启动完毕会调用AppDelegate的下面方法
 *    application:didFinishLaunchingWithOptions:launchOptions参数通过UIApplicationLaunchOptionsLocalNotificationKey取
 *    出本地推送通知象
 *
 */
#define LOCALNOTIFICATION_KEY             @"localNotificationKey"


#import "AppDelegate.h"
#import "NSObject+KNLocalNotification.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AppDelegate registerLocalNotification:10 content:@"本地推送练习" key:LOCALNOTIFICATION_KEY];
    
    NSLog(@"launchOptions: %@", launchOptions);
    return YES;
}

/**
 只有当发送出一个本地通知, 并且满足以下条件时, 才会调用该方法
 APP 处于前台情况
 当用用户点击了通知, 从后台, 进入到前台时,
 当锁屏状态下, 用户点击了通知, 从后台进入前台
 
 注意: 当App彻底退出时, 用户点击通知, 打开APP , 不会调用这个方法
 
 但是会把通知的参数传递给 application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
 
 */

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"接收到本地通知" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    // 查看当前的状态出于(前台: 0)/(后台: 2)/(从后台进入前台: 1)
    NSLog(@"applicationState.rawValue: %zd", application.applicationState);
    
    // 执行响应操作
    // 如果当前App在前台,执行操作
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"执行前台对应的操作");
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 后台进入前台
        NSLog(@"执行后台进入前台对应的操作");
        NSLog(@"*****%@", notification.userInfo);
    } else if (application.applicationState == UIApplicationStateBackground) {
        // 当前App在后台
        
        NSLog(@"执行后台对应的操作");
    }
}

//监听通知操作行为的点击
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    NSLog(@"监听通知操作行为的点击");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
