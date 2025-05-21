//
//  Wa.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 17/05/25.
//

import Foundation
import WatchConnectivity

class WatchCommunication_Manager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var handGesture: HandGesture?

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let raw = message["HandGesture"] as? String,
                let handGesture = HandGesture(rawValue: raw) {
                print("📱 Received HandGesture: \(handGesture)")
                self.handGesture = handGesture
            }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("📱 WCSession activated with state: \(activationState)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
}
