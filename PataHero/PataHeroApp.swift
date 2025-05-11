//
//  PataHeroApp.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 21/03/25.
//

import SwiftUI
import WatchConnectivity

    
@main
struct PataHeroApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        _ = PhoneCall_Manager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {var handGesture_Manager = HandGesture_Manager()}


