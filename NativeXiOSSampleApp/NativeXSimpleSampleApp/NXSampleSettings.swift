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
    private var _isAdShowing : Bool = false
    
    var appId : String {
        
        get {
            // Hardcoded NativeX AppId for the Sample App
            return "20910"
        }
        
    }
    
    var isAdShowing : Bool {
        get {
            return _isAdShowing
        }
        set ( newVal ) {
            _isAdShowing = newVal
        }
        
    }
    

}