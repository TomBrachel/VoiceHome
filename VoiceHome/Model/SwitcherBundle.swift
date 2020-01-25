//
//  SwitcherBundle.swift
//  VoiceHome
//
//  Created by Tom Brachel on 12/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import Foundation

class SwitcherBundle: Codable, Equatable {
    
    
    static func == (lhs: SwitcherBundle, rhs: SwitcherBundle) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    
    private(set) var id: Int
    private(set) var name: String
    private(set) var switchers: [Switcher]
    private(set) var isAskSiriActivated = false
    
    
    var description: String {
        return "name: \(name), switchers: \(switchers), isSiriActivated: \(isAskSiriActivated)"
    }

    
    init(id: Int, name: String, switchers: [Switcher], isSiriActivated: Bool) {
        
        self.name = name
        self.switchers = switchers
        self.isAskSiriActivated = isSiriActivated
        self.id = id
        
    }
    
    
    func getSwitchersPerRoomDict() -> [String: [Bool: [String]]] {
        var switchersPerRoomDict = [String: [Bool: [String]]]()
        
        for switcher in switchers {
            if switchersPerRoomDict.keys.contains(switcher.roomName) {
                if switchersPerRoomDict[switcher.roomName]!.keys.contains(switcher.toTurnOn) {
                    switchersPerRoomDict[switcher.roomName]![switcher.toTurnOn]?.append(switcher.name)
                } else {
                    switchersPerRoomDict[switcher.roomName]![switcher.toTurnOn] = [switcher.name]
                }
            } else {
                switchersPerRoomDict[switcher.roomName] = [switcher.toTurnOn: [switcher.name]]
            }
        }
        
        return switchersPerRoomDict
    }
    
    func setSiriActivated() {
        self.isAskSiriActivated = true
    }
    
    func toggleSwitcher(switcher: Switcher) {
        for swtch in switchers {
            if swtch == switcher {
                swtch.toggleSwitcher()
            }
        }
    }
}
