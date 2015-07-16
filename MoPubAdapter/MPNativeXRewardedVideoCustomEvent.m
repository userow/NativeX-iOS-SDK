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


@interface MPNativeXRewardedVideoCustomEvent () <NativeXAdViewDelegate, NativeXRewardDelegate>

@property(nonatomic)NSString* nativeXplacement;
@property(nonatomic)NSString* nativeXappId;
@property(nonatomic) BOOL   converted;

@property (nonatomic) BOOL bEnableLoggging;

@end

@implementation MPNativeXRewardedVideoCustomEvent

#pragma mark MPRewardedVideoCustomEvent override methods
// Called when the MoPub SDK requires a new rewarded video ad.
- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    // default debugging
    self.bEnableLoggging = YES;
    
    // todo: call createsession and stuff
    [[NSUserDefaults standardUserDefaults] setObject:@"MoPub" forKey:@"NativeXBuildType"];
    
    _nativeXappId = [info objectForKey:kMPNativeX_Key_appId];
    _nativeXplacement = [info objectForKey:kMPNativeX_Key_placementId];
    
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    
    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"Cannot request rewarded video, required placement name is missing or empty!");
        return;
    }
    
    _converted = NO;
    
    [[NativeXSDK sharedInstance] setShouldOutputDebugLog:self.bEnableLoggging];
    
    [[NativeXSDK sharedInstance] fetchAdStatelessWithCustomPlacement:_nativeXplacement withAppId:_nativeXappId delegate:self];
}

// Called when the MoPubSDK wants to know if an ad is currently available for the ad network.
- (BOOL)hasAdAvailable
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);

    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"Required placement name is missing or empty! No ad is available");
        return NO;
    }

    //return [[NativeXSDK sharedInstance] isAdReadyWithCustomPlacement:_nativeXplacement];
    return [[NativeXSDK sharedInstance] isStatelessAdReadyWithCustomPlacement:_nativeXplacement delegate:self];
}

// Called when the rewarded video should be displayed.
- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    
    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"Cannot show rewarded video, required placement name is missing or empty!");
        return;
    }
    
    [[NativeXSDK sharedInstance] showReadyAdStatelessWithCustomPlacement:_nativeXplacement delegate:self];
}

//Override this method to handle when the custom event is no longer needed by the rewarded video system.
- (void)handleCustomEventInvalidated
{
    // we don't need any cleanup code..
}


#pragma mark NativeXAdViewDelegate methods


// we're not using mediation settings, so not implementing this..
// Call this method to retrieve a mediation settings object (if one is provided by the application) for this instance of your ad.
//- (id<MPMediationSettingsProtocol>)instanceMediationSettingsForClass:(Class)aClass;

- (void)nativeXAdView:(NativeXAdView *)adView didLoadWithPlacement:(NSString *)placement
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method immediately after an ad loads succesfully.
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

- (void)nativeXAdViewNoAdContent:(NativeXAdView *)adView
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method immediately after an ad fails to load.
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self error:nil];
}

- (void)nativeXAdView:(NativeXAdView *)adView didFailWithError:(NSError *)error
{
    if (self.bEnableLoggging) MPLogError(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    MPLogError(@"Ad failed to load with error=%@", error);
    
    // Call this method when the application has attempted to play a rewarded video and it cannot be played.
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self error:error];
}

- (void)nativeXAdViewDidExpire:(NativeXAdView *)adView
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method if a previously loaded rewarded video should no longer be eligible for presentation.
    [self.delegate rewardedVideoDidExpireForCustomEvent:self];
}

- (void)nativeXAdViewWillDisplay:(NativeXAdView *)adView
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method when an ad is about to appear.
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

- (void)nativeXAdViewDidDisplay:(NativeXAdView *)adView
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method when an ad has finished appearing.
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

- (void)nativeXAdViewWillDismiss:(NativeXAdView *)adView
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method when an ad is about to disappear.
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
}

- (void)nativeXAdViewDidDismiss:(NativeXAdView *)adView
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method when an ad has finished disappearing.
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
    
    if (_converted) {
        [[NativeXSDK sharedInstance] redeemStatelessRewards:self];
        // reset converted state, in case this object is reused..
        _converted = NO;
    }
}

- (void)nativeXAdViewWillRedirectUser:(NativeXAdView *)adView
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    // Call this method when the rewarded video ad will cause the user to leave the application.
    [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
    
    // Call this method when the user taps on the rewarded video ad.
    // **Note**: some third-party networks provide a "will leave application" callback instead of/in
    // addition to a "user did click" callback. You should call this method in response to either of
    // those callbacks (since leaving the application is generally an indicator of a user tap).
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
}

- (void)nativeXAdViewAdConverted:(NSString*) placementName
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    _converted = YES;
}

#pragma mark NativeXRewardDelegate protocol implementation

- (void)rewardDidRedeemWithError:(NSError *)error
{
    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    
    // if we have an error, we're not rewarding the user with anything..
    MPLogError(@"Reward redemption failed, error:%@", error);
   
}

- (void)rewardDidRedeemWithRewardInfo:(NativeXRewardInfo*)rewardInfo
{

    if (self.bEnableLoggging) MPLogInfo(@"[nxVidAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    
    if ([rewardInfo.rewards count] <= 0){
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