//
//  AppDelegate.h
//  NativeXSimpleSampleApp
//
//  Created by Melissa Johnson on 8/22/14.
//  Copyright (c) 2014 NativeX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NativeXSDK.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NativeXSDKDelegate, NativeXAdEventDelegate, NativeXRewardDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *view;

@property (nonatomic, strong) AVAudioPlayer* musicPlayer;

@end
