//
//  WatchSession_Manager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 17/05/25.
//

//untuk transfer data dengan iOS

import WatchConnectivity
import SwiftUI

class iOSCommunication_Manager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var isReachable = false
    @Published var ReceivedData: String?
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func send(_ HandGesture: HandGesture) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["HandGesture": HandGesture.rawValue], replyHandler: nil, errorHandler: { error in
                print("⌚️ Error sending message: \(error)")
            })
        } else {
            print("⌚️ iPhone not reachable")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("⌚️ Session activated")
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
}
