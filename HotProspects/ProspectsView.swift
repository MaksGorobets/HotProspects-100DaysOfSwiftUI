//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Maks Winters on 08.02.2024.
//

import SwiftUI
import SwiftData
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterOption {
        case none, contacted, uncontacted
    }
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @State private var selected = Set<Prospect>()
    
    @State private var isScanning = false
    
    @State private var isShowingAlert = false
    @State private var selectedProspect: Prospect?
    @State private var date = Date()
    
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
                            Button("Notify", systemImage: "bell.fill") {
                                isShowingAlert = true
                                selectedProspect = prospect
                            }
                            .tint(.blue)
                            Button("Contacted", systemImage: "person") {
                                prospect.isContacted.toggle()
                            }
                            .tint(.green)
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
            .sheet(isPresented: $isShowingAlert) {
                NavigationStack {
                    VStack {
                        Spacer()
                        DatePicker("Pick a time", selection: $date)
                        Spacer()
                        Spacer()
                        HStack {
                            Button {
                                isShowingAlert = false
                            } label: {
                                Text("Cancel")
                                    .frame(maxWidth: .infinity)
                            }
                            Button {
                                print("Clicked")
                                isShowingAlert = false
                                notify(for: selectedProspect!)
                                dismiss()
                            } label: {
                                Text("OK")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .navigationTitle("Pick time")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $isScanning) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Testing data \(Int.random(in: 0...100))\ntesting@gmail.com", completion: handleScan)
            }
                .navigationTitle(navigationTitle)
                .safeAreaInset(edge: .bottom, alignment: .center) {
                    if !selected.isEmpty {
                        Button("Delete selected", systemImage: "trash", action: deleteSelected)
                            .buttonStyle(.borderedProminent)
                            .clipShape(.capsule)
                            .tint(.purple)
                            .padding()
                    }
                }
        }
    }
    
    func notify(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.body = prospect.email
            content.sound = UNNotificationSound.default
            
            let componentsDate = Calendar.current.dateComponents([.minute, .hour, .day], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: componentsDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        center.getNotificationSettings { setting in
            if setting.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error{
                        print(error.localizedDescription)
                    }
                }
            }
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
