//
//  BundlesTableVC.swift
//  VoiceHome
//
//  Created by Tom Brachel on 13/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit

class BundlesTableVC: UITableViewController, CreateBundlesDelegate, OperateBundleDelegate, ChangeBundleDelegate {
    
    //MARK: - Vars:
    var home: SmartHome?
    
    //MARK: - Protocols Funcs:
    func createSiriShortcuts(withBundle bundle: SwitcherBundle) {
        if !bundle.isAskSiriActivated {
            createUserActivity(withBundle: bundle)
            let alert = UIAlertController(title: "Added to Siri", message: "Added\n\(bundle.name) Bundle to Shortcuts", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (Void) in }))
            present(alert, animated: true, completion: nil)
            
            
            tableView.reloadData()
        }
    }
    
    func saveChanges() {
           
           if let tryToSave = home?.saveSmartHome() {
               if tryToSave.0 {
                   print("saved successfuly!")
               } else {
                   print("couldn't save \(tryToSave.1)")
               }
           }
       }
    
    
    func operateBundleFromCell(withBundle bundle: SwitcherBundle) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        if let operateVC = story.instantiateViewController(withIdentifier: "operateBundleVC").contents as? OperateBundleVC {
            operateVC.home = home
            operateVC.bundleToOperate = bundle
            present(operateVC, animated: true)
        }
    }
    
    
   func addBundle(with name: String, and switchers: [Switcher]) {
          if home != nil {
              home!.createBundle(with: name, andSwitchers: switchers, andIsSiriActivated: false)
          }
          saveChanges()
          tableView.reloadData()
      }
    
    
    //MARK: - Delegations:
    override func viewDidLoad() {
          super.viewDidLoad()
    }
    
    
    //MARK: - Help Funcs:
    func createUserActivity(withBundle bundle: SwitcherBundle) {
          let activity = NSUserActivity(activityType: "\(UserActivityType.type).\(bundle.id)")
          activity.title = bundle.name
          activity.isEligibleForSearch = true
          activity.isEligibleForPrediction = true
          
          self.userActivity = activity
          self.userActivity?.becomeCurrent()
          
          home?.askSiriAdded(toBundle: bundle)
    }
    
  
    //MARK: - objc Funcs:
    @IBAction func addNewBundleBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showRooms", sender: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let bundlesNumber = home?.bundles.count {
            return bundlesNumber
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "bundleCell", for: indexPath) as? BundleTableViewCell {
            if let bundle = home?.bundles[indexPath.row] {
                cell.configurateCell(with: bundle)
                cell.delegate = self
                if bundle.isAskSiriActivated {
                    cell.askSiriBtn.isHidden = true
                } else {
                    cell.askSiriBtn.isHidden = false
                }
                return cell
            }
        }
        return UITableViewCell()
        
    }
 
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showBundleDetails", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 100.0
       }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let bundle = home?.bundles[indexPath.row] {
                home?.deleteBundle(withBundle: bundle)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
               saveChanges()
                tableView.reloadData()
            }
        }   
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRooms" {
            if let cvc = segue.destination as? RoomsTableVC {
                cvc.home = home
                cvc.delegate = self
            }
        }
        if segue.identifier == "showBundleDetails" {
            if let cvc = segue.destination as? BundleDetailsTableVC {
                if let bundle = home?.bundles[(sender as! IndexPath).row] {
                    cvc.bundle = bundle
                    cvc.delegate = self
                    
                }
            }
        }
    }
 }


//MARK: - Extensions And Protocols
protocol CreateBundlesDelegate {
    func addBundle(with name: String, and switchers: [Switcher])
}

protocol OperateBundleDelegate {
    func operateBundleFromCell(withBundle bundle: SwitcherBundle)
    func createSiriShortcuts(withBundle bundle: SwitcherBundle)
}

protocol ChangeBundleDelegate {
    func saveChanges()
}


extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}
