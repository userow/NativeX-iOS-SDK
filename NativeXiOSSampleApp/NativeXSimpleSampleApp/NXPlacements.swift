//
//  NXPlacements.swift
//  NativeXSimpleSampleApp
//
//  Created by Matthew MacGregor on 11/3/15.
//  Copyright © 2015 NativeX. All rights reserved.
//

import Foundation

@objc
class NXPlacements : NSObject {
    
    static let sharedInstance = NXPlacements()
    
    private let placementNames = ["Game Launch",
                                    "Main Menu Screen",
                                    "Pause Menu Screen",
                                    "Player Generated Event",
                                    "Level Completed",
                                    "Level Failed",
                                    "Player Levels Up",
                                    "P2P competition won",
                                    "P2P competition lost",
                                    "Store Open",
                                    "Exit Ad from Application"]
    
    func mapIdToName( id: Int ) -> String {
        return placementNames[id]
    }
    
    func mapNameToId( name: String ) -> Int {
        return placementNames.indexOf(name) ?? -1
    }
    
    func count() -> Int {
        return placementNames.count
    }
    
}