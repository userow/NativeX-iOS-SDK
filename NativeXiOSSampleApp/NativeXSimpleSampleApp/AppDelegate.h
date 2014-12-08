//
//  AppDelegate.h
//  NativeXSimpleSampleApp
//
//  Created by Melissa Johnson on 8/22/14.
//  Copyright (c) 2014 NativeX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NativeXSDK.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NativeXSDKDelegate, NativeXAdViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *view;

@end
