//
//  Data_Function.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 31/03/25.
//

extension String {
    //convert string ke ContiguousArray<UInt8>   , setara chararray di kotlin, lebih hemat memory
    func ContingousArray() -> ContiguousArray<UInt8> {ContiguousArray(self.utf8)}
}

extension ContiguousArray where Element == UInt8 {
    //merubah ContiguousArray<UInt8> ke string
    func String1()->String{String(bytes: self, encoding: .utf8)!}
}

extension UInt8{
    func ContiguousArray1() -> ContiguousArray<UInt8> {ContiguousArray(String(self).utf8)}//[self])} pakai cara normal maish ngebug, jadi pakai cara string diulu
}
