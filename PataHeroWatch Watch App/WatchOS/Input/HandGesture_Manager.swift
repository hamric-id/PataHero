//
//  HandGestureManager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 05/05/25.
//

import Foundation
import CoreMotion
import Combine
import WatchConnectivity

enum AppleWatch_PhysicData {
    case attitude_pitch
    case userAcceleration_x
}

class HandGesture_Manager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var lastGestureTime = Date.distantPast
    private var lastDataHandGesture: [AppleWatch_PhysicData: Float]? = nil
    @Published var handGesture: HandGesture? {
        didSet {
            
        }
    }

    init() {
        startDetection()
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }

    private func startDetection() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion not available.")
            return
        }

        motionManager.deviceMotionUpdateInterval = 0.1  // Slower = less memory/CPU

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self = self, let motion = motion else { return }

            let timeNow = Date()
            if timeNow.timeIntervalSince(lastGestureTime) < 0.6 {//jika terakhir pendeteksian(ketemu gesture) dibawah 1 detik maka tidak diterima (agar tidak terlalu noise
                return
            }else {
                if lastDataHandGesture != nil && timeNow.timeIntervalSince(lastGestureTime) > 1.3{
                    lastDataHandGesture=nil
                }
                
                if handGesture != nil {handGesture = nil;print("gesture tidak terdeteksi")}
            }
            
            func gestureReport(_ handGesture: HandGesture) {
                self.lastGestureTime = timeNow
                
                if [HandGesture.wrist_twist_in,HandGesture.wrist_twist_out].contains(handGesture){
                    lastDataHandGesture = [.attitude_pitch:Float(motion.attitude.pitch)]
                }else if [HandGesture.retract_punch,HandGesture.punch].contains(handGesture){
                    lastDataHandGesture = [.userAcceleration_x:Float(motion.userAcceleration.x)]
                }
           
                print("gesture= \(handGesture): R(\(motion.rotationRate.x),\(motion.rotationRate.y),\(motion.rotationRate.z)); A(\(motion.userAcceleration.x),\(motion.userAcceleration.y),\(motion.userAcceleration.z))")
                DispatchQueue.main.async {
                    self.handGesture = handGesture
                }
            }
            
            //ini semua dengan asumsi konfigurasi apple watch di kiri tangan, digital crown dekat dengan pergelangan tangan. jika tidak mungkin nilainya harus diatur minuys dan jebalik
            if motion.rotationRate.y > 3.0 { gestureReport(HandGesture.lower) //menurunkan pergelangan tengan dengan tumpuan sendi lengan
            }else if motion.rotationRate.y < -3.0 { gestureReport(HandGesture.raise) //menaikkan pergelangan tengan dengan tumpuan sendi lengan
            }else if motion.rotationRate.z > 3.0 { gestureReport(HandGesture.away_from_chest) //mendekatkan pergelangan tangan ke dada dengan tumpuan sendi lengan
            }else if motion.rotationRate.z < -3.0 { gestureReport(HandGesture.close_to_chest) //menjauhkan pergelangan tangan dari dada dengan tumpuan sendi lengan
            }else if motion.rotationRate.x > 3.0 {
                func report() {gestureReport(HandGesture.wrist_twist_in)}
                
                if let lastDataHandGesture1 =  lastDataHandGesture?[AppleWatch_PhysicData.attitude_pitch]{
                    if (-1.6 ... -0.4).contains(lastDataHandGesture1){ lastDataHandGesture = nil}else{report()}
                }else{ report()} //memutar pergelangan tangan ke arah keluar/kelingking //dengan asumsi konfigurasi apple watch di kiri tangan, digital crown dekat dengan pergelangan tangan
            }else if motion.rotationRate.x < -5.0 {
                func report() {gestureReport(HandGesture.wrist_twist_out)}
            
                if let lastDataHandGesture1 =  lastDataHandGesture?[AppleWatch_PhysicData.attitude_pitch]{
                    if (-0.5 ... 1.4).contains(lastDataHandGesture1){ lastDataHandGesture = nil}else{report()}
                }else{ report()} //memutar pergelangan tangan ke arah keluar/kelingking //dengan asumsi konfigurasi apple watch di kiri tangan, digital crown dekat dengan pergelangan tangan
            }else if (0.55...1.3).contains(motion.userAcceleration.x) {
                func report() {gestureReport(HandGesture.retract_punch)}
                
                if let lastDataHandGesture1 =  lastDataHandGesture?[AppleWatch_PhysicData.userAcceleration_x]{
                    if lastDataHandGesture1<0{ lastDataHandGesture = nil}else{report()}
                }else{ report()} //menarik tonjokan
            }else if (-1.3 ... -0.55).contains(motion.userAcceleration.x) {
                func report() {gestureReport(HandGesture.punch)}
                
                if let lastDataHandGesture1 =  lastDataHandGesture?[AppleWatch_PhysicData.userAcceleration_x]{
                    if lastDataHandGesture1>=0{ lastDataHandGesture = nil}else{report()}
                }else{ report()} //menonjok
            }
            
//            print("attitude= \(motion.attitude.pitch),\(motion.attitude.roll),\(motion.attitude.yaw)")
        }
    }
}
