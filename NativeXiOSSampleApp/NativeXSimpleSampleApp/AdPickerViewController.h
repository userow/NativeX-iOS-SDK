//
//  ViewController.h
//  NativeXSimpleSampleApp
//
//  Created by Matthew MacGregor November 2015.
//  Copyright (c) 2015 NativeX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NativeXSDK.h"
#import "NativeXSimpleSampleApp-Swift.h"

@interface AdPickerViewController : UIViewController <NativeXAdEventDelegate, NativeXRewardDelegate> 

@property (weak, nonatomic) IBOutlet UIButton *showAdButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)showAdClicked:(id)sender;

@end
