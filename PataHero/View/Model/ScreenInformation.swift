//
//  ScreenType.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 18/05/25.
//

struct ScreenInformation: Equatable{
    let ScreenType: ScreenType
    let otherInformation: [String:Any]?
    
    init(_ ScreenType: ScreenType, _ otherInformation: [String:Any]?){
        self.ScreenType = ScreenType
//        var otherInformation = otherInformation
        if var otherInformation = otherInformation{ //semua key yang berakhir LocationFractures diubah valuenya dari string menjadi enum LocaitonFractures
            self.otherInformation  = Dictionary(uniqueKeysWithValues: otherInformation.map { key, value in
                if key.hasSuffix("LocationFractures"),
                    let locationFracturesRaw = value as? String,
                    let locationFractures = LocationFractures(rawValue: locationFracturesRaw){
                    return (key, locationFractures)  // example: change name to uppercase
                } else { return (key, value)     }
            })
        }else{self.otherInformation = nil}
    }
    
    static func == (lhs: ScreenInformation, rhs: ScreenInformation) -> Bool { //supaya bisa equatable tapi tidak dicek otherinformation
        return lhs.ScreenType == rhs.ScreenType
        // Not comparing `data` because it's not Equatable
    }
}

enum ScreenType: String {
    case Main
    case Procedure
    case Hospital
    case CallPhone
}
