//
//  ToolsInformation_Screen.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 28/04/25.
//

import SwiftUI


//struct ToolsInformation_Screen: View {
//    @State private var showSheet = false
//
//    var body: some View {
//        VStack {
//            Button("Show Custom Alert") {
//                showSheet = true
//            }
//        }
//        .sheet(isPresented: $showSheet) {
//            CustomAlertView()
//                .presentationDetents([ .large]) // Optional, makes sheet small like a dialog
//                .presentationDragIndicator(.visible) // Optional, shows the drag handle
//        }
//    }
//}

struct ToolsInformation_Screen: View {
    let close_request: (Bool) -> Void
    private let listTools = ["perban","betadine","kayu","es batu"]
    
    init(_ close_request: @escaping (Bool) -> Void) { self.close_request = close_request }

    var body: some View {
        GeometryReader { geometry in
            VStack() {
                HStack{
                    Spacer()
                    Text("Peralatan")
                        .font(.title)
                        .bold(true)
                    Spacer()
                    Button{close_request(true)}label:{}.buttonStyle(
                        ButtonStyleSimple(Color.reversePrimary,Color("red"),27,Color.primary,iconName:"xmark")
                    ).padding(.trailing,10)
                }.frame(maxWidth: geometry.size.width)
                
                Text(
                    listTools.enumerated().map { index, item in
                        let suffix = (index < listTools.count - 1) ? "\n" : ""
                        return "• \(item)\(suffix)".capitalized
                    }.joined()
                )
                .padding(.trailing,95)
                
                Image("maps_contoh")
                    .resizable()//lankali ganti mapkit
//                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .padding(.top,20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct CustomAlertView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Dialog with TabView")
                .font(.headline)

            TabView {
                VStack(alignment: .leading) {
                    Text("Peralatan:")
                        .font(.title)
                        .bold(true)
                    
                    Text("-perban\n-es batu\n")
                    Image("maps_contoh").resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                    
                }.tabItem { Text("Tab 1") }
                Text("-perban\n-es batu\n").tabItem { Text("Tab 2") }
                Text("Tab 2 Content").tabItem { Text("Tab 3") }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 700)

//            Button("Close") {
//                // Handle close action
//            }
//            .padding()
        }
        .padding()
    }
}

#Preview {
    ToolsInformation_Screen{close_request in
        print("ditekan")
    }
    //ToolsInformation_Screen()
}


