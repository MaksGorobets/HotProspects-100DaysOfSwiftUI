//
//  TabsView.swift
//  HotProspects
//
//  Created by Maks Winters on 08.02.2024.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem { Label("All", systemImage: "person.2.circle") }
            ProspectsView(filter: .contacted)
                .tabItem { Label("Contacted", systemImage: "person.crop.circle.badge.checkmark") }
            ProspectsView(filter: .uncontacted)
                .tabItem { Label("Uncontacted", systemImage: "person.crop.circle.badge.xmark") }
            MeView()
                .tabItem { Label("Me", systemImage: "person.crop.circle") }
        }
    }
}

#Preview {
    TabsView()
}
