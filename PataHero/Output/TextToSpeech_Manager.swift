//
//  TextToSpeech_Manager.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 09/05/25.
//

import AVFoundation

enum SpeakMode{
    case queue
    case force_individual //memaksa mematikan suara sebelumnya
    case overlap //mencampur suara meskipun suara sebelumnya belum selesai
}

enum SpeakResult{
    case finish
    case cancel
}

class TextToSpeech_Manager: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    private var listSpeak: [AVSpeechUtterance: (SpeakResult) -> Void] = [:]

//    private var queue = DispatchQueue(label:

    /// Speaks the given text using Indonesian voice
    func speak(_ text: String, language: String = "id-ID", rate: Float = 0.5, speechMode: SpeakMode = .force_individual, result: ((SpeakResult) -> Void)? = nil) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1"{ //jika bukan preview boleh tts. karena terlalu berat
            switch speechMode {
                case .queue:
                    break
                case .force_individual:
                    stop()
                case .overlap:
                    break
            }
            
            guard let voice = AVSpeechSynthesisVoice(language: language) else {
                print("❌ Voice for language \(language) not available.")
                return
            }

            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = voice
            utterance.rate = rate
            
            if let result = result {
                listSpeak[utterance] = result
            }

            
            print("speak: \(text)")
            synthesizer.speak(utterance)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if let speak = listSpeak[utterance] {
            speak(.finish)
            listSpeak.removeValue(forKey: utterance)
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        if let speak = listSpeak[utterance] {
            speak(.cancel)
            listSpeak.removeValue(forKey: utterance)
        }
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
