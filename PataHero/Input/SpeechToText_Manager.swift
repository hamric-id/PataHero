////
////  SpeechToText_Manager.swift
////  PataHero
////
////  Created by Muhammad Hamzah Robbani on 19/05/25.
////
//
//import Foundation
//import AVFoundation
//import Combine
//#if !os(watchOS)
//import Speech
//#endif
//
//class SpeechToText_Manager: NSObject, ObservableObject {
//    private var audioEngine = AVAudioEngine()
//    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    private var recognitionTask: SFSpeechRecognitionTask?
//    private var speechRecognizer: SFSpeechRecognizer?
//    @Published var detected_transcript: String = ""
//    @Published var detecting = false //mendeteksi apakah sedang mendeteksi secara realtime
//    @Published var error = false
//    private var detecting_state=false //untuk menyimpan perintah terakhir apa. karena bisa saja disuruh mendeteksi tapi ternyata sekarang berhenti mendeteksi karena sedang proses mencerna suara
//    private var locale: Locale
//
//    init(locale: Locale = Locale(identifier: "en-US")) {
//        self.locale = locale
//        super.init()
//        self.speechRecognizer = SFSpeechRecognizer(locale: locale)
//        self.speechRecognizer?.delegate = self
//        requestAuthorization()
//    }
//
//    func requestAuthorization() {
//        SFSpeechRecognizer.requestAuthorization { status in
//            DispatchQueue.main.async {
//                switch status {
//                case .authorized:
//                    print("Speech recognition authorized")
//                case .denied, .restricted, .notDetermined:
//                    print("Speech recognition not available")
//                @unknown default:
//                    break
//                }
//            }
//        }
//    }
//
//    func startDetecting() {
//        guard !audioEngine.isRunning,
//              let recognizer = speechRecognizer,
//              recognizer.isAvailable else {
//            print("Speech recognizer not ready")
//            return
//        }
//
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        recognitionRequest?.shouldReportPartialResults = true
//
//        guard let recognitionRequest = recognitionRequest else { return }
//
//        let inputNode = audioEngine.inputNode
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.removeTap(onBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
//            [weak self] buffer, _ in
//            self?.recognitionRequest?.append(buffer)
//        }
//
//        do {
//            audioEngine.prepare()
//            try audioEngine.start()
//        } catch {
//            print("Audio Engine couldn't start: \(error)")
//            return
//        }
//
//        detecting = true
//        detecting_state=true
//        self.error = false
//
//        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
//            if let result = result {
//                DispatchQueue.main.async {
//                    self?.detected_transcript = result.bestTranscription.formattedString
//                }
//            }
//   
//            if let error = error {
//                self?.error = true
//                print("STT error: \(error.localizedDescription)")
//            }
//
//            if error != nil || (result?.isFinal ?? false) {
//                self?.stopDetecting(true){
//                    startDetecting()
//                }
//            }
//        }
//    }
//
//    func stopDetecting(_ stopBySystem: Bool = false, stopped: (() -> Void)? = nil) {
//        if audioEngine.isRunning {
//            audioEngine.stop()
//            recognitionRequest?.endAudio()
//        }
//        audioEngine.inputNode.removeTap(onBus: 0)
//        recognitionTask?.cancel()
//        recognitionRequest = nil
//        recognitionTask = nil
//        detecting = false
//        if !stopBySystem{detecting_state=false}
//        
//        // Wait 0.3 seconds before calling completion to let audio engine and recognizer settle
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            stopped?()
//        }
//    }
//
//    func setLocale(_ newLocale: Locale) {
//        stopDetecting()
//        locale = newLocale
//        speechRecognizer = SFSpeechRecognizer(locale: locale)
//    }
//}
//
//extension SpeechToText_Manager: SFSpeechRecognizerDelegate {
//    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        print("Recognizer availability changed: \(available)")
//    }
//}
////
////class SpeechToText_Manager: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
////    private var speechRecognizer  = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
////    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
////    private var recognitionTask: SFSpeechRecognitionTask?
////    private let audioEngine = AVAudioEngine()
////    
////    init(_ locale: Locale = Locale(identifier: "en-US")){
////        self.speechRecognizer = SFSpeechRecognizer(locale: locale)
////    }
////    
////    @Published var transcript = ""
////    
////    override init() {
////        super.init()
////        speechRecognizer?.delegate = self
////        requestAuthorization()
////    }
////    
////    func requestAuthorization() {
////        SFSpeechRecognizer.requestAuthorization { status in
////            switch status {
////            case .authorized: print("Speech recognition authorized")
////            default: print("Speech recognition not authorized")
////            }
////        }
////    }
////
////    func startTranscribing() {
////        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
////            print("Speech recognizer not available")
////            return
////        }
////
////        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
////        let inputNode = audioEngine.inputNode
////        guard let recognitionRequest = recognitionRequest else { return }
////        recognitionRequest.shouldReportPartialResults = true
////        
////        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
////            if let result = result {
////                DispatchQueue.main.async {
////                    self?.transcript = result.bestTranscription.formattedString
////                }
////            }
////            if error != nil || (result?.isFinal ?? false) {
////                self?.audioEngine.stop()
////                inputNode.removeTap(onBus: 0)
////                self?.recognitionRequest = nil
////                self?.recognitionTask = nil
////            }
////        }
////
////        let recordingFormat = inputNode.outputFormat(forBus: 0)
////        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
////            recognitionRequest.append(buffer)
////        }
////
////        audioEngine.prepare()
////        try? audioEngine.start()
////    }
////
////    func stopTranscribing() {
////        audioEngine.stop()
////        recognitionRequest?.endAudio()
////    }
////}
