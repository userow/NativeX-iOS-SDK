//
//  ViewController.h
//  NativeXSimpleSampleApp
//
//  Created by Melissa Johnson on 8/22/14.
//  Copyright (c) 2014 NativeX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NativeXSDK.h"
#import "NativeXSimpleSampleApp-Swift.h"

@interface ViewController : UIViewController <NativeXAdEventDelegate, NativeXRewardDelegate>

@property (weak, nonatomic) IBOutlet UIButton *showAdButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender;
- (IBAction)showAdClicked:(id)sender;
- (IBAction)mutePressed:(UIButton *)sender;

@end
