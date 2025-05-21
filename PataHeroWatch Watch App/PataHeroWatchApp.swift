//
//  PataHeroWatchApp.swift
//  PataHeroWatch Watch App
//
//  Created by Muhammad Hamzah Robbani on 05/05/25.
//

import SwiftUI

@main
struct PataHeroWatch_Watch_App: App {
    @StateObject private var handGesture_Manager = HandGesture_Manager()
    @StateObject private var IOSCommunication_Manager = iOSCommunication_Manager()
    @StateObject private var textToSpeech_Manager = TextToSpeech_Manager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(handGesture_Manager)
                .environmentObject(IOSCommunication_Manager)
                .environmentObject(textToSpeech_Manager)
        }
    }
}


////tambahkan @StateObject private var IOSCommunication_Manager = iOSCommunication_Manager() di WatchApp
////tambahkan .environmentObject(IOSCommunication_Manager) setelah ContentView()
////misal:
//import SwiftUI
//
//@main
//struct PataHeroWatch_Watch_App: App {
//    @StateObject private var IOSCommunication_Manager = iOSCommunication_Manager()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(IOSCommunication_Manager)
//        }
//    }
//}
