//
//  AppDelegate.m
//  NativeXSimpleSampleApp
//
//  Created by Melissa Johnson on 8/22/14.
//  Copyright (c) 2014 NativeX. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate()
    @property (nonatomic, strong) AVAudioPlayer* musicPlayer;
@end

@implementation AppDelegate
        // Sample App Note: If you receive the "'nativeXSDKDidRedeemWithCurrencyInfo:' in protocol not implemented" error, this means you did not add the currency redemption method. The code for this is below. Even if you don't plan to have any rewarded placements, we highly recommend you add this so you can quickly turn it on via our Self Service site without having to update your app and re-submit.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.view = self.window.rootViewController;
    // This is needed to receive and handle NativeX callbacks.
    [[NativeXSDK sharedInstance] setDelegate:self];
    
    // The AppID is obtained from the NativeX Self Service site at https://selfservice.nativex.com
            // Sample App Note: It can take up to 15 minutes for the system to update your ID
            // Sample App Note: If you replace this sample AppID with your own, the ads shown may not reflect the media type noted on the button
    // View this Sample App's activity on https://selfservice.nativex.com. User Name: nativexsampleapp@gmail.com Password:appDevelopersR0ck!
    NSString *appId = @"20910";
    
    // Initialize
    [[NativeXSDK sharedInstance] createSessionWithAppId:appId];
    
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

- (void)nativeXSDKDidCreateSession {
    // Called if the SDK initializes successfully
    NSLog(@"Wahoo! Now I'm ready to show an ad.");
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Sample App Note: Managing Fetches                                                                                    //
    //                                                                                                                      //
    // You need to fetch an ad before EVERY showReadyAd call.                                                           //
    // Be sure to do this early enough for the ad to load.                                                                  //
    // If it is likely a user will request an ad more than once per scene, you may want to place a fetch in the ad dismiss  //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // Sample App Note: I've added all ad fetches here because I only have a one-scene app, you typically want to only fetch one ad at a time.
    // Sample App Note: Click the Store Open button and nothing happened? It could be that the ad didn't finish loading yet. Try clicking again in a few seconds
    [[NativeXSDK sharedInstance] fetchAdWithPlacement:kAdPlacementStoreOpen delegate:self];
    [[NativeXSDK sharedInstance] fetchAdWithPlacement:kAdPlacementMainMenuScreen delegate:self];
    [[NativeXSDK sharedInstance] fetchAdWithPlacement:kAdPlacementGameLaunch delegate:self];
    [[NativeXSDK sharedInstance] fetchAdWithPlacement:kAdPlacementLevelFailed delegate:self];
}

- (void)nativeXSDKDidFailToCreateSession:(NSError *)error {
    NSLog(@"Oh no! Something isn't set up correctly - re-read the documentation or ask customer support for help https://selfservice.nativex.com/Help");
}

- (void)nativeXAdView:(NativeXAdView *)adView didLoadWithPlacement:(NSString *)placement {
    // Called when an ad has been loaded/cached and is ready to be shown
    [self.view adIsReadyWithPlacement:placement];
}

- (void)nativeXAdViewNoAdContent:(NativeXAdView *)adView {
    // no ads to display.  If your app has a "Free Coins" button or similar, make sure that option is disabled
    //[self.view.freeCoins:Button.hidden = YES];
}

// called right before the ad is displayed
- (void)nativeXAdViewWillDisplay:(NativeXAdView *)adView
{
    // mute the music in the app before displaying the ad
    if (adView.willPlayAudio) {
        [self.musicPlayer pause];
    }
}

-(void)nativeXAdViewDidDismiss:(NativeXAdView *)adView{
    //Once the ad has been closed we are instantly fetching another ad for that placement.
    [[NativeXSDK sharedInstance] fetchAdWithCustomPlacement:adView.placement delegate:self];
    
    // resume the music playing
    if (self.musicPlayer.isPlaying == NO) {
        [self.musicPlayer play];
    }
}

- (void) nativeXSDKDidRedeemWithCurrencyInfo:(NativeXRedeemedCurrencyInfo *)redeemedCurrencyInfo {
    // Add code to handle the currency info and credit your user here
    NSLog(@"Messages: %@", redeemedCurrencyInfo.messages);
    NSLog(@"Redeemed: %@", redeemedCurrencyInfo.balances.description);
    NSLog(@"Redeem Receipts: %@", redeemedCurrencyInfo.receipts);
    
    // Show generic successful redemption alert
    [redeemedCurrencyInfo showRedeemAlert];
}

- (void)nativeXSDKDidRedeemWithError:(NSError *)error {
    // Called when the currency redemption is unsuccessful
}


@end
