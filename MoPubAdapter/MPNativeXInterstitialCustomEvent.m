#import "MPNativeXInterstitialCustomEvent.h"
#import "NativeXAdView.h"
#import "MPNativeXAdapterConstants.h"
#import "MPLogging.h"

@interface MPNativeXInterstitialCustomEvent () <NativeXAdEventDelegate>

@property(nonatomic)NSString* nativeXplacement;
@property(nonatomic)NSString* nativeXappId;
@property(nonatomic) BOOL   impressionFired;
@property(nonatomic) BOOL   clickFired;

@end

@implementation MPNativeXInterstitialCustomEvent

@synthesize nativeXplacement = _nativeXplacement;


#pragma mark - MPInterstitialCustomEvent Subclass Methods
//---------------------------------------------------------------------------
- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    //[[NativeXSDK sharedInstance] setDelegate:(id)self];

    [[NSUserDefaults standardUserDefaults] setObject:@"MoPub" forKey:@"NativeXBuildType"];

    _nativeXappId = [info objectForKey:kMPNativeX_Key_appId];
    _nativeXplacement = [info objectForKey:kMPNativeX_Key_placementId];
    
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);

    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"[nxIstlAdapter] %s, %i, Cannot request interstitial, required placement name is missing or empty! placement=%@,", __func__, __LINE__, _nativeXplacement);
        return;
    }

    [NativeXSDK enableDebugLog:ENABLE_DEBUG_LOG];
    NSString* sessionID = [NativeXSDK getSessionId];
    // TODO: is initialized, can initialize maybe??
    if ((sessionID == nil) || ([sessionID length] == 0)) {
        [NativeXSDK initializeWithAppId:_nativeXappId];
    }
    
    _impressionFired = NO;
    _clickFired = NO;

    // queue up fetch
    [NativeXSDK fetchAdWithName:_nativeXplacement andFetchDelegate:self];
}

//---------------------------------------------------------------------------
- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);

    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"[nxIstlAdapter] %s, %i, Cannot show interstitial, required placement name is missing or empty! placement=%@,", __func__, __LINE__, _nativeXplacement);
        return;
    }

    [NativeXSDK showAdWithName:_nativeXplacement andShowDelegate:self rootViewController:rootViewController];
}

//---------------------------------------------------------------------------
- (BOOL) enableAutomaticImpressionAndClickTracking
{
    // we're not doing automatic impression and click; so we're handing these explicitly
    return NO;
}

#pragma mark NativeXAdEventDelegate protocol impl

#pragma mark fetch methods
//---------------------------------------------------------------------------
- (void) adFetched:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    [self.delegate interstitialCustomEvent:self didLoadAd:nil];
}
//---------------------------------------------------------------------------
- (void) adFetchFailed:(NSString *)placementName withError:(NSError *)error
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    MPLogError(@"Ad failed to load with error=%@", error);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}
//---------------------------------------------------------------------------
- (void) noAdAvailable:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    MPLogError(@"Ad failed to load; no ad available");
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

#pragma mark show methods

//---------------------------------------------------------------------------
- (void) adExpired:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    [self.delegate interstitialCustomEventDidExpire:self];
}
//---------------------------------------------------------------------------
- (void) adShown:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    // since we're discontinuing willShow, need to fire both on shown
    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidAppear:self];
}
//---------------------------------------------------------------------------
- (void) adFailedToShow:(NSString *)placementName withError:(NSError *)error
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    MPLogError(@"Ad failed to show with error=%@", error);
}
//---------------------------------------------------------------------------
- (void) adImpressionConfirmed:(NSString *)placementName
{
    // since we're not doing automatic impression tracking, fire explicitly
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    if (_impressionFired == NO) {
        [self.delegate trackImpression];
        _impressionFired = YES;
    }
}
//---------------------------------------------------------------------------
- (void) userRedirected:(NSString *)placementName
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    // since we're not doing automatic impression tracking, fire explicitly
    if (_clickFired == NO) {
        [self.delegate trackClick];
        _clickFired = YES;
    }
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication: self];
}
//---------------------------------------------------------------------------
- (void) adDismissed:(NSString *)placementName converted:(BOOL)converted
{
    if (ENABLE_DEBUG_LOG) MPLogInfo(@"[nxIstlAdapter] -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, placementName);
    // since willDismiss is discontinued, need to fire both on dismissed
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

@end
