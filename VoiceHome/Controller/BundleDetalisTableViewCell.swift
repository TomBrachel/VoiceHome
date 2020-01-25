//
//  BundleDetalisTableViewCell.swift
//  VoiceHome
//
//  Created by Tom Brachel on 25/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit

class BundleDetalisTableViewCell: UITableViewCell {

    @IBOutlet weak var switcherNameLbl: UILabel!
    @IBOutlet weak var roomNameLbl: UILabel!
    @IBOutlet weak var offLbl: UILabel!
    @IBOutlet weak var onLbl: UILabel!
    @IBOutlet weak var toTurnOnSwtch: UISwitch!
    var callback : ((UITableViewCell, Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configurateCell(withSwitcher switcher: Switcher) {
        switcherNameLbl.text = switcher.name
        roomNameLbl.text = switcher.roomName
        if switcher.toTurnOn {
            toTurnOnSwtch.isOn = true
            offLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            onLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            toTurnOnSwtch.isOn = false
            offLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            onLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    @IBAction func toggleSwitch(_ sender: UISwitch) {
        callback?(self, sender.isOn)
    }
}
