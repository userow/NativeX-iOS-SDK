//
//  MPNativeXRewardedVideoCustomEvent.m
//  NativeXMoPubTestApp
//
//  Created by Joel Braun on 2015.06.24.
//  Copyright (c) 2015 NativeX, LLC. All rights reserved.
//

#import "MPNativeXRewardedVideoCustomEvent.h"
#import "MPRewardedVideoReward.h"
#import "MPNativeXAdapterConstants.h"
#import "MPLogging.h"

#import "NativeXAdView.h"


@interface MPNativeXRewardedVideoCustomEvent () <NativeXAdEventDelegate, NativeXRewardDelegate>

@property(nonatomic)NSString* nativeXplacement;
@property(nonatomic)NSString* nativeXappId;
@property(nonatomic) BOOL   impressionFired;
@property(nonatomic) BOOL   clickFired;

@end

@implementation MPNativeXRewardedVideoCustomEvent

#pragma mark MPRewardedVideoCustomEvent override methods
// Called when the MoPub SDK requires a new rewarded video ad.
- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    // todo: call createsession and stuff
    [[NSUserDefaults standardUserDefaults] setObject:@"MoPub" forKey:@"NativeXBuildType"];
    
    _nativeXappId = [info objectForKey:kMPNativeX_Key_appId];
    _nativeXplacement = [info objectForKey:kMPNativeX_Key_placementId];
    
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    
    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"Cannot request rewarded video, required placement name is missing or empty!");
        return;
    }
    
    //[NativeXSDK enableDebugLog:ENABLE_DEBUG_LOG];
    [NativeXSDK enableDebugLog:NO];

    NSString* sessionID = [NativeXSDK getSessionId];
    // TODO: is initialized, can initialize maybe??
    if ((sessionID == nil) || ([sessionID length] == 0)) {
        [NativeXSDK initializeWithAppId:_nativeXappId];
    }
    // make sure reward delegate is set
    [NativeXSDK setRewardDelegate:self];
    
    _impressionFired = NO;
    _clickFired = NO;
    
    [NativeXSDK fetchAdWithName:_nativeXplacement andFetchDelegate:self];
}

// Called when the MoPubSDK wants to know if an ad is currently available for the ad network.
- (BOOL)hasAdAvailable
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);

    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"Required placement name is missing or empty! No ad is available");
        return NO;
    }

    return [NativeXSDK isAdFetchedWithName:_nativeXplacement];
}

// Called when the rewarded video should be displayed.
- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    
    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"Cannot show rewarded video, required placement name is missing or empty!");
        return;
    }
    
    [NativeXSDK showAdWithName:_nativeXplacement andShowDelegate:self rootViewController:viewController];
}

//Override this method to handle when the custom event is no longer needed by the rewarded video system.
- (void)handleCustomEventInvalidated
{
    // we don't need any cleanup code..
    //if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] --", __PRETTY_FUNCTION__, __LINE__);
}

//---------------------------------------------------------------------------
- (BOOL) enableAutomaticImpressionAndClickTracking
{
    // we're not doing automatic impression and click; so we're handing these explicitly
    return NO;
}

#pragma mark NativeXAdEventDelegate protocol impl


// we're not using mediation settings, so not implementing this..
// Call this method to retrieve a mediation settings object (if one is provided by the application) for this instance of your ad.
//- (id<MPMediationSettingsProtocol>)instanceMediationSettingsForClass:(Class)aClass;

#pragma mark fetch methods

//---------------------------------------------------------------------------
- (void) adFetched:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method immediately after an ad loads succesfully.
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}
//---------------------------------------------------------------------------
- (void) noAdAvailable:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method immediately after an ad fails to load.
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:nil];
}
//---------------------------------------------------------------------------
- (void) adFetchFailed:(NSString *)placementName withError:(NSError *)error
{
    if (ENABLE_DEBUG_LOG) MPLogError(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    MPLogError(@"Ad failed to load with error=%@", error);
    
    // Call this method when the application has attempted to play a rewarded video and it cannot be played.
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
}

#pragma mark show methods

//---------------------------------------------------------------------------
- (void) adExpired:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method if a previously loaded rewarded video should no longer be eligible for presentation.
    [self.delegate rewardedVideoDidExpireForCustomEvent:self];
}
//---------------------------------------------------------------------------
- (void) adShown:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method when an ad is about to appear.
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    // Call this method when an ad has finished appearing.
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}
//---------------------------------------------------------------------------
- (void) adFailedToShow:(NSString *)placementName withError:(NSError *)error
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    MPLogError(@"Ad failed to show with error=%@", error);
}
//---------------------------------------------------------------------------
- (void) adImpressionConfirmed:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    // since we're not doing automatic impression tracking, fire explicitly
    if (_impressionFired == NO) {
        [self.delegate trackImpression];
        _impressionFired = YES;
    }
}
//---------------------------------------------------------------------------
- (void) userRedirected:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // since we're not doing automatic impression tracking, fire explicitly
    if (_clickFired == NO) {
        [self.delegate trackClick];
        _clickFired = YES;
    }
    
    // Call this method when the rewarded video ad will cause the user to leave the application.
    [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
    
    // Call this method when the user taps on the rewarded video ad.
    // **Note**: some third-party networks provide a "will leave application" callback instead of/in
    // addition to a "user did click" callback. You should call this method in response to either of
    // those callbacks (since leaving the application is generally an indicator of a user tap).
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
}
//---------------------------------------------------------------------------
- (void) adDismissed:(NSString *)placementName converted:(BOOL)converted
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method when an ad is about to disappear.
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    // Call this method when an ad has finished disappearing.
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
    
    if (converted) {
        // kicking off a reward redemption happens automatically on dismiss.. don't need to do another..
        //[NativeXSDK isRewardAvailable];
    }
}

#pragma mark NativeXRewardDelegateP protocol impl

//---------------------------------------------------------------------------
- (void) rewardAvailable:(NativeXRewardInfo *)rewardInfo
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    
    if ([rewardInfo.rewards count] <= 0) {
        MPLogWarn(@"No reward amount found; not calling MoPub reward delegate..");
        return;
    }
    
    NSString* rewardType = nil;
    int rewardAmount = 0;
    
    // there better be only one currency type here.. if there's more than one, we have problems..
    for (NativeXReward* reward in rewardInfo.rewards) {
        if ((rewardType == nil) || (rewardType == reward.rewardName)) {
            if (rewardType == nil) {
                rewardType = reward.rewardName;
            }
            rewardAmount += [reward.amount intValue];
        }
    }
    
    // make sure rewardType isn't nil, which can happen if the above is empty..
    if (rewardType == nil) {
        rewardType = kMPRewardedVideoRewardCurrencyTypeUnspecified;
    }
    
    // Call this method when the user should be rewarded for watching the rewarded video.
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:[[MPRewardedVideoReward alloc] initWithCurrencyType:rewardType amount:[[NSNumber alloc] initWithInt:rewardAmount]]];
}

@end