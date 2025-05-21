//
//  Wa.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 17/05/25.
//

import Foundation
import WatchConnectivity

class WatchOSCommunication_Manager: NSObject, ObservableObject, WCSessionDelegate {
    private var lastReceivedInputTime = Date.distantPast
    @Published var handGesture: HandGesture? {
        didSet {
            if let handGesture = self.handGesture {
                let showTime = 1 //second
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(showTime)) {
                    if self.handGesture != nil && Date().timeIntervalSince(self.lastReceivedInputTime) > Double(showTime) {
                        DispatchQueue.main.async {self.handGesture=nil}
                    }//jika terakhir pendeteksian(ketemu gesture) dibawah 1 detik maka tidak diterima (agar tidak terlalu noise
                }
            }
        }
    }
    @Published var screenInformation: ScreenInformation = ScreenInformation(.Main,nil)
    @Published var digitalCrownRotate: DigitalCrownRotate? {
        didSet {
            if let digitalCrownRotate = self.digitalCrownRotate {
                let showTime = 1 //second
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(showTime)) {
                    if self.digitalCrownRotate != nil && Date().timeIntervalSince(self.lastReceivedInputTime) > Double(showTime)  {
                        DispatchQueue.main.async {self.digitalCrownRotate=nil}
                    }//jika terakhir pendeteksian(ketemu gesture) dibawah 1 detik maka tidak diterima (agar tidak terlalu noise
                }
            }
        }
    }
    @Published var voice: String?  {
        didSet {
            if let voice = self.voice {
                let timeDisappear = Float(voice.countVowels())*0.6
            
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(Int(timeDisappear))) {
                    if self.voice != nil && Date().timeIntervalSince(self.lastReceivedInputTime) > Double(timeDisappear) {
                        DispatchQueue.main.async {self.voice=nil}
                    }//jika terakhir pendeteksian(ketemu gesture) dibawah 1 detik maka tidak diterima (agar tidak terlalu noise
                }
            }
        }
    }
    

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    //menerima data dari watchos (ke iOS)
    //secara protokol wajib tipe [String,Any] di didReceiveMessage dan replyHandler
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String:Any]) -> Void) {
        lastReceivedInputTime = Date()
        
        if let HandGestureRaw = message["HandGesture"] as? String,
            let HandGesture = HandGesture(rawValue: HandGestureRaw){
                DispatchQueue.main.async {self.handGesture = HandGesture}
        }
        
        if let DigitalCrownRotateRaw = message["DigitalCrownRotate"] as? String,
            let DigitalCrownRotate = DigitalCrownRotate(rawValue: DigitalCrownRotateRaw){
                DispatchQueue.main.async {self.digitalCrownRotate = DigitalCrownRotate}
        }
        
        if let voice = message["Voice"] as? String{
            DispatchQueue.main.async {self.voice = voice}
        }
        
        if let ScreenTypeRaw = message["ScreenType"] as? String,
           let ScreenType = ScreenType(rawValue: ScreenTypeRaw) {
            var screenDetailInformation : [String:Any]? = message
            ["ScreenType","HandGesture","DigitalCrownRotate","Voice"].forEach {screenDetailInformation?.removeValue(forKey: $0)}
            
            if screenDetailInformation?.count == 0 {screenDetailInformation = nil}
            
            DispatchQueue.main.async {
                self.screenInformation = ScreenInformation(ScreenType,screenDetailInformation)
            }
            replyHandler(["HandGesture":true])
        }else{
            print("❌ (⌚️->📱) HandGesture:??")
            replyHandler(["HandGesture":false])
        }
        
        var debugText = "✅ (⌚️->📱) "
        debugText+=message.map { "\($0.key): \($0.value)" }.joined(separator: "; ")
        print(debugText)
    }
    
    //kalau mau ngirim data string dari watchOS ke iOS, panggil ini
    func send(_ dataCoba: String) {
        let debugText = "(📱->⌚️) Data: \(dataCoba)"
        if WCSession.default.isReachable {
            print("⏳ \(debugText)")
            WCSession.default.sendMessage(["dataCoba": dataCoba], replyHandler: nil, errorHandler: { error in
                print("❌ \(debugText) [Error = \(error)]")
            })
        } else {print("❌ \(debugText)")}
    }
    
    //JIKA STATUS false LALU DIBALAS TRUE maka artinya permintaan ulang mengirim
    func send(_ HandGesture: HandGesture, status: @escaping (Bool) -> Bool = { _ in false }) { //status jika tidak dipakai maka otomatis false/tidak minta ulang kirim
        let debugText = "(⌚️->📱) HandGesture: \(HandGesture)"
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
                WCSession.default.sendMessage(["HandGesture": HandGesture.rawValue as String], replyHandler: { success in
                    func fail(){
                        print("gagal \(HandGesture)")
                        failed(AppCrash("HandGesture.\(HandGesture.rawValue) corrupt when sending"))
                    }
                    
                    if let success = success["HandGesture"] as? Bool{
                        if success {
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
        print("📱 WCSession activated with state: \(activationState)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
}

////buat file baru ini di iOS
//import Foundation
//import WatchConnectivity
//
//class WatchOSCommunication_Manager: NSObject, ObservableObject, WCSessionDelegate {
//    @Published var dataFromWatchOS: String?
//
//    override init() {
//        super.init()
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//        }
//    }
//    
//    //menerima data dari watchos (ke iOS)
//    func session(_ session: WCSession, didReceiveMessage message: [String : String]) {
//        DispatchQueue.main.async {
//            if let raw = message["dataFromWatchOS"] as? String{
//                print("✅ (⌚️->📱) dataFromWatchOS: \(raw)")
//                self.dataFromWatchOS = raw
//            }
//        }
//    }
//
//    //kalau mau ngirim data string dari watchOS ke iOS, panggil ini
//    func send(_ dataFromiOS: String) {
//        let debugText = "(📱->⌚️) Data: \(dataFromiOS)"
//        if WCSession.default.isReachable {
//            print("⏳ \(debugText)")
//            WCSession.default.sendMessage(["dataFromiOS": dataFromiOS], replyHandler: nil, errorHandler: { error in
//                print("❌ \(debugText) [Error = \(error)]")
//            })
//        } else {print("❌ \(debugText)")}
//    }
//
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        print("📱 WCSession activated with state: \(activationState)")
//    }
//    
//    func sessionDidBecomeInactive(_ session: WCSession) {}
//    func sessionDidDeactivate(_ session: WCSession) {}
//}
