//
//  ContentView.swift
//  WebScraping
//
//  Created by user on 24/06/22.
//

import SwiftUI
import Foundation
import SwiftSoup
import CoreImage.CIFilterBuiltins


struct ContentView: View {
    @State var title: String = ""
    @State var titleForQR: String = ""
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color.white,Color.white,
                Color.white,Color.white,Color.gray,Color.black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        VStack {
            VStack {
            Text("Random Wiki")
                .fontWeight(.ultraLight)
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
                .font(.system(size: 60))
            Text("QR Generator")
                .fontWeight(.ultraLight)
                .foregroundColor(Color.yellow)
                .multilineTextAlignment(.center)
                .font(.system(size: 60))
            }.frame(maxHeight: 200, alignment: .top)
                
            if title != "" {
                Image(uiImage: generateQRCode(from: "https://it.wikipedia.org/wiki/" + titleForQR)
            ).interpolation(.none)
             .resizable()
             .scaledToFit()
                 .frame(width: 300, height: 300)
                 .padding(.bottom, 40.0)
            }
           
            Text(title)
                .fontWeight(.bold)
                .font(.system(size: 25))
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
            Spacer()
            Button ("Lets go") {
            let url = URL(string:"https://it.wikipedia.org/wiki/Speciale:PaginaCasuale")!
            let html = try! String(contentsOf: url)
            let document = try! SwiftSoup.parse(html)
            title = try! String(document.title())
            shorten()
            titleForQR = title.replacingOccurrences(of: " ", with: "_")
            print(titleForQR)
            }
            .buttonStyle(GrowingButton())

           
        }
        
        }
    }
    func shorten() {
        for i in 0...11 {
            if i == 11 && title.last == " "{
                title.removeLast()
            } else if i != 11 {
            title.removeLast()
            }
        }
    }
   
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    

   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.yellow)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}




