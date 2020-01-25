//
//  Switcher.swift
//  VoiceHome
//
//  Created by Tom Brachel on 12/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import Foundation

class Switcher: Equatable, Codable {
    
    static func == (lhs: Switcher, rhs: Switcher) -> Bool {
        if lhs.name == rhs.name && lhs.roomName == rhs.roomName {
            return true
        }
        return false
    }
    
    private(set) var name: String
    private(set) var roomName: String
    private(set) var toTurnOn: Bool
 
    
    
    var description: String {
        return name
    }
    
    init(name: String, roomName: String) {
        self.name = name
        self.roomName = roomName
        self.toTurnOn = true
    }
    
    func toggleSwitcher() {
        self.toTurnOn = !self.toTurnOn
    }
    
}
