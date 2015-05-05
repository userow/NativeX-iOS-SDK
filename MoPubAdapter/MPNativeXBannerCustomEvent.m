
#import "MPNativeXBannerCustomEvent.h"
#import "MPNativeXAdapterConstants.h"
#import "NativeXAdView.h"
#import "MPLogging.h"

@interface MPNativeXBannerCustomEvent()

@property(nonatomic)NSString* nativeXplacement;
@property(nonatomic)NSString* nativeXappId;
@property(nonatomic)int nativeXbannerPosition;

@end

@implementation MPNativeXBannerCustomEvent

@synthesize nativeXplacement = _nativeXplacement;

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{    
    [[NativeXSDK sharedInstance] setDelegate:(id)self];
    [[NSUserDefaults standardUserDefaults] setObject:@"MoPub" forKey:@"NativeXBuildType"];

    _nativeXappId = [info objectForKey:kMPNativeX_Key_appId];
    _nativeXplacement = [info objectForKey:kMPNativeX_Key_placementId];
    NSString* strBannerPosition = [info objectForKey:kMPNativeX_Key_bannerPosition];

    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"%s, %i, Cannot request interstitial, required placement name is missing or empty! appId=%@,", __func__, __LINE__, _nativeXappId);
        return;
    }
    
    if([strBannerPosition isEqualToString:kMPNativeXBannerPosotionTop]) {
        _nativeXbannerPosition = kBannerPositionTop;
    } else {
        _nativeXbannerPosition = kBannerPositionBottom;
        //also when the kMPNativeX_Key_bannerPostion is missing
    }
    
    //[[NativeXSDK sharedInstance] setShouldOutputDebugLog:YES];
    [[NativeXSDK sharedInstance] createSessionWithAppId:_nativeXappId];
}

#pragma mark NativeXSDKDelegate
- (void)nativeXSDKWillRedirectUser
{
    [self.delegate bannerCustomEventWillLeaveApplication:self];
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

-(void)nativeXSDKDidCreateSession
{
    if ((_nativeXplacement == nil) || ([_nativeXplacement length] == 0)) {
        MPLogError(@"%s, %i, Cannot fetch banner, required placement name is missing or empty! appId=%@,", __func__, __LINE__, _nativeXappId);
        return;
    }

    [[NativeXSDK sharedInstance] fetchBannerWithCustomPlacement:_nativeXplacement position:_nativeXbannerPosition delegate:self];
}

-(void)nativeXSDKDidFailToCreateSession:(NSError *)error
{
    MPLogError(@"%s, %i, Failed to create session, with appId=%@, placementId=%@", __func__, __LINE__, _nativeXappId, _nativeXplacement);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)nativeXSDKDidRedeemWithCurrencyInfo:(NativeXRedeemedCurrencyInfo *)redeemedCurrencyInfo
{
    //implement currency redemption for your users here
}

- (void)nativeXSDKDidRedeemWithError:(NSError *)error
{    
    MPLogError(@"%s, %i, Failed to redeem. appId=%@, placementId=%@, error=%@", __func__, __LINE__, _nativeXappId, _nativeXplacement, error);
}

#pragma mark NativeXAdViewDelegate
-(void)nativeXAdViewDidDismiss:(NativeXAdView *)adView
{
    [self.delegate bannerCustomEventDidFinishAction:self];
}

-(void)nativeXAdView:(NativeXAdView *)adView didFailWithError:(NSError *)error
{
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)nativeXAdView:(NativeXAdView *)adView didLoadWithPlacement:(NSString *)placement
{
    [adView displayAdView];
    [self.delegate bannerCustomEvent:self didLoadAd:[[NativeXAdView alloc] initWithFrame:adView.frame]];
}

- (void)nativeXAdViewNoAdContent:(NativeXAdView *)adView 
{
    NSError* err = [[NSError alloc] initWithDomain:kMPNativeXNoAdContentAvailable code:0 userInfo:@{}];
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:err];
}

@end
