//
//  IUAppDelegate.m
//  Boat
//
//  Created by CocoaPods on 10/11/2014.
//  Copyright (c) 2014 binku. All rights reserved.
//

#import "IUAppDelegate.h"
#import "HelloWorldView.h"
#import <Boat/Router.h>
#import "ApplicationController.h"
#import "FMDatabase.h"
#import "FMDBMigrationManager.h"
#import "User.h"

@implementation IUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //HelloWorldView *view = [[HelloWorldView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [Router redirectTo:@"HelloWorld" params:nil];
    //ApplicationController *applicationController = [[ApplicationController alloc] init];
    //[self.window addSubview:applicationController.view];
    
    [ActiveRecord createAndMigrateDB:@"boat.db"];
    User *user = [User new];
    user.name = @"Binku87111";
    user.password = @"123123";
    [user save];
    [user destroy];
    //user = [User firstBy:@"id = 35"];
    //[user destroy];
    [self.window makeKeyAndVisible];
    return YES;
    
    //[Router redirectTo:"signIn" layout:"normal"];
    //[Router redirectTo:"signIn" layout:"normal_with_layout"];
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
