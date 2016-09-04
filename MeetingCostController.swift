//
//  MeetingCostController.swift
//  MeetingCost
//
//  Created by Esben von Buchwald on 04/09/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import Foundation

public class MeetingCostController: NSObject {
    var delegate: MeetingCostStatusDelegate?

    let appState = AppState.sharedInstance
    var currentDuration = 0
    var previousDuration = 0
    var cost: Double = 0.0
    var timer = NSTimer()

    
    static var sharedInstance: MeetingCostController = {
        let controller = MeetingCostController()
        controller.appState.delegates.append(controller)
        return controller
    }()
    
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
    
    func reload() {
        appState.reload()
        print("CONTINUE")
        print (appState.startTime)
        switch appState.state {
        case .Running:
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(clockTick), userInfo: nil, repeats: true)
            delegate?.statusStarted()
        case .Paused:
            timer.invalidate()
            delegate?.statusPaused()
            previousDuration = appState.elapsed        // TODO: Check if this is always correct
        case .Stopped:
            timer.invalidate()
            delegate?.statusReset()
        }
        
        updateCost()
        delegate?.statusUpdate()
    }
}

extension MeetingCostController: AppStateDelegate {
    func appStateUpdate() {
        updateCost()
    }
}


public protocol MeetingCostStatusDelegate {
    func statusStarted()
    func statusPaused()
    func statusReset()
    func statusUpdate()
}
