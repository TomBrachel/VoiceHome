//
//  RoomsTableVC.swift
//  VoiceHome
//
//  Created by Tom Brachel on 12/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit

class RoomsTableVC: UITableViewController, PickedSwitchersDelegate {
    

    //MARK: - Vars:
    
    var home: SmartHome?
    var pickedSwitchers = [Switcher]()
    var delegate: CreateBundlesDelegate?
    
    //MARK: - Protocols Funcs:

    func addpickedSwitcher(with switchers: [Switcher]) {
        for switcher in switchers {
            if !pickedSwitchers.contains(switcher) {
                pickedSwitchers.append(switcher)
            }
        }
    }
    
    //MARK: - Delegations:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = home?.name
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    //MARK: - objc Funcs:
    
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Save Bundle", message: "Please Save your bundle with a uniq name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) -> Void in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) -> Void in
            if let tf = alert.textFields?.first {
                let bundleName = tf.text!
                if bundleName != "" {
                    self.delegate?.addBundle(with: bundleName, and: self.pickedSwitchers)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "Save Failed", message: "The name should contains at least one character", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (Void) in }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }))
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name for Bundle"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let roomsNumber = home?.rooms.count {
            return roomsNumber
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        cell.textLabel?.text = home!.rooms[indexPath.row].name

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showSwitchers", sender: indexPath)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSwitchers" {
            if let cvc = segue.destination as? SwitchersTableVC {
                if let room = home?.rooms[(sender as! IndexPath).row] {
                    cvc.room = room
                    cvc.pickedSwitchers = pickedSwitchers
                    cvc.delegate = self
                }
            }
        }
    }
    
}

//MARK: - Extensions and Protocols:

protocol PickedSwitchersDelegate {
    func addpickedSwitcher(with switchers: [Switcher])
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

