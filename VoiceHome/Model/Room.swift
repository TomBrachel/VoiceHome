//
//  Room.swift
//  VoiceHome
//
//  Created by Tom Brachel on 12/09/2019.
//  Copyright © 2019 Tom Brachel. All rights reserved.
//

import Foundation

struct Room: Codable {
    private(set) var name: String
    private(set) var switchers: [Switcher]
    
    var description: String {
        var switchersString = "[ "
        for switcher in switchers {
            switchersString += "\(switcher.description), "
        }
        return "room name: \(name), switchers: \(switchersString)]\n"
    }
    
    init(name: String, switchers: [Switcher]) {
        self.name = name
        self.switchers = switchers
    }
    
    
}
