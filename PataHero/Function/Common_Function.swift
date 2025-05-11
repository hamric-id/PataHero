//
//  Common_Function.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 30/03/25.
//

import SwiftUI

//jika support telpon maka true

func screenSize()->CGRect{
    #if os(watchOS)
        return WKInterfaceDevice.current().screenBounds
    #else
        return UIScreen.main.bounds
    #endif
}

#if !os(watchOS)
extension UIApplication {
    var keyWindow: UIWindow? {
        // For iOS 13 and later
        return connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first(where: \.isKeyWindow)
    }
}

func callPhoneNumber(_  phoneNumber: String)->Bool {
    if let url = URL(string: "tel://\(phoneNumber )"),
        UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            return true
        }
    return false
}
#endif

func isDynamicIslandDevice() -> Bool { //untuk deteksi apakah layar dynamic island atau tidak
    #if os(iOS)
        guard UIDevice.current.userInterfaceIdiom == .phone,
              let topInset = UIApplication.shared.keyWindow?.safeAreaInsets.top else {
            return false
        }
        return topInset >= 59
    #else
        return false
    #endif
}


