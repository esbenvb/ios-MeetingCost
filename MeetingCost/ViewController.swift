//
//  ViewController.swift
//  MeetingCost
//
//  Created by Esben von Buchwald on 28/03/15.
//  Copyright (c) 2015 Esben von Buchwald. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var appState = AppState() {
        didSet {
            continueAfterLoading()
        }
    }

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var peopleSlider: UISlider!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    var currentDuration = 0
    var previousDuration = 0
    
    var cost: Float = 0.0
        
    var timer = NSTimer()
    
    var formatter = NSDateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        priceSlider.minimumValue = log(1.45) // Make it start at 1 but close to 2
        priceSlider.maximumValue = log(2000)
        
        
        peopleSlider.minimumValue = log(2.45) // Make it start at 2 but close to 3
        peopleSlider.maximumValue = log(100)

        startButton.setTitle("Start", forState: UIControlState.Normal)
        resetButton.setTitle("Reset", forState: UIControlState.Normal)
        
        if let state = AppState.loadState() {
            appState = state
        }
        
        updateSliders()
        updateCost()
    }
    
    func updateSliders() {
        peopleSlider?.value = log(Float(appState.people))
        peopleSliderChange()
        priceSlider?.value = log(Float(appState.price))
        priceSliderChange()
    }
    
    func clockTick() {
        currentDuration = Int(NSDate().timeIntervalSinceDate(appState.startTime))
        appState.elapsed = currentDuration + previousDuration
        updateCost()
    }
    
    func updateCost() {
        cost = Float(appState.elapsed * appState.people * appState.price) / 60 / 60
        totalCostLabel!.text = String(format: "%.02f", cost)
        durationLabel!.text = durationToString(appState.elapsed)
    }
    
    @IBAction func startButtonPressed() {
        switch appState.state{
        // Pause
        case .Running:
            controlPause()
        // Continue
        case .Paused:
            controlStart()
        // Start
        case .Stopped:
            controlStart()
        }
        NSLog("Start")
    }
    
    func continueAfterLoading() {
        print("CONTINUE")
        print (appState.startTime)
        switch appState.state {
        case .Running:
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.clockTick), userInfo: nil, repeats: true)
            startButton!.setTitle("Pause", forState: .Normal)
            resetButton!.enabled = false
        case .Paused:
            startButton!.setTitle("Continue", forState: .Normal)
            resetButton!.enabled = true
            previousDuration = appState.elapsed
        case .Stopped:
            self.controlReset()
            resetButton!.enabled = false
            startButton!.setTitle("Start", forState: .Normal)
        }
        updateCost()
    }
    
    func controlStart() {
        appState.state = .Running
        appState.startTime = NSDate()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.clockTick), userInfo: nil, repeats: true)
        startButton!.setTitle("Pause", forState: .Normal)
        resetButton!.enabled = false
    }

    func controlPause() {
        appState.state = .Paused
        previousDuration = appState.elapsed
        timer.invalidate()
        startButton!.setTitle("Continue", forState: .Normal)
        resetButton!.enabled = true
    }

    func controlReset() {
        appState.state = .Stopped
        appState.elapsed = 0
        timer.invalidate()
        appState.startTime = NSDate()
        currentDuration = 0
        previousDuration = 0
        updateCost()
        resetButton!.enabled = false
        startButton!.setTitle("Start", forState: .Normal)
    }
    
    @IBAction func resetButtonPressed() {
        controlReset()
        NSLog("Reset")
    }

    @IBAction func priceSliderChange() {
        appState.price = Int(round(exp(Double(priceSlider!.value))))
        updateCost()
        priceLabel!.text = "\(appState.price)"
    }
    
    @IBAction func peopleSliderChange() {
        appState.people = Int(round(exp(Double(peopleSlider!.value))))
        updateCost()
        peopleLabel!.text = "\(appState.people)"
    }

    func durationToString (duration: Int) -> String {
        let hours = duration / 60 / 60
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds)
    }

}

