//
//  ViewController.m
//  NativeXSimpleSampleApp
//
//  Created by Melissa Johnson on 8/22/14.
//  Copyright (c) 2014 NativeX. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Sample App Specific Code: this sets the buttons to disabled until an ad is ready to show
    if(![[NativeXSDK sharedInstance] isAdReadyWithPlacement:kAdPlacementGameLaunch]){
        self.gameLaunch.enabled = NO;
        self.gameLaunch.alpha = .5f;
    }
    if(![[NativeXSDK sharedInstance] isAdReadyWithPlacement:kAdPlacementMainMenuScreen]){
        self.mainMenu.enabled = NO;
        self.mainMenu.alpha = .5f;
    }
    if(![[NativeXSDK sharedInstance] isAdReadyWithPlacement:kAdPlacementLevelFailed]){
        self.levelFailed.enabled = NO;
        self.levelFailed.alpha = .5f;
    }
    if(![[NativeXSDK sharedInstance] isAdReadyWithPlacement:kAdPlacementStoreOpen]){
        self.storeOpen.enabled = NO;
        self.storeOpen.alpha = .5f;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)adIsReadyWithPlacement:(NSString *)placement{
    if ([placement isEqualToString:@"Game Launch"]) {
        self.gameLaunch.enabled = YES;
        self.gameLaunch.alpha = 1;
    }else if ([placement isEqualToString:@"Main Menu Screen"]){
        self.mainMenu.enabled = YES;
        self.mainMenu.alpha = 1;
    }else if ([placement isEqualToString:@"Level Failed"]){
        self.levelFailed.enabled = YES;
        self.levelFailed.alpha = 1;
    }else if ([placement isEqualToString:@"Store Open"]){
        self.storeOpen.enabled = YES;
        self.storeOpen.alpha = 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gameLaunchButtonPressed:(id)sender {
    //Show the ad upon tapping the button
    [[NativeXSDK sharedInstance] showReadyAdWithPlacement:kAdPlacementGameLaunch];
}

- (IBAction)levelFailedButtonPressed:(id)sender {
    //Show the ad upon tapping the button
    [[NativeXSDK sharedInstance] showReadyAdWithPlacement:kAdPlacementLevelFailed];
}

- (IBAction)mainMenuButtonPressed:(id)sender {
    //Show the ad upon tapping the button
    [[NativeXSDK sharedInstance] showReadyAdWithPlacement:kAdPlacementMainMenuScreen];
}

- (IBAction)storeOpenButtonPressed:(id)sender {
    //Show the ad upon tapping the button
    [[NativeXSDK sharedInstance] showReadyAdWithPlacement:kAdPlacementStoreOpen];
}

@end
