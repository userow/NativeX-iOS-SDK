
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kMPNativeX_Key_appId            @"appId"
#define kMPNativeX_Key_placementId      @"placementId"
#define kMPNativeX_Key_bannerPosition   @"bannerPosition"

#define kMPNativeXNoAdContentAvailable  @"No ad content available"
#define kMPNativeXBannerPosotionTop     @"bannerTop"

#ifndef ENABLE_DEBUG_LOG
#if DEBUG
// debug setting
#define ENABLE_DEBUG_LOG                NO
#else 
#define ENABLE_DEBUG_LOG                NO
#endif  // debug
#endif  // ifndef
