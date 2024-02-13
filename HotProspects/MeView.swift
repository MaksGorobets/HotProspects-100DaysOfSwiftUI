//
//  MeView.swift
//  HotProspects
//
//  Created by Maks Winters on 08.02.2024.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    @AppStorage("meName") var name = ""
    @AppStorage("meEmail") var emailAdress = ""
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State private var qr: UIImage?
    @State private var qrSheet = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 120))
                Image(uiImage: generateQR("\(name)\n\(emailAdress)"))
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        qrSheet.toggle()
                    }
            }
            VStack {
                TextField("Enter your name", text: $name) {
                    UIApplication.shared.endEditing()
                }
                    .textContentType(.name)
                TextField("Enter your email", text: $emailAdress) {
                    UIApplication.shared.endEditing()
                }
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            .sheet(isPresented: $qrSheet) {
                sheetView
            }
            Spacer()
            Spacer()
        }
    }
    
    var sheetView: some View {
        VStack {
            Image(uiImage: generateQR("\(name)\n\(emailAdress)"))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .padding()
                .presentationDetents([.medium])
            Button("Dismiss") {
                qrSheet = false
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    func generateQR(_ string: String) -> UIImage {
        filter.message = Data(string.utf8)
        if let ciImage = filter.outputImage {
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
}

#Preview {
    MeView()
}
