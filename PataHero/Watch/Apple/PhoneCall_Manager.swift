
//
//  PhoneCallSession_Manager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 08/05/25.
//

import UIKit
import WatchConnectivity

class PhoneCall_Manager: NSObject, WCSessionDelegate {
    static let shared = PhoneCall_Manager()

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let number = message["call"] as? String {
            callPhoneNumber(number)
        }
    }

    private func callPhoneNumber(_ phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    // Required delegate methods for iOS
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
