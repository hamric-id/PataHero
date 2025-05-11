//
//  AppleWatchSession_Manager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 05/05/25.
//

import Foundation
import WatchConnectivity

class HandGesture_Manager: NSObject, WCSessionDelegate, ObservableObject {
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //untuk menerima data dari apple watch
        if let gesture = message["gesture"] as? String {
            print("🎉 Gesture received from Watch: \(gesture)")
            // You can update your UI or trigger an action here
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
