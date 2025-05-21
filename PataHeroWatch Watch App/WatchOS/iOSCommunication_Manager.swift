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
    private var session: WKExtendedRuntimeSession?
    
    private let tryableErrorCode:[WCErrorCode] = [
            .messageReplyFailed,
            .messageReplyTimedOut,
            .deliveryFailed,
            .transferTimedOut
        ]
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            
            
        }
    }

    //JIKA STATUS false LALU DIBALAS TRUE maka artinya permintaan ulang mengirim
    //jika handgesture dan digitalcrown nil maka aksi dari sentuhan
    //otherinformation mengenari sleected tomboll, prosedur apa, step ke berapa'
    //other information hanya bisa string, int, bool
    func send(_ ScreenType: ScreenType,_ otherInformation:[String:Any], handGesture: HandGesture? = nil,digitalCrownRotate :DigitalCrownRotate?=nil, voice:String?=nil, status: @escaping (Bool) -> Bool = { _ in false }) { //status jika tidak dipakai maka otomatis false/tidak minta ulang kirim
        var listData : [String:Any] = ["ScreenType": ScreenType.rawValue]
        listData.merge(otherInformation) { (_, newValue) in newValue }
        if let handGesture = handGesture {listData["HandGesture"] = handGesture.rawValue}
        if let digitalCrownRotate = digitalCrownRotate {listData["DigitalCrownRotate"] = digitalCrownRotate.rawValue}
        if let voice = voice {listData["Voice"] = voice}
        
        var debugText = "(⌚️->📱) "
        debugText+=listData.map { "\($0.key): \($0.value)" }.joined(separator: "; ")
        
        
        var sendTime : Date? = nil //= Date()
        
        func trySend() {
            func failed(_ error: Error?=nil){
                var text = "❌ \(debugText) [Error = \(error)]"
                if let error = error{text+="[Error = \(error)]"}
                print(text)
                
                func tryableError()->Bool{
                    if let nsError = error as NSError?,
                        nsError.domain == WCErrorDomain,
                        let wCErrorCode = WCErrorCode(rawValue: nsError.code) {
                       
                        if [WCErrorCode.sessionNotActivated,
                            WCErrorCode.sessionInactive].contains(wCErrorCode){
                            WCSession.default.activate()
                        }else if wCErrorCode == WCErrorCode.sessionNotActivated{
                            WCSession.default.delegate = self
                        }
                        
                        return [
                            .messageReplyFailed,
                            .messageReplyTimedOut,
                            .deliveryFailed,
                            .transferTimedOut
                        ].contains(wCErrorCode)
                    }else if error==nil{return false
                    }else{ return true }
                }
                
                if tryableError() {
                    if Int(Date().timeIntervalSince(sendTime!) * 1000)<500{
                        trySend()
                    }else if status(false){
                        sendTime = nil
                        trySend()
                    }
                }else{ status(false)} //jika error parah (percuma dikirim ulang tidka ada gunanya
            }
            
            
            if sendTime==nil {sendTime = Date()}
            if WCSession.default.isReachable {
                print("⏳ \(debugText)")
                
                WCSession.default.sendMessage(
                    listData,
                    replyHandler: { statusSending in
                    func fail(){
                        print("gagal \(handGesture)")
                        failed(AppCrash("\(debugText) corrupt when sending"))
                    }
                    
                    if let statusSending = statusSending["status"] as? Bool{
                        if statusSending {
                            print("✅ \(debugText)")
                            status(true)
                        }else{fail()}
                    }else{fail()}
                }, errorHandler: { error in failed(error)})
            } else { failed() }
        }
        
        if WCSession.isSupported() {trySend()
        }else{ print("this WatchOS doesnt support communication to iOS")}
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("iOS Communication Manager activated on ⌚️")
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
}


////ini untuk di watchOS
//import WatchConnectivity
//import SwiftUI
//
//class iOSCommunication_Manager: NSObject, ObservableObject, WCSessionDelegate {
//    @Published var isReachable = false
//    @Published var dataFromIOS: String? //panggil ini di view kalau mau terima data dari iOS
//    
//    override init() {
//        super.init()
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//        }
//    }
//    
//    //menerima data dari iOS (diterima oleh watchOS)
//    func session(_ session: WCSession, didReceiveMessage message: [String : String]) {
//        DispatchQueue.main.async {
//            if let raw = message["dataFromiOS"] as? String{
//                print("✅ (📱->⌚️) dataFromiOS: \(raw)")
//                self.dataFromIOS = raw
//            }
//        }
//    }
//    
//    //untuk mengirim data string dari watchOS ke iOS, panggil ini
//    func send(_ dataFromWatchOS: String) {
//        let debugText = "(⌚️->📱) dataFromWatchOS: \(dataFromWatchOS)"
//        if WCSession.default.isReachable {
//            print("⏳ \(debugText)")
//            WCSession.default.sendMessage(["dataFromWatchOS": dataFromWatchOS], replyHandler: nil, errorHandler: { error in
//                print("❌ \(debugText) [Error = \(error)]")
//            })
//        } else {print("❌ \(debugText)")}
//    }
//
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        print("⌚️ Session activated")
//    }
//
//    func sessionReachabilityDidChange(_ session: WCSession) {
//        DispatchQueue.main.async {
//            self.isReachable = session.isReachable
//        }
//    }
//}
