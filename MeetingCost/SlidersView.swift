//
//  SlidersView.swift
//  MeetingCost
//
//  Created by Esben von Buchwald on 23/12/15.
//  Copyright © 2015 Esben von Buchwald. All rights reserved.
//

import UIKit

class SlidersView: UIView {


    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var salarySlider: UISlider!
    @IBOutlet weak var participantsSlider: UISlider!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let something = NSBundle.mainBundle().loadNibNamed("SlidersView", owner: self, options: nil)
        if let view = something[0] as? UIView {
            self.addSubview(view)
        }
    }

}
