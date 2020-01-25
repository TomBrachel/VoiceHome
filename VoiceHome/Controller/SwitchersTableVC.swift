//
//  SwitchersTableVC.swift
//  VoiceHome
//
//  Created by Tom Brachel on 12/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit

class SwitchersTableVC: UITableViewController {
    
    var room: Room?
    var pickedSwitchers = [Switcher]()
    var alreadyPicked = [Switcher]()
    var delegate: PickedSwitchersDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = room?.name
        if pickedSwitchers.count > 0, room != nil {
            alreadyPicked = pickedSwitchers.filter() { $0.roomName == room!.name }
            print(alreadyPicked)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let switchersNum = room?.switchers.count {
            return switchersNum
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        43.5
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = tableView.cellForRow(at: indexPath) as? SwitcherTableViewCell {
            selectedCell.isSwitcherInArraySwch.setOn(!selectedCell.isSwitcherInArraySwch.isOn, animated: true)
            selectedCell.callback?(selectedCell, selectedCell.isSwitcherInArraySwch.isOn)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "switcherCell", for: indexPath) as? SwitcherTableViewCell {
            if let switcher = room?.switchers[indexPath.row] {
                let isExsist = alreadyPicked.contains(switcher)
                cell.configurateCell(withSwitcher: switcher, andIsInBundle: isExsist)
//                cell.isSwitcherInArraySwch.isOn = false
                
                cell.callback = { (switchCell, isOn) in
                    if let indexPath = self.tableView.indexPath(for: switchCell) {
                        if let selectedCell = tableView.cellForRow(at: indexPath) as? SwitcherTableViewCell {
                            if let selectedSwitcher = selectedCell.switcher {
                                if isOn {
                                    if !self.pickedSwitchers.contains(selectedSwitcher) {
                                        self.pickedSwitchers.append(switcher)
                                        print("add \(switcher.name) to pickedSwitcherList")
                                    }
                                } else {
                                    self.pickedSwitchers = self.pickedSwitchers.filter() { $0.name != selectedSwitcher.name }
                                    print("remove \(switcher.name) from pickedSwitcherList")
                                }
                            }
                        }
                    }
                }
                
                return cell
            }
        }
         return UITableViewCell()
        
    }
    
    
    @objc func switchToggel(_ sender: UISwitch) {
        print("toggle!")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.addpickedSwitcher(with: pickedSwitchers)
    }

}
