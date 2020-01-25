//
//  SwitcherTableViewCell.swift
//  VoiceHome
//
//  Created by Tom Brachel on 23/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit

class SwitcherTableViewCell: UITableViewCell {

    var switcher: Switcher?
    @IBOutlet weak var switcherNameLbl: UILabel!
    @IBOutlet weak var isSwitcherInArraySwch: UISwitch!
    var callback : ((UITableViewCell, Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    func configurateCell(withSwitcher switcher: Switcher, andIsInBundle isIn: Bool) {
        self.switcher = switcher
        switcherNameLbl.text = switcher.name
        isSwitcherInArraySwch.isOn = isIn
    }
    
    @IBAction func switchToggeled(_ sender: UISwitch) {
        callback?(self, sender.isOn)
    }
    
}
