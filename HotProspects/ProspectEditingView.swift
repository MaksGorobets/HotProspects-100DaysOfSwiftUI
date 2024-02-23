//
//  ProspectEditingView.swift
//  HotProspects
//
//  Created by Maks Winters on 23.02.2024.
//
// https://www.youtube.com/watch?v=w4BQnVn7H6M
//

import SwiftUI
import SwiftData

struct ProspectEditingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Bindable var prospect: Prospect
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Edit a name...", text: $prospect.name)
                TextField("Edit an email...", text: $prospect.email)
                Toggle(isOn: $prospect.isContacted) {
                    Text("Is contacted?")
                }
            }
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            .navigationTitle(prospect.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Prospect.self, configurations: config)

    let prospect = Prospect(name: "", email: "", isContacted: false)
    return ProspectEditingView(prospect: prospect)
        .modelContainer(container)
}
