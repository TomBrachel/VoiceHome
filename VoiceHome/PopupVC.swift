//
//  PopupVC.swift
//  VoiceHome
//
//  Created by Tom Brachel on 16/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit

class PopupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    static func create() -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "") as! PopupVC
        return storyboard
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
