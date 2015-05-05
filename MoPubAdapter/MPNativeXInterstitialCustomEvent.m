#import "MPNativeXInterstitialCustomEvent.h"
#import "NativeXAdView.h"
#import "MPNativeXAdapterConstants.h"
#import "MPLogging.h"

@interface MPNativeXInterstitialCustomEvent ()

@property(nonatomic)NSString* nativeXplacement;
@property(nonatomic)NSString* nativeXappId;

@end

@implementation MPNativeXInterstitialCustomEvent

@synthesize nativeXplacement = _nativeXplacement;


#pragma mark - MPInterstitialCustomEvent Subclass Methods
- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    //[[NativeXSDK sharedInstance] setDelegate:(id)self];

    [[NSUserDefaults standardUserDefaults] setObject:@"MoPub" forKey:@"NativeXBuildType"];

    _nativeXappId = [info objectForKey:kMPNativeX_Key_appId];
    _nativeXplacement = [info objectForKey:kMPNativeX_Key_placementId];

    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);

    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"NXADAPTOR %s, %i, Cannot request interstitial, required placement name is missing or empty! placement=%@,", __func__, __LINE__, _nativeXplacement);
        return;
    }

    //[[NativeXSDK sharedInstance] setShouldOutputDebugLog:YES];

    [[NativeXSDK sharedInstance] fetchAdStatelessWithCustomPlacement:_nativeXplacement withAppId:_nativeXappId delegate:self];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);

    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"NXADAPTOR %s, %i, Cannot show interstitial, required placement name is missing or empty! placement=%@,", __func__, __LINE__, _nativeXplacement);
        return;
    }

    [[NativeXSDK sharedInstance] showReadyAdStatelessWithCustomPlacement:_nativeXplacement delegate:self];
}

#pragma mark NativeXAdViewDelegate
-(void)nativeXAdViewWillDisplay:(NativeXAdView *)adView
{
    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    [self.delegate interstitialCustomEventWillAppear:self];
}

-(void)nativeXAdViewDidDisplay:(NativeXAdView *)adView
{
    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    [self.delegate interstitialCustomEventDidAppear:self];
}

-(void)nativeXAdViewWillDismiss:(NativeXAdView *)adView
{
    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    [self.delegate interstitialCustomEventWillDisappear:self];
}

-(void)nativeXAdViewDidDismiss:(NativeXAdView *)adView
{
    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    [self.delegate interstitialCustomEventDidDisappear:self];
}

-(void)nativeXAdView:(NativeXAdView *)adView didFailWithError:(NSError *)error
{
    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)nativeXAdView:(NativeXAdView *)adView didLoadWithPlacement:(NSString *)placement
{
    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    [self.delegate interstitialCustomEvent:self didLoadAd:nil];
}

- (void)nativeXAdViewNoAdContent:(NativeXAdView *)adView
{
    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)nativeXAdViewWillRedirectUser:(NativeXAdView *)adView
{
    //MPLogInfo(@"NXADAPTOR -- %s [Line %d] -- placement=%@", __PRETTY_FUNCTION__, __LINE__, _nativeXplacement);
    [self.delegate interstitialCustomEventWillLeaveApplication: self];
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

@end
