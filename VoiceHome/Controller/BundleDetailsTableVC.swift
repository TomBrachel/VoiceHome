//
//  BundleDetailsTableVC.swift
//  VoiceHome
//
//  Created by Tom Brachel on 16/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit

class BundleDetailsTableVC: UITableViewController {

    //Model
    var bundle: SwitcherBundle?
    
    
    var delegate : ChangeBundleDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = bundle?.name

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bundle?.switchers.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "bundleSwticherCell", for: indexPath) as? BundleDetalisTableViewCell {
            if let switcher = bundle?.switchers[indexPath.row] {
                cell.configurateCell(withSwitcher: switcher)
                
                cell.callback = { (switchCell, isOn) in
                    if let indexPath = self.tableView.indexPath(for: switchCell) {
                        if let selectedCell = tableView.cellForRow(at: indexPath) as? BundleDetalisTableViewCell {
                            if isOn {
                                selectedCell.toTurnOnSwtch.setOn(true, animated: true)
                                selectedCell.offLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                                selectedCell.onLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            } else {
                                selectedCell.toTurnOnSwtch.setOn(false, animated: true)
                                selectedCell.offLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                selectedCell.onLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                            }
                            if self.bundle != nil {
                                self.bundle!.toggleSwitcher(switcher: switcher)
                            }
                        }
                    }
                }
            }
            return cell
        }
        

        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        if delegate != nil {
            delegate!.saveChanges()
        }
    }
}
