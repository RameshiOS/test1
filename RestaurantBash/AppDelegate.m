//
//  AppDelegate.m
//  RestaurantBash
//
//  Created by Divya on 5/20/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:1.5];
    dbManager = [DataBaseManager dataBaseManager];
    
    [dbManager execute:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'UserName' TEXT, 'Password' TEXT,'CurrentUser' TEXT,'UserID' TEXT)",@"LoginDetails"]];
    
    [dbManager execute:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'Rest_Id' INTEGER, 'Rest_Name' TEXT,'Rest_Phone' TEXT,'Rest_Address' TEXT,'Rest_City' TEXT,'Rest_State' TEXT,'Rest_Zip' TEXT,'Rest_ContactName' TEXT)",@"RestaurantDetails"]];
    
    // Override point for customization after application launch.
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    NSString *tempStr = [NSString stringWithFormat:@"%@",deviceToken];
    
    NSLog(@"device token %@", tempStr);
    
    NSString *tempApnID = tempStr;
    tempApnID = [tempApnID substringFromIndex:1];
    tempApnID = [tempApnID substringToIndex:[tempApnID length]-1];
    
    [tempApnID stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tempApnID forKey:@"DeviceToken"];
    [defaults synchronize];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [FAUtilities showAlert:@"Unable to connect aps-environment"];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    for (id key in userInfo) {
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        
        NSDictionary *alertsDict = [[userInfo objectForKey:key] objectForKey:@"alert"];
        
        NSString *alertMsg = [alertsDict objectForKey:@"body"];
        UIAlertView *notificationMsgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        
        [notificationMsgAlert show];
        
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
