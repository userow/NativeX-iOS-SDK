
#import "MPBannerCustomEvent.h"
#import "NativeXSDK.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface MPNativeXBannerCustomEvent : MPBannerCustomEvent <NativeXSDKDelegate, NativeXAdViewDelegate>
#pragma clang diagnostic pop

@end
