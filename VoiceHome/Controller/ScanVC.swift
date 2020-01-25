//
//  ScanVC.swift
//  VoiceHome
//
//  Created by Tom Brachel on 06/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit
import WebKit

class ScanVC: UIViewController, WKNavigationDelegate {
    
    // MARK: - Vars:
    
    //Model:
    var home: SmartHome?
    
    //Outlets:
    @IBOutlet weak var showResultBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    //Vars:
    var rooms = [String]()
    var roomsSwitches = [String: [String]]()
    var isRoomComplete = [String: Bool]()
    var isSecondMyHouse = false
    var lastTitle = ""
    
    //Comuted Var pageTitle:
    var pageTitle: String = "" {
        didSet {
            if self.pageTitle != "" {
                print("Title Changed: " + self.pageTitle)
                
                
                switch self.pageTitle {
                case "Login Form":
                    print("log in")
                    self.logIn()
                case "My House":
                    print("My House")
                    self.enterRoomsList()
                case "My House!":
                    print("My House!")
                    if isSecondMyHouse {
                        if rooms.isEmpty {
                            self.getRooms()
                        } else {
                            var roomToOpen = ""
                            for (room, isComplete) in isRoomComplete {
                                if !isComplete {
                                    roomToOpen = room
                                }
                            }
                            if roomToOpen != "" {
                                self.openRoom(with: roomToOpen)
                            } else {
                                print("done!")
                                self.showResultBtn.isHidden = false
                            }
                        }
                    } else {
                        self.enterRoomsList()
                    }
                case _ where rooms.contains(self.pageTitle):
                    print("Room")
                    self.getAllSwitchers(from: self.pageTitle)
                case "stop":
                    print("Scan Complete!")
                default:
                    print("default")
                }
            }
        }
    }
    

    
    
    //MARK: - Delegations:
    
    override func viewDidLoad() {
        
        if let url = try? FileManager.default.url(
                 for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true).appendingPathComponent("SmartHome.json") {
                 if let jsonData = try? Data(contentsOf: url) {
                     if let scannedHome = SmartHome(withJson: jsonData) {
                        home = scannedHome
                        pageTitle = "stop"
                        showResultBtn.setTitle("Show Scanned Home", for: .normal)
                        
                     } else {
                        reScan()
                    }
                 } else {
                    reScan()
            }
        } else {
            reScan()
        }
    }
    
    //MARK: - objc Funcs:
    
    @IBAction func showResultsBtnPressed(_ sender: UIButton) {
        if sender.titleLabel?.text != "Show Scanned Home" {
            pageTitle = "stop"
            for (room,switchers) in roomsSwitches {
                home!.createRoom(with: room, andSwitchers: switchers)
            }
            if let tryToSave = home?.saveSmartHome() {
                if tryToSave.0 {
                    print("saved successfuly!")
                } else {
                    print("couldn't save \(tryToSave.1)")
                }
            }
        }
        
        performSegue(withIdentifier: "showResults", sender: sender)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            if let navVC = segue.destination as? UINavigationController {
                if let cvc = navVC.topViewController as? BundlesTableVC {
                    cvc.home = home
                }
            }
        }

    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        getTitleFromWeb()
        
    }
    
    //MARK: - Help Funcs
    func reScan() {
        home = SmartHome(name: "Home", url: Const.HOME_URL ,username: Const.USERNAME, password: Const.PASSWORD)
        
        showResultBtn.isHidden = true
        webView.navigationDelegate = self
        let url = URL(string: home!.url)
        let reqeust = URLRequest(url: url!)
        webView.load(reqeust)
    }
    
    func operateBundle(withBundleId bundleId: Int) {
        showResultBtn.setTitle("FromSiri", for: .normal)
        
        if let url = try? FileManager.default.url(
                        for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: true).appendingPathComponent("SmartHome.json") {
                            if let jsonData = try? Data(contentsOf: url) {
                                if let scannedHome = SmartHome(withJson: jsonData) {
                                    home = scannedHome
                                           
                                    if let bundle = home?.getBundleFromId(withId: bundleId) {
                                        showResultBtn.setTitle("\(bundle.name)", for: .normal)
                                        let story = UIStoryboard(name: "Main", bundle: nil)
                                        if let operateVC = story.instantiateViewController(withIdentifier: "operateBundleVC").contents as? OperateBundleVC {
                                           operateVC.home = home
                                           operateVC.bundleToOperate = bundle
                                           present(operateVC, animated: true)
                                        }
                                    }
                                }
                            } else {
                                reScan()
                            }
                        }
    }
    
    
    
    //MARK: - JS Funcs:
    func getTitleFromWeb() {
        let js = "document.getElementsByTagName('h1')[0].textContent"
        
        webView.evaluateJavaScript(js) { (value, error) in
            if let err = error {
                print(err)
            } else if let title = value as? String {
                self.pageTitle = title
            } else {
                self.pageTitle = ""
            }
        }
        sleep(1)
    }
    
    func logIn() {
        let js = "document.getElementById('username').value=\"\(home!.username)\";                      document.getElementById('password').value=\"\(home!.password)\"; document.getElementById('submitButton').click();"
        
        webView.evaluateJavaScript(js) { (value, error) in
            if let err = error {
                print(err)
            } else {
                self.getTitleFromWeb()
            }
        }
        sleep(1)
    }
    
    func enterRoomsList() {
        let js = "document.getElementsByClassName('imag')[0].click()"
        
        webView.evaluateJavaScript(js) { (value, error) in
            if let err = error as? String {
                if err.contains("Code=4") {
                    self.isSecondMyHouse = true
                    self.getTitleFromWeb()
                }
            } else {
                self.getTitleFromWeb()
                self.isSecondMyHouse = true
            }
        }
        sleep(1)
    }
    
    func getRooms() {
        let js = "var rooms = document.getElementsByClassName('txt'); var roomsArr = []; for (i = 0; i < rooms.length; i++) { roomsArr.push(rooms[i].textContent)} roomsArr"
        
        webView.evaluateJavaScript(js) { (value, error) in
            if let err = error {
                print(err)
            } else if let roomsArr = value as? [String] {
                if roomsArr.isEmpty {
                    self.enterRoomsList()
                }
                for room in roomsArr {
                    if !self.rooms.contains(room) {
                        self.rooms.append(room)
                        self.isRoomComplete[room] = false
                    }
                }
                self.isSecondMyHouse = true
                self.getTitleFromWeb()
            }
        }
        sleep(1)
    }
    
    
    func openRoom(with room: String) {
        let js = "var spans = document.getElementsByTagName('span'); for (i = 0; i < spans.length; i++) { if (spans[i].textContent === '\(room)') { spans[i].click() } }"
        
        webView.evaluateJavaScript(js) { (value, error) in
            if let err = error as? String {
                if err.contains("Code=4") {
                    self.getTitleFromWeb()
                }
            } else {
                self.getTitleFromWeb()
            }
        }
        sleep(1)
    }
    
    func getAllSwitchers(from room: String) {
        let js = "var spans = document.getElementsByTagName('span'); btns = []; for (i = 0; i < spans.length; i++) { if (spans[i].className === 'txt-element') { btns.push(spans[i].textContent) } } btns"
        webView.evaluateJavaScript(js) { (value, error) in
            if let err = error {
                print(err)
            } else if let switchesArr = value as? [String] {
                self.roomsSwitches[room] = switchesArr
                self.isRoomComplete[room] = true
                self.goBack()
                
            }
        }
        sleep(1)
    }
    
    func goBack() {
        let js = "document.getElementsByClassName('leftButton')[0].click()"
        
        webView.evaluateJavaScript(js) { (value, error) in
            if let err = error as? String {
                print(err)
            }
            self.getTitleFromWeb()
        }
        sleep(1)
    }
}

