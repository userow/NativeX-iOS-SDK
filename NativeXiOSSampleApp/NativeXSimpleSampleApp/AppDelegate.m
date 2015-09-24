//
//  AppDelegate.m
//  NativeXSimpleSampleApp
//
//  Created by Melissa Johnson on 8/22/14.
//  Copyright (c) 2014 NativeX. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate()
@property (nonatomic)   int totalRewardsCollected;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.view = (ViewController*)self.window.rootViewController;
    // This is needed to receive and handle NativeX callbacks.
    
    // The AppID is obtained from the NativeX Self Service site at https://selfservice.nativex.com
    // Sample App Note: It can take up to 15 minutes for the system to update your ID
    // Sample App Note: If you replace this sample AppID with your own, the ads shown may not reflect the media type noted on the button

    // View this Sample App's activity on https://selfservice.nativex.com. User Name: nativexsampleapp@gmail.com Password:appDevelopersR0ck!
    NSString *appId = @"20910";
    
    // Debug logging!! uncomment this line to enable debug logging within the NativeX SDK
    // WARNING: Make sure debug logging is turned off when submitting your app to the App Store!!!
    [NativeXSDK enableDebugLog:YES];
    
    // Initialize.. setting this object as the SDK delegate and the Reward delegate
    [NativeXSDK initializeWithAppId:appId andSDKDelegate:self andRewardDelegate:self];
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Sample App Note: Managing Fetches                                                                                    //
    //                                                                                                                      //
    // You need to fetch an ad before every showAd call; you can either call fetch directly for every placement,            //
    // or you can set the placements to autofetch (like below).                                                             //
    // Be sure to fetch early enough for the ad to load before it is needed to be shown.                                    //
    // If manually fetching, and if it is likely a user will request an ad more than once per scene,                        //
    // you may want to place a fetch in the ad dismiss.                                                                     //
    // If an ad is set to autofetch, ads will be fetched automatically after dismiss                                        //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Sample App Note: I've added all ad fetches here because I only have a one-scene app, you typically want to only fetch one ad at a time.
    // Sample App Note: Click the Store Open button and nothing happened? It could be that the ad didn't finish loading yet. Try clicking again in a few seconds
    
    // Since ads are set to fetch automatically, they will be fetched immediately after SDK is initialized!

    [NativeXSDK fetchAdsAutomaticallyWithPlacement:kAdPlacementStoreOpen andFetchDelegate:self];
    [NativeXSDK fetchAdsAutomaticallyWithPlacement:kAdPlacementMainMenuScreen andFetchDelegate:self];
    [NativeXSDK fetchAdsAutomaticallyWithPlacement:kAdPlacementGameLaunch andFetchDelegate:self];
    [NativeXSDK fetchAdsAutomaticallyWithPlacement:kAdPlacementLevelFailed andFetchDelegate:self];
    
    // set up the music player
    // La Plume by Whiteyes, CC 3.0 BY-NC-ND
    // https://www.jamendo.com/en/track/37340/la-plume
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    NSString* stringPath = [[NSBundle mainBundle] pathForResource:@"whiteeyes_la_plume" ofType:@"mp3"];
    NSURL* audioFilePath = [NSURL fileURLWithPath:stringPath];
    NSError* error;
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFilePath error:&error];
    self.musicPlayer.numberOfLoops = -1;
    
    [self.musicPlayer play];
    
    _totalRewardsCollected = 0;
    
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
    [self.musicPlayer pause];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.musicPlayer play];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - NativeXSDKDelegate protocol implementation
//---------------------------------------------------------------------------
- (void)nativeXSDKInitialized
{
    // Called if the SDK initializes successfully
    NSLog(@"Wahoo! SDK is initialized; Ads that were set to fetch automatically should now be fetched!");
}

//---------------------------------------------------------------------------
- (void)nativeXSDKFailedToInitializeWithError:(NSError *)error {
    NSLog(@"Oh no! Something isn't set up correctly - re-read the documentation or ask customer support for help https://selfservice.nativex.com/Help \n Error: %@", error);
}

#pragma mark - NativeXAdEventDelegate protocol implementation - Fetch delegate callbacks

//---------------------------------------------------------------------------
- (void) adFetched:(NSString*)placementName
{
    // Called when an ad has been loaded/cached and is ready to be shown.  Enable the buttons on the view to show the ads..
    NSLog(@"Placement '%@': Ad is fetched, and is ready to be shown!", placementName);
    [self.view setButtonforPlacement:placementName enabled:YES];
}

//---------------------------------------------------------------------------
- (void) noAdAvailable:(NSString*)placementName
{
    // no ads to display.
    NSLog(@"Placement '%@': No ad is available to be shown at this time.", placementName);
    // If your app has a "Free Coins" button or similar, make sure that option is disabled
    //[self.view.freeCoinsButton.hidden = YES];
    
    // on no ad available, fetching ads automatically will NOT fetch another ad; if this happens, you will need to manually fetch another ad!
    // Note that on a future success, the ad will continue to fetch automatically..
}

//---------------------------------------------------------------------------
- (void) adFetchFailed:(NSString*)placementName withError:(NSError*)error
{
    // uh oh, something happened with the ad fetch..
    NSLog(@"Uh Oh, somethoing happened with the ad fetch for placement '%@'.. \nError: %@", placementName, error);
    
    // on fetch failed, fetching ads automatically will NOT fetch another ad (due to the error); if this happens, you will need to manually fetch another ad!
    // Note that on a future success, the ad will continue to fetch automatically..
}

#pragma mark - NativeXAdEventDelegate protocol implementation - Show delegate callbacks

//---------------------------------------------------------------------------
// called right after the ad is displayed
- (void) adShown:(NSString*)placementName;
{
    NSLog(@"Placement '%@' has been shown on the screen!", placementName);
}

//---------------------------------------------------------------------------
// called when the ad fails to show
- (void) adFailedToShow:(NSString*)placementName withError:(NSError*)error
{
    NSLog(@"Placement '%@' has failed to show!\nError: %@", placementName, error);
    
    // on failure to show, because we have set the placements to autofetch, we don't need to call Fetch again; however if
    // you're fetching the ads manually, you can call fetch again here..
    
    // at this point, ad is no longer available to play until autofetch finishes.. We're going to disable the button again until that fetch finishes..
    [self.view setButtonforPlacement:placementName enabled:NO];
}

//---------------------------------------------------------------------------
// called after the ad has dismissed
- (void) adDismissed:(NSString*)placementName converted:(BOOL)converted
{
    // ad is dismissed. Because we have set the placements to autofetch, we don't need to call Fetch again; however if
    // you're fetching the ads manually, you can call fetch again here..
    
    NSLog(@"Placement '%@ has been dismissed", placementName);
    
    if (converted) {
        NSLog(@"Placement '%@' has converted! Rewards should be available soon!", placementName);
    }
    
    // at this point, ad is no longer available to play until autofetch finishes.. We're going to disable the button again until that fetch finishes..
    [self.view setButtonforPlacement:placementName enabled:NO];
    
    // resume the music playing
    if (self.musicPlayer.isPlaying == NO) {
        [self.musicPlayer play];
    }
}

// Other NativeXAdEventDelegate protocol methods are not explicitly implemented here.
// All the protocol methods are optional; you can subscribe to them at your discretion.

#pragma mark - NativeXRewardDelegate protocol implementation

//---------------------------------------------------------------------------
- (void) rewardAvailable:(NativeXRewardInfo*) rewardInfo
{
    // add the code to handle the currency info and credit your user here
    for (NativeXReward *reward in rewardInfo.rewards) {
        NSLog(@"Reward collected: %@", reward);
        // grab the amount and add it to total
        _totalRewardsCollected += [reward.amount intValue];
    }
    [rewardInfo showRedeemAlert];
}

@end
