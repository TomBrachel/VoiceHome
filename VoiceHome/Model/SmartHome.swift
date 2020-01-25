//
//  House.swift
//  VoiceHome
//
//  Created by Tom Brachel on 12/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import Foundation

class SmartHome: Codable {
    private var factor: Int
    private(set) var name: String
    private(set) var url: String
    private(set) var username: String
    private(set) var password: String
    
    private(set) var rooms: [Room]
    private(set) var bundles: [SwitcherBundle]
    
    var description: String {
        var roomString = ""
        for room in rooms {
            roomString += "\(room.description), "
        }
        return "home name: \(name), \nrooms: \(roomString), \nbundles: \(bundles)"
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(name: String, url: String, username: String, password: String) {
        self.name = name
        self.url = url
        self.username = username
        self.password = password
        self.factor = 0
        
        rooms = [Room]()
        bundles = [SwitcherBundle]()
        
    }
    init? (withJson json: Data) {
        if let newValue = try? JSONDecoder().decode(SmartHome.self, from: json) {
            self.name = newValue.name
            self.url = newValue.url
            self.username = newValue.username
            self.password = newValue.password
            self.rooms = newValue.rooms
            self.bundles = newValue.bundles
            self.factor = newValue.factor
        } else {
            return nil
        }
    }
    
    func createRoom(with roomName: String, andSwitchers switchers: [String]) {
        var roomSwitchers = [Switcher]()
        for switcher in switchers {
            let roomSwitcher = Switcher(name: switcher, roomName: roomName)
            roomSwitchers.append(roomSwitcher)
        }
        let room = Room(name: roomName, switchers: roomSwitchers)
        rooms.append(room)
    }
    
    func createBundle(with name: String, andSwitchers switchers: [Switcher], andIsSiriActivated siriActivation: Bool) {
        let newBundle = SwitcherBundle(id: self.factor, name: name, switchers: switchers, isSiriActivated: siriActivation)
        factor += 1
        bundles.append(newBundle)
    }
    
    func saveSmartHome() -> (Bool, String) {
        if let homeJSON = self.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true).appendingPathComponent("SmartHome.json") {
                    do {
                        try homeJSON.write(to: url)
                        return (true, "")
                    } catch let err {
                        return (false, "\(err)")
                    }
            }
        }
        return (false, "currpted json")
    }
    
    func deleteBundle(withBundle bundle: SwitcherBundle) {
        
        bundles = bundles.filter() { $0 != bundle }

    }
    
    func getBundleFromId(withId id: Int) -> SwitcherBundle? {
        if let bundle = bundles.filter({ $0.id == id }).first {
            return bundle
        }
        return nil
    }
    
    func askSiriAdded(toBundle bundleToChange: SwitcherBundle) {
        
        bundleToChange.setSiriActivated()
        
        let tryToSave = self.saveSmartHome()
        if tryToSave.0 {
            print("saved successfuly!")
        } else {
            print("couldn't save \(tryToSave.1)")
        }
                   
    }
    
    
}
