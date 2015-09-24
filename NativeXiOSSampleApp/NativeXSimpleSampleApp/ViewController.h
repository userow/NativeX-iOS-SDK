//
//  ViewController.h
//  NativeXSimpleSampleApp
//
//  Created by Melissa Johnson on 8/22/14.
//  Copyright (c) 2014 NativeX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NativeXSDK.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *gameLaunch;
@property (weak, nonatomic) IBOutlet UIButton *mainMenu;
@property (weak, nonatomic) IBOutlet UIButton *levelFailed;
@property (weak, nonatomic) IBOutlet UIButton *storeOpen;

- (IBAction)gameLaunchButtonPressed:(id)sender;
- (IBAction)levelFailedButtonPressed:(id)sender;
- (IBAction)mainMenuButtonPressed:(id)sender;
- (IBAction)storeOpenButtonPressed:(id)sender;

- (void) setButtonforPlacement:(NSString *)placement enabled:(BOOL) enabled;


@end
