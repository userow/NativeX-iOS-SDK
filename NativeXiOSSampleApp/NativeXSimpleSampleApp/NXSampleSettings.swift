//
//  NXSampleSettings.swift
//  NativeXSimpleSampleApp
//
//  Created by Matthew MacGregor on 11/3/15.
//  Copyright © 2015 NativeX. All rights reserved.
//

import Foundation

@objc
class NXSampleSettings : NSObject {

    static let sharedInstance = NXSampleSettings()
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let kAppId = "NX::AppId"
    private let kAppIdDefault = "20910"
    private let isMutedByUserKey = "NXKey::isMutedByUser"
    
    var appId : String {
        
        get {
            // Returns the Sample App Id by default
            return defaults.stringForKey(kAppId) ?? kAppIdDefault
        }
        
        set {
            if newValue.isEmpty == false {
                defaults.setValue(newValue, forKey: kAppId)
            }
        }
    }
    
    private var _isMutedByUser : Bool = false
    var isMutedByUser : Bool {
        get {
            _isMutedByUser = defaults.boolForKey(isMutedByUserKey)
            return _isMutedByUser
        }
        
        set( val ) {
            // Not only set the value, but set the volume for the audio player at the same time
            _isMutedByUser = val
            defaults.setBool(_isMutedByUser, forKey: isMutedByUserKey)
        }
    }
    
    var isAdShowing : Bool = false

    func resetDefaults() {
        self.appId = kAppIdDefault
        self.isMutedByUser = false
        
    }
    
}