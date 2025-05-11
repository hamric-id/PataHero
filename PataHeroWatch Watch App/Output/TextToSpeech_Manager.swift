//
//  TextToSpeech_Manager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 09/05/25.
//

import AVFoundation

class WatchSpeechManager {
    static let shared = WatchSpeechManager()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    private init() {}

    /// Speaks the given text using Indonesian voice
    func speak(_ text: String, language: String = "id-ID", rate: Float = 0.5) {
        print("hehe3")
        stop() // Stop any current speech
        guard let voice = AVSpeechSynthesisVoice(language: language) else {
            print("❌ Voice for language \(language) not available.")
            return
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = rate
        
        print("speak: \(text)")
        synthesizer.speak(utterance)
    }

    /// Stops speaking immediately
    func stop() {
        
        if synthesizer.isSpeaking {
            print("berhenti speak")
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    /// Checks if it's currently speaking
    var isSpeaking: Bool {
        return synthesizer.isSpeaking
    }
}
