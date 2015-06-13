//
//  ViewController.swift
//  MeetingCost
//
//  Created by Esben von Buchwald on 28/03/15.
//  Copyright (c) 2015 Esben von Buchwald. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var appState = AppState()
    
    let durationLabelPrefix = "Duration: "
    let costLabelPrefix = "Cost: "
    
    var priceLabel: UILabel?
    var priceSlider: UISlider?
    
    var peopleLabel: UILabel?
    var peopleSlider: UISlider?
    
    var startButton: UIButton?
    var resetButton: UIButton?

    var durationLabel: UILabel?
    var totalCostLabel: UILabel?
    
    var currentDuration = 0
    var previousDuration = 0
    
    var cost: Float = 0.0
        
    var timer = NSTimer()
    
    var formatter = NSDateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var priceTopLabel = UILabel(frame: CGRectMake(10, 30, 320, 20))
        priceTopLabel.text = "Average hourly price or salary"
        self.view.addSubview(priceTopLabel)

        priceSlider = UISlider(frame: CGRectMake(10, 70, 320, 20))
        priceSlider!.minimumValue = log(1.45) // Make it start at 1 but close to 2
        priceSlider!.maximumValue = log(2000)
        priceSlider!.continuous = true
        priceSlider!.addTarget(self, action: Selector("priceSliderChange"), forControlEvents: .ValueChanged)
        self.view.addSubview(priceSlider!)
        
        priceLabel = UILabel(frame: CGRectMake(10, 110, 320, 20))
        priceLabel!.text = "\(appState.price)"
        self.view.addSubview(priceLabel!)

        var peopleTopLabel = UILabel(frame: CGRectMake(10, 130, 320, 20))
        peopleTopLabel.text = "Number of people"
        self.view.addSubview(peopleTopLabel)
        
        peopleSlider = UISlider(frame: CGRectMake(10, 170, 320, 20))
        peopleSlider!.minimumValue = log(2.45) // Make it start at 2 but close to 3
        peopleSlider!.maximumValue = log(100)
        peopleSlider!.continuous = true
        peopleSlider!.addTarget(self, action: Selector("peopleSliderChange"), forControlEvents: .ValueChanged)
        self.view.addSubview(peopleSlider!)
        
        peopleLabel = UILabel(frame: CGRectMake(10, 210, 100, 20))
        peopleLabel!.text = "\(appState.people)"
        self.view.addSubview(peopleLabel!)

        startButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        startButton!.frame = CGRectMake(10, 230, 80, 40)
        startButton!.setTitle("Start", forState: UIControlState.Normal)
        startButton!.addTarget(self, action: Selector("startButtonPressed"), forControlEvents: .TouchUpInside)
        self.view.addSubview(startButton!)

        
        resetButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        resetButton!.frame = CGRectMake(150, 230, 80, 40)
        resetButton!.setTitle("Reset", forState: UIControlState.Normal)
        resetButton!.addTarget(self, action: Selector("resetButtonPressed"), forControlEvents: .TouchUpInside)
        self.view.addSubview(resetButton!)
        
        durationLabel = UILabel(frame: CGRectMake(10, 290, 320, 20))
        durationLabel!.text = durationLabelPrefix + durationToString(appState.elapsed)
        self.view.addSubview(durationLabel!)

        totalCostLabel = UILabel(frame: CGRectMake(10, 320, 320, 20))
        
        updateSliders()
        updateCost()
    
        self.view.addSubview(totalCostLabel!)

        
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
        durationLabel!.text = durationLabelPrefix + durationToString(appState.elapsed)
        updateCost()
    }
    
    func updateCost() {
        cost = Float(appState.elapsed * appState.people * appState.price) / 60 / 60
        totalCostLabel!.text = costLabelPrefix + String(format: "%.02f", cost)

    }
    
    func startButtonPressed() {
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
    
    func controlStart() {
        appState.state = .Running
        appState.startTime = NSDate()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("clockTick"), userInfo: nil, repeats: true)
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
        durationLabel!.text = durationLabelPrefix + durationToString(appState.elapsed)
        resetButton!.enabled = false
        startButton!.setTitle("Start", forState: .Normal)
        
    }
    
    func resetButtonPressed() {
        controlReset()
        NSLog("Reset")
    }

    func priceSliderChange() {
        appState.price = Int(round(exp(Double(priceSlider!.value))))
        updateCost()
        priceLabel!.text = "\(appState.price)"
    }
    
    func peopleSliderChange() {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

