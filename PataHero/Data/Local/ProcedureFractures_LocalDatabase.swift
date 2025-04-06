
//
//  Database.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 28/03/25.
//



// cara panggilnya LocationFractures.totalStepProcedureFractures()
extension LocationFractures{
    
    //ini dibuat jika suatu saat ada restapi (restapi hanya di get saat pertamakali instal app saja, sehingga setelah itu bisa mode offline) agar data dinamis
    //ini lebih hemat ram karena data disimpan di storage, lalu di get step tertentu saat dibutuhkan saja
    //stepto/stepke berapa
    func stepProcedureFractures(_ stepTo:UInt8)-> StepProcedureFractures {listProcedure()[Int(stepTo)-1]}
    
    //untuk mengatur jumlah pentol di progressbar
    func totalStepProcedureFractures()-> UInt8 {UInt8(listProcedure().count)}
    
    func listProcedure()-> [StepProcedureFractures] { //private karena hanya untuk disini
        //harusnya ini get ke swiftdata, lalu jika tidak ada get ke restapi (hanya saat pertamakali instal app,langsung get semua prosedur)
        lazy var rawListProcedure = switch self { //dibuat lazy agar ringan
            case .jari: [
                StepProcedureFractures("Balut jari yang patah dengan jari sebelahnya sebagai penyangga"),
                StepProcedureFractures("Kompres es yang terbungkus dengan kain untuk mengurangi bengkak")
            ]
            case .pergelangan_tangan: [
                StepProcedureFractures("Gunakan kain atau perban untuk menopang pergelangan tangan"),
                StepProcedureFractures("Kompres es yang terbungkus dengan kain untuk mengurangi bengkak"),
            ]
            case .lengan: [
                StepProcedureFractures("Lilitkan perban untuk membalut lengan sebagai penyangga awal"),
                StepProcedureFractures("Gunakan kain segitiga untuk menopang lengan ke dada"),
            ]
        }

        
        rawListProcedure.append(contentsOf: [ //2 prosedur teralhir teksnya selalu sama
            StepProcedureFractures("Periksa secara berkala bila ada pembengkakan lain, kesemutan, atau pucat"),
            StepProcedureFractures("Hubungi Eka Hospital","stepLast_patah_tulang")
        ]) //karena apapun patah tulangnya, step terakhir selalu sama
        return rawListProcedure
    }
}
