//
//  Untitled.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 08/05/25.
//
import WatchConnectivity

//return string error jika ada error
func callPhoneNumber(_ phoneNumber: String, error1: @escaping (Error) -> Void) {
    if WCSession.default.isReachable {
        WCSession.default.sendMessage(["call": phoneNumber], replyHandler: nil, errorHandler: { error in
            print("Error sending message: \(error)")
            error1(error)
        })
    }
}
