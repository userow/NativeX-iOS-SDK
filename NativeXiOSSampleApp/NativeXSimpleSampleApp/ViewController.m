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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Customize the UI a smidge
    [[self.showAdButton layer] setCornerRadius:8.0f];
    [[self.showAdButton layer] setMasksToBounds:YES];
    [[self.showAdButton layer] setBorderWidth:1.0f];
    [self.infoLabel sizeToFit];
    [self.pickerView setBackgroundColor:NXColors.grey];
    [self setInfoText];
    
    // Start fetching ads for a placement. NativeX SDK takes care of keeping the ads loaded.
    [NativeXSDK fetchAdsAutomaticallyWithName: [[NXPlacements sharedInstance] mapIdToName:0] enabled:true];
    [NativeXSDK setRewardDelegate:self];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [[NXMusicMaster sharedInstance] play];
}

# pragma Helper Methods

- (NSString *)selectPlacementFromPicker
{
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    return [[NXPlacements sharedInstance] mapIdToName:row];
}

-(void) setInfoText
{
    NXRewardsManager *rm = [NXRewardsManager sharedInstance];
    [rm commit];
    NSString *template = @"NativeX AppId: %@ \nYou've earned %ld %@";
    self.infoLabel.text = [NSString stringWithFormat:template, [[NXSampleSettings sharedInstance] appId], rm.amount, rm.rewardName];
}

- (void) setButton:(UIButton*)button enabled:(BOOL) enabled
{
    button.enabled = enabled;
    button.alpha = (enabled ? 1.0f : 0.5f );
}

-(void)labelsFade
{
    [UIView animateWithDuration:3.0
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.infoLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma Picker View Delegates

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[NXPlacements sharedInstance] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[NXPlacements sharedInstance] mapIdToName:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        [tView setTextColor: NXColors.citrus];
        tView.numberOfLines=3;
    }
    
    // Fill the label text here
    tView.text= [[NXPlacements sharedInstance] mapIdToName:row];
    
    return tView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // When the spinner stops, register that placement for fetches with the NativeX SDK.
    [NativeXSDK fetchAdsAutomaticallyWithName: [[NXPlacements sharedInstance] mapIdToName:row] enabled:true];
}

#pragma NativeX AdEvent Delegates

/*
 * Ad Event delegates make sense in the ViewController in this case, since we're responding to them 
 * by updating UI elements. In your game, you probably keep track of state in other classes, and the
 * VC is probably not where you want your delegates.
 */

-(void) adDismissed:(NSString*)placementName converted:(BOOL)converted
{
    [[NXMusicMaster sharedInstance] play];
    
    // Continuous play (Allow sleep) -- Will be in a future SDK update.
    // This line can be removed once this is included in the NativeX SDK.
    [UIApplication sharedApplication].idleTimerDisabled = FALSE;
    [NXSampleSettings sharedInstance].isAdShowing = FALSE;
}

-(void) adShown:(NSString*)placementName
{
    
    // Continuous play (Disable sleep before showing) -- Will be in a future SDK update.
    // This line can be removed once this is included in the NativeX SDK.
    [UIApplication sharedApplication].idleTimerDisabled = TRUE;
    [NXSampleSettings sharedInstance].isAdShowing = TRUE;
}

-(void) rewardAvailable: (NativeXRewardInfo*) rewardInfo
{

    NXRewardsManager *rm = [NXRewardsManager sharedInstance];
    for( NativeXReward *r in rewardInfo.rewards ) {
        
        if( [rm.rewardId isEqualToString:r.rewardId] ) {
            rm.amount += [r.amount integerValue];
        }
        
    }
    
    [self setInfoText];
    
}

#pragma Actions

- (IBAction) viewTapped:(UITapGestureRecognizer *)sender
{
    self.infoLabel.alpha = 0.80;
    [self performSelector:@selector(labelsFade) withObject:nil afterDelay:3.0f];
    
}

- (IBAction)showAdClicked:(id)sender
{
    NSString *placement = [self selectPlacementFromPicker];
    
    if(placement != nil && [NativeXSDK isAdFetchedWithName: placement] ) {
        NativeXAdInfo *info = [NativeXSDK getAdInfoWithName:placement];
        
        // Before we show an ad, we want to make sure that the music is paused.
        // Let's check the AdInfo object to see the details for this ad.
        
        if( [info willPlayAudio] ) {
            [[NXMusicMaster sharedInstance] pause];
        }
        
        [NativeXSDK showAdWithName:placement andShowDelegate:self];
        
    }
    
}

- (IBAction)mutePressed:(UIButton *)sender {
    
    // Toggle the mute button UI and set the value in the music master
    sender.selected = !sender.selected;
    [NXMusicMaster sharedInstance].isMutedByUser = sender.selected;
    
}

@end
