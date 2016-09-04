//
//  MeetingCostController.swift
//  MeetingCost
//
//  Created by Esben von Buchwald on 04/09/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

class MeetingCostController: NSObject {
    var delegate: MeetingCostStatusDelegate? {
        didSet {
            print("CONTINUE")
            print (appState.startTime)
            switch appState.state {
            case .Running:
                timer.invalidate()
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(clockTick), userInfo: nil, repeats: true)
                delegate?.statusStarted()
            case .Paused:
                delegate?.statusPaused()
                previousDuration = appState.elapsed
            case .Stopped:
                delegate?.statusReset()
            }
            updateCost()
            delegate?.statusUpdate()
        }
    }

    let appState = AppState.sharedInstance
    var currentDuration = 0
    var previousDuration = 0
    var cost: Double = 0.0
    var timer = NSTimer()

    override init() {
        super.init()
        appState.delegates.append(self)
    }
    
    
    func clockTick() {
        currentDuration = Int(NSDate().timeIntervalSinceDate(appState.startTime))
        appState.elapsed = currentDuration + previousDuration
        updateCost()
    }
    
    func updateCost() {
        cost = Double(appState.elapsed * appState.people * appState.price) / 60 / 60
        delegate?.statusUpdate()
    }

    func start() {
        appState.state = .Running
        appState.startTime = NSDate()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(clockTick), userInfo: nil, repeats: true)
        delegate?.statusStarted()
    }
    
    func pause() {
        appState.state = .Paused
        previousDuration = appState.elapsed
        timer.invalidate()
        delegate?.statusPaused()
    }
    
    func reset() {
        appState.state = .Stopped
        appState.elapsed = 0
        timer.invalidate()
        appState.startTime = NSDate()
        currentDuration = 0
        previousDuration = 0
        updateCost()
        delegate?.statusReset()
        delegate?.statusUpdate()
    }
}

extension MeetingCostController: AppStateDelegate {
    func appStateUpdate() {
        updateCost()
    }
}
