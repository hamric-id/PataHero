//
//  HandGesture.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 11/05/25.
//


enum HandGesture : String{
    case lower
    case raise
    case away_from_chest
    case close_to_chest
    case wrist_twist_in
    case wrist_twist_out
    case punch
    case retract_punch
}

extension HandGesture{
    func name() -> String{
        self.rawValue
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
            .replacingOccurrences(of: " From", with: " from")//harusnya from dan to tidak perlu capitalized
            .replacingOccurrences(of: " To", with: " to")
    }
}
