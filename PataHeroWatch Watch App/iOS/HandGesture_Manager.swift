//
//  HandGestureManager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 05/05/25.
//

import Foundation
import CoreMotion
import Combine


enum HandGesture{
    case lower
    case raise
    case away_from_chest
    case close_to_chest
    case wrist_twist_in
    case wrist_twist_out
}

class HandGesture_Manager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var lastGestureTime = Date.distantPast

    @Published var handGesture: HandGesture?

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

            let now = Date()
            if now.timeIntervalSince(self.lastGestureTime) < 0.8 {//jika terakhir pendeteksian(ketemu gesture) dibawah 1 detik maka tidak diterima (agar tidak terlalu noise
                return
            }else {if handGesture != nil {handGesture = nil;print("gesture tidak terdeteksi")}}
            
            //ini semua dengan asumsi konfigurasi apple watch di kiri tangan, digital crown dekat dengan pergelangan tangan. jika tidak mungkin nilainya harus diatur minuys dan jebalik
            if motion.rotationRate.y > 3.0 {
                self.register(HandGesture.lower, now: now) //menurunkan pergelangan tengan dengan tumpuan sendi lengan
            }else if motion.rotationRate.y < -3.0 {
                self.register(HandGesture.raise, now: now) //menaikkan pergelangan tengan dengan tumpuan sendi lengan
            }else if motion.rotationRate.z > 3.0 {
                self.register(HandGesture.away_from_chest, now: now) //mendekatkan pergelangan tangan ke dada dengan tumpuan sendi lengan
            }else if motion.rotationRate.z < -3.0 {
                self.register(HandGesture.close_to_chest, now: now) //menjauhkan pergelangan tangan dari dada dengan tumpuan sendi lengan
            }else if motion.rotationRate.x > 3.0 {
                self.register(HandGesture.wrist_twist_in, now: now) //memutar pergelangan tangan ke arah keluar/kelingking //dengan asumsi konfigurasi apple watch di kiri tangan, digital crown dekat dengan pergelangan tangan
            }else if motion.rotationRate.x < -5.0 {
                self.register(HandGesture.wrist_twist_out, now: now) //memutar pergelangan tangan ke arah keluar/kelingking //dengan asumsi konfigurasi apple watch di kiri tangan, digital crown dekat dengan pergelangan tangan
            }
        }
    }

    private func register(_ handGesture: HandGesture, now: Date) {
        self.lastGestureTime = now
        print("gesture= \(handGesture)")
        DispatchQueue.main.async {
            self.handGesture = handGesture
        }
    }
}
