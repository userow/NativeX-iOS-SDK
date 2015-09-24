//
//  ViewController.m
//  NativeXSimpleSampleApp
//
//  Created by Melissa Johnson on 8/22/14.
//  Copyright (c) 2014 NativeX. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

//---------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Sample App Specific Code: this sets the buttons to disabled until an ad is ready to show
    if ([NativeXSDK isAdFetchedWithPlacement:kAdPlacementGameLaunch] == NO) {
        [self setButton:_gameLaunch enabled:NO];
    }
    if ([NativeXSDK isAdFetchedWithPlacement:kAdPlacementMainMenuScreen] == NO) {
        [self setButton:_mainMenu enabled:NO];
    }
    if ([NativeXSDK isAdFetchedWithPlacement:kAdPlacementLevelFailed] == NO) {
        [self setButton:_levelFailed enabled:NO];
    }
    if ([NativeXSDK isAdFetchedWithPlacement:kAdPlacementStoreOpen] == NO) {
        [self setButton:_storeOpen enabled:NO];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

//---------------------------------------------------------------------------
- (void) setButtonforPlacement:(NSString *)placement enabled:(BOOL) enabled
{
    if ([placement isEqualToString:[NativeXSDK convertAdPlacementToString:kAdPlacementGameLaunch]]) {
        [self setButton:_gameLaunch enabled:enabled];
    } else if ([placement isEqualToString:[NativeXSDK convertAdPlacementToString:kAdPlacementMainMenuScreen]]) {
        [self setButton:_mainMenu enabled:enabled];
    } else if ([placement isEqualToString:[NativeXSDK convertAdPlacementToString:kAdPlacementLevelFailed]]) {
        [self setButton:_levelFailed enabled:enabled];
    } else if ([placement isEqualToString:[NativeXSDK convertAdPlacementToString:kAdPlacementStoreOpen]]) {
        [self setButton:_storeOpen enabled:enabled];
    }
}

//---------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//---------------------------------------------------------------------------
// helper function; enabling/disabling buttons...
- (void) setButton:(UIButton*)button enabled:(BOOL) enabled
{
    button.enabled = enabled;
    button.alpha = (enabled ? 1.0f : 0.5f );
}

//---------------------------------------------------------------------------
- (IBAction)gameLaunchButtonPressed:(id)sender {
    //Show the ad upon tapping the button
    
    // check to see if the ad is ready to display...
    if ([NativeXSDK isAdFetchedWithPlacement:kAdPlacementGameLaunch]) {

        // we will be passing the object implementing NativeXAdEventDelegate to the show button.. In this sample app, that is the AppDelegate object
        AppDelegate* rootApp = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        // check to see if the ad will play audio.. if it does, mute the app's audio!
        if ([NativeXSDK getAdInfoWithPlacement:kAdPlacementGameLaunch].willPlayAudio) {
            [rootApp.musicPlayer pause];
        }
        // show the ad
        [NativeXSDK showAdWithPlacement:kAdPlacementGameLaunch andShowDelegate:rootApp];
    }
}

//---------------------------------------------------------------------------
- (IBAction)levelFailedButtonPressed:(id)sender
{
    //Show the ad upon tapping the button
    
    // check to see if the ad is ready to display...
    if ([NativeXSDK isAdFetchedWithPlacement:kAdPlacementLevelFailed]) {
        
        // we will be passing the object implementing NativeXAdEventDelegate to the show button.. In this sample app, that is the AppDelegate object
        AppDelegate* rootApp = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // check to see if the ad will play audio.. if it does, mute the app's audio!
        if ([NativeXSDK getAdInfoWithPlacement:kAdPlacementLevelFailed].willPlayAudio) {
            [rootApp.musicPlayer pause];
        }
        // show the ad
        [NativeXSDK showAdWithPlacement:kAdPlacementLevelFailed andShowDelegate:rootApp];
    }
}

//---------------------------------------------------------------------------
- (IBAction)mainMenuButtonPressed:(id)sender
{
    //Show the ad upon tapping the button
    
    // check to see if the ad is ready to display...
    if ([NativeXSDK isAdFetchedWithPlacement:kAdPlacementMainMenuScreen]) {
        
        // we will be passing the object implementing NativeXAdEventDelegate to the show button.. In this sample app, that is the AppDelegate object
        AppDelegate* rootApp = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // check to see if the ad will play audio.. if it does, mute the app's audio!
        if ([NativeXSDK getAdInfoWithPlacement:kAdPlacementMainMenuScreen].willPlayAudio) {
            [rootApp.musicPlayer pause];
        }
        // show the ad
        [NativeXSDK showAdWithPlacement:kAdPlacementMainMenuScreen andShowDelegate:rootApp];
    }

}

//---------------------------------------------------------------------------
- (IBAction)storeOpenButtonPressed:(id)sender
{
    //Show the ad upon tapping the button
    
    // check to see if the ad is ready to display...
    if ([NativeXSDK isAdFetchedWithPlacement:kAdPlacementStoreOpen]) {
        
        // we will be passing the object implementing NativeXAdEventDelegate to the show button.. In this sample app, that is the AppDelegate object
        AppDelegate* rootApp = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // check to see if the ad will play audio.. if it does, mute the app's audio!
        if ([NativeXSDK getAdInfoWithPlacement:kAdPlacementStoreOpen].willPlayAudio) {
            [rootApp.musicPlayer pause];
        }
        // show the ad
        [NativeXSDK showAdWithPlacement:kAdPlacementStoreOpen andShowDelegate:rootApp];
    }
}

@end
