//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Maks Winters on 08.02.2024.
//

import SwiftUI
import SwiftData

struct ProspectsView: View {
    enum FilterOption {
        case none, contacted, uncontacted
    }
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    
    let filter: FilterOption
    
    var navigationTitle: String {
        switch filter {
        case .none:
            "All"
        case .contacted:
            "Contacted"
        case .uncontacted:
            "Uncontacted"
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(prospects) { prospect in
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 30))
                            .padding(.horizontal, 5)
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.email)
                                .font(.subheadline)
                        }
                        Spacer()
                        Image(systemName:
                                "checkmark.circle\(prospect.isContacted ? ".fill" : "")"
                        )
                        .onTapGesture {
                            prospect.isContacted.toggle()
                        }
                    }
                }
                .onDelete(perform: deleteProspect)
            }
            .toolbar {
                Button {
                    let prospect = Prospect(name: "Taylor Swift", email: "taylor@swift.com", isContacted: false)
                    modelContext.insert(prospect)
                } label: {
                    Image(systemName: "plus")
                }
            }
                .navigationTitle(navigationTitle)
        }
    }
    
    init(filter: FilterOption) {
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            })
        }
    }
    
    func deleteProspect(_ indexSet: IndexSet) {
        for index in indexSet {
            let prospect = prospects[index]
            modelContext.delete(prospect)
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self, inMemory: false)
}
