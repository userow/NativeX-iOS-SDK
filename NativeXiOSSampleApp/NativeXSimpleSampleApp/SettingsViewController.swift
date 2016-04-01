//
//  SettingsViewController.swift
//  NativeXSimpleSampleApp
//
//  Created by Matthew MacGregor on 11/10/15.
//  Copyright © 2015 NativeX. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var appIdTextField: UITextField!
    @IBOutlet weak var enableAudioSwitch: UISwitch!
    @IBOutlet weak var rewardsTextArea: UITextView!
    
    private var doesSessionNeedRefresh = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        appIdTextField.text = NXSampleSettings.sharedInstance.appId
        rewardsTextArea.text = NXRewardsManager.sharedInstance.toString()
        enableAudioSwitch.on = NXSampleSettings.sharedInstance.isMutedByUser
        appIdTextField.returnKeyType = UIReturnKeyType.Done
        self.addDoneButtonToKeyboard()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetToDefaultClicked(sender: UIButton) {
        NXSampleSettings.sharedInstance.resetDefaults()
        appIdTextField.text = NXSampleSettings.sharedInstance.appId
        enableAudioSwitch.on = false
        NXMusicMaster.sharedInstance.autoMute()
        NXRewardsManager.sharedInstance.reset()
        rewardsTextArea.text = NXRewardsManager.sharedInstance.toString()
    }
    
    @IBAction func saveButtonClicked(sender: UIBarButtonItem) {
        NXSampleSettings.sharedInstance.appId = appIdTextField.text ?? ""
        if doesSessionNeedRefresh {
            NativeXSDK.sharedInstance().resetSession()
            NativeXSDK.initializeWithAppId(NXSampleSettings.sharedInstance.appId)
        }
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func appIdEditingChanged(sender: UITextField) {
        doesSessionNeedRefresh = true
    }
    
    @IBAction func enableAudioDidToggle(sender: UISwitch) {
        NXSampleSettings.sharedInstance.isMutedByUser = sender.on
        NXMusicMaster.sharedInstance.autoMute()
    }
    
    
    func addDoneButtonToKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(keyboardDoneButtonClicked))
        
        UIToolbar.appearance().tintColor = NXColors.citrus
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()

        appIdTextField.inputAccessoryView = doneToolbar
    
    }
    
    func keyboardDoneButtonClicked()
    {
        appIdTextField.resignFirstResponder()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
