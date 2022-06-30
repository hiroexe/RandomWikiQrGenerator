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
                Color.white, Color.white,Color.black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                VStack {
                    Text("Random Wiki")
                        .fontWeight(.ultraLight)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 60))
                    Text("QR Generator")
                        .fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 60))
                }.frame(maxHeight: 200, alignment: .top)
                
                if title != "" {
                    //genera il qr code dal link
                    Image(uiImage: generateQRCode(from: "https://it.wikipedia.org/wiki/" + titleForQR)
                    ).interpolation(.none) //migliora la visibilità del qrcode
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
                    
                    //prende tutto l'html dell'url
                    let html = try! String(contentsOf: url)
                    
                    //parsa(analizza) l'html tramite una "libreria" (SwiftSoup)
                    let document = try! SwiftSoup.parse(html)
                    
                    //estrapola il titolo dalla pagina parsata
                    title = try! String(document.title())
                    
                    //funzione per rimuovere "-wikipedia dal titolo"
                    shorten()
                    
                    titleForQR = title.replacingOccurrences(of: " ", with: "_")
                    print(titleForQR)
                }
                .buttonStyle(GrowingButton())
                
                
            }
            
        }
    }
    //funzione per formattare il titolo
    func shorten() {
        for i in 0...11 {
            if i == 11 && title.last == " "{
                
                //rimuove lo spazio finale del titolo
                title.removeLast()
            } else if i != 11 {
                
                //rimuove "-wikipedia"
                title.removeLast()
            }
        }
    }
    
    //funzione che genera il qr code (cerca online)
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




