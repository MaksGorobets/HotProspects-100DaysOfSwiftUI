//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Maks Winters on 03.02.2024.
//

import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            TabsView()
        }
        .modelContainer(for: Prospect.self)
    }
}
