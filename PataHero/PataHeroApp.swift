//
//  PataHeroApp.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 21/03/25.
//

import SwiftUI
import WatchConnectivity

enum LocalDataKey{
    case Shortcut_ScreenRequest
}

extension LocalDataKey {
    func name() -> String {String(describing: self)}
}


    
@main
struct PataHeroApp: App {
    @StateObject private var watchCommunication_Manager = WatchOSCommunication_Manager()
    @AppStorage(LocalDataKey.Shortcut_ScreenRequest.name()) private var Shortcut_ScreenRequest = false//: String?
    @StateObject private var textToSpeech_Manager = TextToSpeech_Manager()
//    @StateObject private var speechToText_Manager = SpeechToText_Manager()
    

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(watchCommunication_Manager)
                .environmentObject(textToSpeech_Manager)
//                .environmentObject(speechToText_Manager)
        }
    }
}
