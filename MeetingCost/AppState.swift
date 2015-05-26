//
//  AppState.swift
//  MeetingCost
//
//  Created by Esben von Buchwald on 26/05/15.
//  Copyright (c) 2015 Esben von Buchwald. All rights reserved.
//

import UIKit

enum StateEnumerator {
    case Running
    case Stopped
    case Paused
}

class AppState: NSObject {
    var elapsed = 0
    var people = 0
    var price = 0
    var state = StateEnumerator.Stopped
    var startTime = NSDate()
}
