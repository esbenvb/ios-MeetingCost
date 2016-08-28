//
//  ControlsView.swift
//  MeetingCost
//
//  Created by Esben von Buchwald on 19/12/15.
//  Copyright © 2015 Esben von Buchwald. All rights reserved.
//

import UIKit

class ControlsView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let something = NSBundle.mainBundle().loadNibNamed("ControlsView", owner: self, options: nil)
        if let view = something[0] as? UIView {
            self.addSubview(view)
        }
    }
}
