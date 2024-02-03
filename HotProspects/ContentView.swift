//
//  ContentView.swift
//  HotProspects
//
//  Created by Maks Winters on 03.02.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = "StarView"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            StarView()
                .tabItem { Label("Star", systemImage: "star") }
                .tag("StarView")
            GlobeView()
                .tabItem { Label("Globe", systemImage: "globe") }
                .tag("GlobeView")
        }
    }
}

struct StarView: View {
    var body: some View {
        ZStack {
            RadialGradient(colors: [.yellow, .white], center: .center, startRadius: 50, endRadius: 200)
                .ignoresSafeArea()
            VStack {
                Image(systemName: "star.fill")
                Text("Star")
            }
            .font(.system(size: 50))
        }
    }
}

struct GlobeView: View {
    var body: some View {
        ZStack {
            RadialGradient(colors: [.blue, .white], center: .center, startRadius: 50, endRadius: 200)
            VStack {
                Image(systemName: "globe")
                Text("Globe")
            }
            .font(.system(size: 50))
        }
    }
}

#Preview {
    ContentView()
}
