//
//  AppState.swift
//  MeetingCost
//
//  Created by Esben von Buchwald on 26/05/15.
//  Copyright (c) 2015 Esben von Buchwald. All rights reserved.
//

import UIKit

enum StateEnumerator: Int {
    case Running
    case Stopped
    case Paused
}

class AppState: NSObject, NSCoding {
    var elapsed = 0
    var people = 0
    var price = 0
    var state = StateEnumerator.Stopped
    var startTime = NSDate()
    
    override init() {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        if let elapsed = aDecoder.decodeIntegerForKey("elapsed") as Int? {
            self.elapsed = elapsed
        }
        if let people = aDecoder.decodeIntegerForKey("people") as Int? {
            self.people = people
        }
        if let price = aDecoder.decodeIntegerForKey("price") as Int? {
            self.price = price
        }
        if let state = aDecoder.decodeObjectForKey("state") as? StateEnumerator {
            self.state = state
        }
        if let startTime = aDecoder.decodeObjectForKey("startTime") as? NSDate {
            self.startTime = startTime
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(elapsed, forKey: "elapsed")
        aCoder.encodeInteger(people, forKey: "people")
        aCoder.encodeInteger(price, forKey: "price")
        aCoder.encodeInteger(state.rawValue, forKey: "state")
        aCoder.encodeObject(startTime, forKey: "startTime")
    }
}
