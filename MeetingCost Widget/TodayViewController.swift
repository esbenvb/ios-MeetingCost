//
//  TodayViewController.swift
//  MeetingCost Widget
//
//  Created by Esben von Buchwald on 04/09/16.
//  Copyright © 2016 Esben von Buchwald. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func startButtonClicked(sender: AnyObject) {
        switch controller.appState.state  {
        case .Paused:
            controller.start()
        case .Running:
            controller.pause()
        case .Stopped:
            controller.start()
            
        }
    }
    
    @IBAction func resetButtonClicked(sender: AnyObject) {
        controller.reset()
    }
    
    var controller = MeetingCostController.sharedInstance
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var contentSize = preferredContentSize
        contentSize.height = 85
        preferredContentSize = contentSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        controller.delegate = self
        controller.reload()
        
        completionHandler(NCUpdateResult.NewData)
    }
    
}

extension TodayViewController: MeetingCostStatusDelegate {
    func statusUpdate() {
        totalCostLabel.text = String(controller.cost)
        durationLabel.text = String(controller.appState.elapsed)
    }
    
    func statusReset() {
        resetButton.enabled = false
        startButton.setTitle("Start", forState: .Normal)
    }
    
    func statusPaused() {
        resetButton.enabled = true
        startButton.setTitle("Continue", forState: .Normal)
    }
    
    func statusStarted() {
        resetButton.enabled = false
        startButton.setTitle("Pause", forState: .Normal)
        
    }
}