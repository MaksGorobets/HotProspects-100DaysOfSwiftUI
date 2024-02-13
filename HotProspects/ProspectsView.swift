//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Maks Winters on 08.02.2024.
//

import SwiftUI
import SwiftData
import CodeScanner

struct ProspectsView: View {
    enum FilterOption {
        case none, contacted, uncontacted
    }
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @State private var selected = Set<Prospect>()
    
    @State private var isScanning = false
    
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
            List(selection: $selected) {
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
                    }
                    .tag(prospect)
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            modelContext.delete(prospect)
                        }
                        if prospect.isContacted == true {
                            Button("Uncontacted", systemImage: "person.slash") {
                                prospect.isContacted.toggle()
                            }
                            .tint(.orange)
                        }
                        if prospect.isContacted == false {
                            Button("Contacted", systemImage: "person") {
                                prospect.isContacted.toggle()
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isScanning.toggle()
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $isScanning) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Testing data\ntesting@gmail.com", completion: handleScan)
            }
                .navigationTitle(navigationTitle)
            if !selected.isEmpty {
                Button("Delete selected", action: deleteSelected)
            }
        }
    }
    
    func deleteSelected() {
        selected.forEach {
            modelContext.delete($0)
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isScanning = false
        switch result {
        case .success(let success):
            let receivedString = success.string.components(separatedBy: "\n")
            if receivedString.count == 2 {
                let prospect = Prospect(name: receivedString[0], email: receivedString[1], isContacted: false)
                
                modelContext.insert(prospect)
            }
        case .failure(let failure):
            print(failure.localizedDescription)
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
