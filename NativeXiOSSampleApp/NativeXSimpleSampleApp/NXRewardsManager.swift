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
    
    private let key = "NXCurrency"
    static let sharedInstance = NXRewardsManager()
    
    override init() {
        super.init()
        refresh()
    }

    private var rewards = [String: NXReward]()
    
    /*
    * Adds new reward for the given id. If the reward id already exists, combines
    * the amount.
    */
    func add( id: String, name: String, amount: Int ) {
        let newReward = NXReward(id: id, name: name, amount: amount)
        if let oldReward = rewards[id] {
            oldReward.combine(newReward)
        } else {
            rewards[id] = newReward
        }
    }
    
    func toList() -> [NXReward] {
        return rewards.values.map { NXReward( reward: $0) }
    }
    
    func toString() -> String {
        var result = "You haven't earned any rewards.\nGet to work!"
        if rewards.count > 0 {
            result = ""
            for r in rewards.values {
                result += "Id: \(r.id), Name: \(r.name), Amount: \(r.amount)\n"
            }
        }
        return result
    }
    
    /*
    * Commits rewards to local storage.
    */
    func commit() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var myRewards : [Dictionary<String,String>] = []
        for reward in rewards.values {
            myRewards.append([ "name" : reward.name, "id": reward.id, "amount" : String(reward.amount)  ])
        }
        defaults.setValue(myRewards, forKey: key)
    }

    /*
    * Restores rewards from local storage.
    */
    func refresh() {
        let defaults = NSUserDefaults.standardUserDefaults()
        rewards.removeAll()
        if let myRewards : [Dictionary<String,String>] = defaults.arrayForKey(key) as? [Dictionary<String,String>] {
            for o in myRewards {
                add( o["id"]!, name: o["name"]!, amount: Int(o["amount"]!) ?? 0)
            }
        }

        
    }
    
    /* 
    * Removes any stored currencies.
    *
    */
    func reset() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(key)
        rewards.removeAll()
    }
    
}

@objc
class NXReward : NSObject {
    
    let name : String
    let id : String
    var amount : Int = 0
    
    init( id: String, name: String, amount: Int ) {
        self.name = name
        self.id = id
        self.amount = amount
    }
    
    init( reward: NXReward ) {
        self.id = reward.id
        self.name = reward.name
        self.amount = reward.amount
    }
    
    func combine( reward: NXReward ) {
        if reward.id == self.id  {
            amount += reward.amount
        }
    }
    
}