//
//  ViewController.swift
//  MeetingCost
//
//  Created by Esben von Buchwald on 28/03/15.
//  Copyright (c) 2015 Esben von Buchwald. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSlider: UISlider!

    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var peopleSlider: UISlider!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!

    var formatter = NSDateFormatter()
    
    var controller = MeetingCostController()


    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.setTitle("Start", forState: UIControlState.Normal)
        resetButton.setTitle("Reset", forState: UIControlState.Normal)

        controller.delegate = self
        
        priceSlider.minimumValue = log(1.45) // Make it start at 1 but close to 2
        priceSlider.maximumValue = log(2000)
        peopleSlider.minimumValue = log(2.45) // Make it start at 2 but close to 3
        peopleSlider.maximumValue = log(100)
        updateSliders()
    }

    func updateSliders() {
        peopleSlider?.value = log(Float(controller.appState.people))
        peopleSliderChange()
        priceSlider?.value = log(Float(controller.appState.price))
        priceSliderChange()
    }

    @IBAction func startButtonPressed() {
        switch controller.appState.state {
        // Pause
        case .Running:
            controller.pause()
        // Continue
        case .Paused:
            controller.start()
        // Start
        case .Stopped:
            controller.start()
        }
        NSLog("Start")
    }

    @IBAction func resetButtonPressed() {
        controller.reset()
        NSLog("Reset")
    }

    @IBAction func priceSliderChange() {
        controller.appState.price = Int(round(exp(Double(priceSlider!.value))))
        priceLabel!.text = "\(controller.appState.price)"
    }

    @IBAction func peopleSliderChange() {
        controller.appState.people = Int(round(exp(Double(peopleSlider!.value))))
        peopleLabel!.text = "\(controller.appState.people)"
    }

    func durationToString (duration: Int) -> String {
        // TODO: Number formatter based on locale
        let hours = duration / 60 / 60
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension ViewController: MeetingCostStatusDelegate {
    func statusStarted() {
        startButton.setTitle("Pause", forState: .Normal)
        resetButton.enabled = false
    }
    
    func statusUpdate() {
        durationLabel!.text = durationToString(controller.appState.elapsed)
        totalCostLabel!.text = String(format: "%.02f", controller.cost)
    }

    func statusReset() {
        resetButton.enabled = false
        startButton.setTitle("Start", forState: .Normal)
    }
    
    func statusPaused() {
        startButton.setTitle("Continue", forState: .Normal)
        resetButton.enabled = true
    }
}

protocol MeetingCostStatusDelegate {
    func statusStarted()
    func statusPaused()
    func statusReset()
    func statusUpdate()
}
