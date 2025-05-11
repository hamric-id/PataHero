//
//  TextToSpeech_Manager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 09/05/25.
//

import AVFoundation

class TextToSpeech_Manager {
    static let Manager = TextToSpeech_Manager() //ini digunakan sebagai variabel global
    
    private let synthesizer = AVSpeechSynthesizer()

    /// Speaks the given text using Indonesian voice
    func speak(_ text: String, language: String = "id-ID", rate: Float = 0.5) {
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
