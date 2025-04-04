//
//  Common_Function.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 30/03/25.
//

import SwiftUI

//jika support telpon maka true
func callPhoneNumber(_  phoneNumber: String)->Bool {
    if let url = URL(string: "tel://\(phoneNumber )"),
        UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            return true
        }
    return false
}


