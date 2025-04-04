//
//  DataCuplikanProsedurPatahTulang.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 21/03/25.
//


//  dataFracture.swift
//  Patahero

import SwiftUI

// Model
struct DataCuplikanProsedurPatahTulang {//ini data class
    var id: UInt8
    var name: String
    var imagePath: String
    var description: String
}

struct Procedure {//ini data class
    var step: String
    var videoPath: String
}

// Data
let listFracture = [
    ProsedurPatahTulang(id: 1, name: "Patah Tulang Lengan", imagePath: "figure.handball", description: "Sebuah deskripsi patah tulang lengan"),
    ProsedurPatahTulang(id: 2, name: "Patah Tulang Jari", imagePath: "hand.point.up.braille.fill", description: "Sebuah deskripsi patah tulang jari"),
    ProsedurPatahTulang(id: 3, name: "Patah Tulang Pergelangan Tangan", imagePath: "hands.and.sparkles", description: "Sebuah deskripsi patah tulang pergelangna tangan"),
]

let armProcedure = [
    Procedure(step: "Tahan tangan agar tidak bergerak dengan penahan", videoPath: "RTW"),
    Procedure(step: "Hubungi kontak darurat Eka Hospital", videoPath: "videocoba"),
]

let fingerProcedure = [
    Procedure(step: "Tahan jari yang patah agar tidak bergerak sehingga tidak menyebabkan keparahan", videoPath: "RTW"),
    Procedure(step: "Hubungi kontak darurat Eka Hospital", videoPath: "videocoba"),
]

let handProcedure = [
    Procedure(step: "Tahan pergelangan tangan agar tidak bergerak dengan penahan", videoPath: "RTW"),
    Procedure(step: "Balut pergelangan tangan dengan kain", videoPath: "videocoba"),
    Procedure(step: "Hubungi kontak darurat Eka Hospital", videoPath: "RTW"),
]


