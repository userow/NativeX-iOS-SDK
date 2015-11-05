//
//  NXRewardsManager.swift
//  NativeXSimpleSampleApp
//
//  Created by Matthew MacGregor on 11/3/15.
//  Copyright © 2015 NativeX. All rights reserved.
//

import Foundation


@objc
class NXRewardsManager : NSObject  {
    
    static let sharedInstance = NXRewardsManager()
    
    override init() {
        super.init()
        refresh()
    }
    
    var amount : Int = 0
    let rewardName : String = "X Bucks"
    let rewardId : String = "xbucks"

    func commit() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(amount, forKey: "NXCurrency::" + rewardId)
    }
    
    func refresh() {
        let defaults = NSUserDefaults.standardUserDefaults()
        amount = defaults.integerForKey("NXCurrency::" + rewardId);
    }
}