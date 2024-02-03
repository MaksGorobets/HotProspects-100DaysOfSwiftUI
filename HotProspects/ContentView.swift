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
            ExampleView(selectedTab: $selectedTab,
                        gradientColor: .yellow,
                        text: "Star", image: "star.fill",
                        buttonText: "Go to Globe view >", 
                        buttonValue: "GlobeView")
                .tabItem { Label("Star", systemImage: "star") }
                .tag("StarView")
            ExampleView(selectedTab: $selectedTab,
                        gradientColor: .blue,
                        text: "Globe", image: "globe",
                        buttonText: "< Go to Star view",
                        buttonValue: "StarView")
                .tabItem { Label("Globe", systemImage: "globe") }
                .tag("GlobeView")
        }
    }
}

struct ExampleView: View {
    
    @Binding var selectedTab: String
    
    let gradientColor: Color
    
    let text: String
    let image: String
    let buttonText: String
    let buttonValue: String
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [gradientColor, .white], center: .center, startRadius: 50, endRadius: 200)
                .ignoresSafeArea()
            VStack {
                Image(systemName: image)
                Text(text)
                Button(buttonText) {
                    selectedTab = buttonValue
                }
                .font(.system(size: 20))
                .buttonStyle(.plain)
            }
            .foregroundStyle(.black)
            .font(.system(size: 50))
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
