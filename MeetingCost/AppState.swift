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

struct AppStateKeys {
    static let elapsed = "ElapsedKey"
    static let people = "PeopleKey"
    static let price = "PriceKey"
    static let state = "StateKey"
    static let startTime = "StartTimeKey"
}

class AppState: NSObject {
    static var sharedInstance = AppState.loadState()

    var delegates: [AppStateDelegate] = []
    
    var elapsed = 0
    var people = 0 {
        didSet {
            if oldValue != people {
                saveState()
            }
        }
    }
    var price = 0 {
        didSet {
            if oldValue != price {
                saveState()
            }
        }
    }
    var state = StateEnumerator.Stopped {
        didSet {
            if oldValue != state {
                saveState()
            }
        }
    }
    var startTime = NSDate()

    override init() {}

    init(elapsed: Int, people: Int, price: Int, state: StateEnumerator, startTime: NSDate) {
        self.elapsed = elapsed
        self.people = people
        self.price = price
        self.state = state
        self.startTime = startTime
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let elapsed = aDecoder.decodeIntegerForKey(AppStateKeys.elapsed)
        let people = aDecoder.decodeIntegerForKey(AppStateKeys.people)
        let price = aDecoder.decodeIntegerForKey(AppStateKeys.price)
        var startTime: NSDate
        if let time = aDecoder.decodeObjectOfClass(NSDate.self, forKey: AppStateKeys.startTime) {
            startTime = time
        } else {
            startTime = NSDate()
        }

        let state = StateEnumerator(rawValue: aDecoder.decodeIntegerForKey(AppStateKeys.state))!
        self.init(elapsed: elapsed, people: people, price: price, state: state, startTime: startTime)
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(elapsed, forKey: AppStateKeys.elapsed)
        aCoder.encodeInteger(people, forKey: AppStateKeys.people)
        aCoder.encodeInteger(price, forKey: AppStateKeys.price)
        aCoder.encodeInteger(state.rawValue, forKey: AppStateKeys.state)
        aCoder.encodeObject(startTime, forKey: AppStateKeys.startTime)
    }

    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("MeetingCostState")

    class func loadState() -> AppState {
        guard let state = NSKeyedUnarchiver.unarchiveObjectWithFile(AppState.ArchiveURL.path!) as? AppState else {
            return AppState()
        }
        print("LOADING")
        print (state.startTime ?? "")
        return state
    }

    func saveState() -> Bool {
        for delegate in delegates {
            delegate.appStateUpdate()
        }
        print("SAVING")
        print(startTime)
        return NSKeyedArchiver.archiveRootObject(self, toFile: AppState.ArchiveURL.path!)
    }
}

protocol AppStateDelegate {
    func appStateUpdate()
}
