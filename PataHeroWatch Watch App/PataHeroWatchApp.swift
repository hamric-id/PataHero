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
//    let phoneCall_Manager = PhoneCall_Manager() // 👈 Initialize the session here
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(handGesture_Manager)
        }
    }
}
