//
//  OperateBundleVC.swift
//  VoiceHome
//
//  Created by Tom Brachel on 13/10/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import UIKit
import WebKit

class OperateBundleVC: UIViewController, WKNavigationDelegate {

    var home: SmartHome?
    var bundleToOperate: SwitcherBundle?
    var bundleIdToOperate: Int?
    
    
    var isSecondMyHouse = false
    var isRoomComplete = [String: Bool]()
    var switchersPerRoomDict = [String: [Bool: [String]]]()
    
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
                        var roomToOpen = ""
                        for (room, isComplete) in isRoomComplete {
                            if !isComplete {
                                roomToOpen = room
                            }
                        }
                        if roomToOpen != "" {
                            self.openRoom(with: roomToOpen)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        self.enterRoomsList()
                    }
                case _ where switchersPerRoomDict.keys.contains(self.pageTitle):
                    print("Room")
                    self.turnOnSwitchers(from: self.pageTitle)
                default:
                    print("default")
                }
            }
        }
    }
    
    
    @IBOutlet weak var webView: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bundleId = bundleIdToOperate {
            if let url = try? FileManager.default.url(
                            for: .documentDirectory,
                            in: .userDomainMask,
                            appropriateFor: nil,
                            create: true).appendingPathComponent("SmartHome.json") {
                                if let jsonData = try? Data(contentsOf: url) {
                                    if let scannedHome = SmartHome(withJson: jsonData) {
                                        home = scannedHome
                                        if let bundle = home?.getBundleFromId(withId: bundleId) {
                                            bundleToOperate = bundle
                                        }
                                    }
                                }
                            }
        }
        
        
        if (home != nil) && (bundleToOperate != nil) {
            switchersPerRoomDict = bundleToOperate!.getSwitchersPerRoomDict()
            for room in switchersPerRoomDict.keys {
                isRoomComplete[room] = false
            }
            
            
            webView.navigationDelegate = self
            let url = URL(string: home!.url)
            let reqeust = URLRequest(url: url!)
            webView.load(reqeust)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        getTitleFromWeb()
        
    }
    
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
    
    func turnOnSwitchers(from room: String) {
        var js = ""
        let switchersToTurnOn = (switchersPerRoomDict[room]!)
        if let switchersToTurnOn = switchersToTurnOn[true] {
            js += "var switchers = \(switchersToTurnOn); lis = document.getElementsByTagName('li'); for (i = 0; i < lis.length; i++) { if(switchers.includes(lis[i].getElementsByClassName('txt-element')[0].textContent)) {if (lis[i].getElementsByClassName('elem')[0].getAttribute(\"is_on\") === \"off\") {lis[i].getElementsByClassName('elem')[0].click(); sleep(1000);} } } "
        }
        if let switchersToTurnOff = switchersToTurnOn[false] {
             js += "var switchers = \(switchersToTurnOff); lis = document.getElementsByTagName('li'); for (i = 0; i < lis.length; i++) { if(switchers.includes(lis[i].getElementsByClassName('txt-element')[0].textContent)) {if (lis[i].getElementsByClassName('elem')[0].getAttribute(\"is_on\") === \"on\") {lis[i].getElementsByClassName('elem')[0].click(); sleep(1000);} } }"
        }
        webView.evaluateJavaScript(js) { (value, error) in
            if let err = error {
                print(err)
            } else {
                self.isRoomComplete[room] = true
                sleep(1)
                self.goBack()
            }
        }
        sleep(3)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//only when off
//var switchers = ["מזגן "]; lis = document.getElementsByTagName('li'); for (i = 0; i < lis.length; i++) { if(switchers.includes(lis[i].getElementsByClassName('txt-element')[0].textContent)) {if (lis[i].getElementsByClassName('elem')[0].getAttribute("is_on") === "off") {lis[i].getElementsByClassName('elem')[0].click(); sleep(1000);} } }

//only when on
//var switchers = ["מזגן "]; lis = document.getElementsByTagName('li'); for (i = 0; i < lis.length; i++) { if (switchers.includes(lis[i].getElementsByClassName('txt-element')[0].textContent)) {
//if (lis[i].getElementsByClassName('elem')[0].getAttribute("is_on") === "on") {
//    lis[i].getElementsByClassName('elem')[0].click(); sleep(1000);
//} } }
