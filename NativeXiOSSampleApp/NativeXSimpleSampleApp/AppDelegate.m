//
//  AppDelegate.m
//  NativeXSimpleSampleApp
//
//  Copyright (c) 2014 - 2015 NativeX. All rights reserved.
//
//

#import "AppDelegate.h"
#import "NativeXSimpleSampleApp-Swift.h"

@interface AppDelegate()
@property (nonatomic)   int totalRewardsCollected;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSString *appId = [[NXSampleSettings sharedInstance] appId];
    
    // Initialize the NativeX SDK
    [NativeXSDK enableDebugLog:YES]; // Disable in production
    [NativeXSDK initializeWithAppId:appId];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NXMusicMaster sharedInstance] pause];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if( [NXSampleSettings sharedInstance].isAdShowing == FALSE ) {
        [[NXMusicMaster sharedInstance] play];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
