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
    
  /*  let durationLabelPrefix = "Duration: "
    let costLabelPrefix = "Cost: "
    
    var priceLabel: UILabel?
    var priceSlider: UISlider?
    
    var peopleLabel: UILabel?
    var peopleSlider: UISlider?
    
    var startButton: UIButton?
    var resetButton: UIButton?

    var durationLabel: UILabel?
    var totalCostLabel: UILabel?
    */
    var currentDuration = 0
    var previousDuration = 0
    
    var cost: Float = 0.0
        
    var timer = NSTimer()
    
    var formatter = NSDateFormatter()

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    @IBOutlet weak var slidersView: SlidersView!
    weak var participantsSlider: UISlider!
    weak var participantsLabel: UILabel!
    weak var salarySlider: UISlider!
    weak var salaryLabel: UILabel!
    
    @IBOutlet weak var controlsView: ControlsView!
    weak var startButton: UIButton!
    weak var resetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton = controlsView.startButton
        resetButton = controlsView.resetButton
        participantsLabel = slidersView.participantsLabel
        participantsSlider = slidersView.participantsSlider
        salaryLabel = slidersView.salaryLabel
        salarySlider = slidersView.salarySlider
        
        salarySlider.minimumValue = log(1.45)
        salarySlider.maximumValue = log(2000)
        salarySlider.continuous = true
        salarySlider.addTarget(self, action: Selector("priceSliderChange"), forControlEvents: .ValueChanged)
        salaryLabel.text = "0"
        
        
        participantsSlider.minimumValue = log(2.45) // Make it start at 2 but close to 3
        participantsSlider.maximumValue = log(250)
        participantsSlider.continuous = true
        participantsSlider.addTarget(self, action: Selector("peopleSliderChange"), forControlEvents: .ValueChanged)
        participantsLabel.text = "0"

        startButton.setTitle("Start", forState: UIControlState.Normal)
        startButton.addTarget(self, action: Selector("startButtonPressed"), forControlEvents: .TouchUpInside)

        
        resetButton.setTitle("Reset", forState: UIControlState.Normal)
        resetButton.addTarget(self, action: Selector("resetButtonPressed"), forControlEvents: .TouchUpInside)
        
        updateSliders()
        updateCost()
    
        
    }
    func updateSliders() {
        participantsSlider.value = log(Float(appState.people))
        peopleSliderChange()
        salarySlider.value = log(Float(appState.price))
        priceSliderChange()
    }
    
    func clockTick() {
        currentDuration = Int(NSDate().timeIntervalSinceDate(appState.startTime))
        appState.elapsed = currentDuration + previousDuration
        durationLabel.text = durationToString(appState.elapsed)
        updateCost()
    }
    
    func updateCost() {
        cost = Float(appState.elapsed * appState.people * appState.price) / 60 / 60
        resultLabel.text = String(format: "%.02f", cost)

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
        startButton.setTitle("Pause", forState: .Normal)
        resetButton.enabled = false
    }

    func controlPause() {
        appState.state = .Paused
        previousDuration = appState.elapsed
        timer.invalidate()
        startButton.setTitle("Continue", forState: .Normal)
        resetButton.enabled = true
    }

    func controlReset() {
        appState.state = .Stopped
        appState.elapsed = 0
        timer.invalidate()
        appState.startTime = NSDate()
        currentDuration = 0
        previousDuration = 0
        updateCost()
        durationLabel.text = durationToString(appState.elapsed)
        resetButton.enabled = false
        startButton.setTitle("Start", forState: .Normal)
        
    }
    
    func resetButtonPressed() {
        controlReset()
        NSLog("Reset")
    }

    func priceSliderChange() {
        guard let slider = salarySlider else { return }
        appState.price = Int(round(exp(Double(slider.value))))
        updateCost()
        salaryLabel.text = "\(appState.price)"
    }

    func peopleSliderChange() {
        guard let slider = participantsSlider else { return }
        appState.people = Int(round(exp(Double(slider.value))))
        updateCost()
        participantsLabel.text = "\(appState.people)"
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

