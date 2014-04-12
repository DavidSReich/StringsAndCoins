//
//  SCGAppDelegate.m
//  StringsAndCoins
//
//  Created by David S Reich on 1/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGAppDelegate.h"

@implementation SCGAppDelegate

//@synthesize settings;

#define kKeySettings @"Settings"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    self.settings = [[SCGSettings alloc] init];
    [self loadSettings];

    return YES;
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
    [self storeSettings];
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
    [self storeSettings];
}

- (void) storeSettings
{
    NSData *settingsData = [NSKeyedArchiver archivedDataWithRootObject:self.settings];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:settingsData forKey:kKeySettings];
    [userDefaults synchronize];
}

- (void) loadSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *settingsData = [userDefaults objectForKey:kKeySettings];
    if (settingsData != nil)
        self.settings = [NSKeyedUnarchiver unarchiveObjectWithData:settingsData];
    else
    {
        //nothing - leave initial settings
    }
}

@end
