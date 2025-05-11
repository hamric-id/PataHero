//
//  PhoneCall_Manager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 08/05/25.
//

import WatchConnectivity

class PhoneCall_Manager: NSObject, WCSessionDelegate {
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // ✅ Required for watchOS
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated with state: \(activationState.rawValue)")
    }

    // ✅ Add these even if unused, to satisfy protocol on some Xcode versions
    //func sessionDidBecomeInactive(_ session: WCSession) {}
    //func sessionDidDeactivate(_ session: WCSession) {}
}
