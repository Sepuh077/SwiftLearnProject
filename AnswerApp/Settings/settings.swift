//
//  settings.swift
//  AnswerApp
//
//  Created by Sepuh on 18.10.21.
//

import Foundation


enum Settings: String {
    case backgroundMode
    case Test
    case logout
}

let allSettings = [
    Setting(type: Settings.backgroundMode, name: "Dark mode"),
    Setting(type: Settings.Test, name: "Test"),
    Setting(type: Settings.logout, name: "Log Out"),
]


struct Setting {
    var type: Settings
    var title: String
    
    init(type: Settings, name: String) {
        self.type = type
        self.title = name
    }
}
