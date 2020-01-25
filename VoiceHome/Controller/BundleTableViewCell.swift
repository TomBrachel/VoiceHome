//
//  BundleTableViewCell.swift
//  VoiceHome
//
//  Created by Tom Brachel on 17/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit

class BundleTableViewCell: UITableViewCell {

    @IBOutlet weak var bundleNameLbl: UILabel!
    var bundle: SwitcherBundle?
    var delegate: OperateBundleDelegate?
    @IBOutlet weak var askSiriBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func goBtnPressed(_ sender: UIButton) {
        
        if let bundleToOerate = bundle {
            self.delegate?.operateBundleFromCell(withBundle: bundleToOerate)
        }
    }
    
    @IBAction func askSiriBtnPressed(_ sender: UIButton) {
        if bundle != nil {
            if let bundleToOerate = bundle {
                self.delegate?.createSiriShortcuts(withBundle: bundleToOerate)
            }
        }
    }
    
    func configurateCell(with bundle: SwitcherBundle) {
        self.bundle = bundle
        bundleNameLbl.text = bundle.name
    }
    
    
}
