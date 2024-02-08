//
//  Prospect.swift
//  HotProspects
//
//  Created by Maks Winters on 08.02.2024.
//

import SwiftData

@Model
class Prospect {
    let name: String
    let email: String
    var isContacted: Bool
    
    init(name: String, email: String, isContacted: Bool) {
        self.name = name
        self.email = email
        self.isContacted = isContacted
    }
}
