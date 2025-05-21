//
//  DataCuplikanProsedurPatahTulang.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 21/03/25.
//

import SwiftUI
import Foundation

// Model
struct DataPreviewFractures:Identifiable {//ini data class
    let locationFractures: LocationFractures
    let id = UUID()
    
    //nama ilustrasi wajib $locationFractures_patah_tulang
    func imageName()-> String {"\(locationFractures)_patah_tulang"}
    
    init(_ locationFractures: LocationFractures){self.locationFractures = locationFractures}
}


//x adalah stepKe
struct StepProcedureFractures {//ini data class
    private let description1: ContiguousArray<UInt8>
    private let specialImageName: ContiguousArray<UInt8>?//karena step terakhir selalu sama foto dan deskripsinya yaitu hubungi eka hospital,
    
    func description()-> String{ description1.String1() }
    
    //nama ilustrasi wajib $stepX_$locationFracture_patah_tulang
    func imageName(_ locationFractures: LocationFractures,_ stepTo:UInt8)-> String{ specialImageName?.String1() ?? "step\(stepTo)_\(locationFractures)_patah_tulang"  }
    
    //specialimagename digunakan jika nama gambarnya khusus/tidak berpola/dipakai diberbagai tempat. spt gambar step terakhir semua prosedur selalu sama
    init(_ description: String,_ specialImageName: String?=nil){
        description1 = description.ContingousArray()
        self.specialImageName = specialImageName?.ContingousArray()
        //imageName1 = Array(imageName)
    }
}

enum LocationFractures: String, CaseIterable, Codable{
    case lengan, jari, pergelangan_tangan
}
extension String {
    func toLocationFractures()-> LocationFractures? {LocationFractures(rawValue: self)}
}

extension LocationFractures {
    func name()->String {String(describing: self).replacingOccurrences(of: "_", with: " ").capitalized}
}





