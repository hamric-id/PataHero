//
//  Shortcut_Intent.swift
//  PataHero
//
//  Created by Muhammad Hamzah Robbani on 14/05/25.
//

import AppIntents
import SwiftUI


struct SayHelloIntent: AppIntent {
//    static var title: LocalizedStringResource = "Say Hello"
//    static var description = IntentDescription("Say hello through the app.")
//    
    static var title: LocalizedStringResource = LocalizedStringResource("Test123")//nama widget di homescreen
    static var opensAppWhenRun: Bool = false//{ true }
    
//    @Parameter(title: "Screen Name")
//    var screenName: String


    func perform() async throws -> some IntentResult {
        print("Hello from AppIntent!")
        
        UserDefaults.standard.set("procedure;lengan", forKey: LocalDataKey.Shortcut_ScreenRequest.name())
        return .result(value: true)//value: "Opening screen: \(screenName)")
    }
}

struct OpenTimeEfficientIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Opens the app conditionally"
    static var openAppWhenRun: Bool = true


//    @MainActor
    func perform() async throws -> some IntentResult{// & ProvidesDialog {
        //at this point you can decide whether the app should be brought to the foreground or not
//        UserDefaults.standard.set("procedure;lengan", forKey: LocalDataKey.Shortcut_ScreenRequest.name())
        // Stop performing the app intent and ask the user to continue to open the app in the foreground
//        throw needsToContinueInForegroundError()
//        UserDefaults.standard.set("procedure;lengan", forKey: LocalDataKey.Shortcut_ScreenRequest.name())
        // You can customize the dialog and/or provide a closure to do something in your app after it's opened
//        throw needsToContinueInForegroundError("."){//("Silahkan Lanjutkan aplikasi") {
            UserDefaults.standard.set("procedure;lengan", forKey: LocalDataKey.Shortcut_ScreenRequest.name())
            UserDefaults.standard.synchronize()
            //UIApplication.shared.open(URL(string: "PataHero://deeplinktocontent")!)
//        }

        // Or you could ask the user to continue performing the intent in the foreground - if they cancel the intent stops, if they continue the intent execution resumes with the app open
        // This API also accepts an optional dialog and continuation closure
//        try await requestToContinueInForeground()
        return .result()//dialog: "I opened the app.")
    }

}

struct ShowProsedurLenganIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Prosedur Lengan"

    static var description = IntentDescription("Opens the app to the Prosedur Lengan view.")

    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        // Save a flag to navigate inside SwiftUI
        UserDefaults.standard.set(true, forKey: LocalDataKey.Shortcut_ScreenRequest.name())
        return .result()
    }
}


struct AppIntentShortcutProvider: AppShortcutsProvider {
    
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
//        AppShortcut(intent: SayHelloIntent(),
//                    phrases: ["Test789 in \(.applicationName)"]
//                    ,shortTitle: "Test456", systemImageName: "cup.and.saucer.fill") //test456 adalah nama shroctcut
//        AppShortcut(intent: OpenTimeEfficientIntent(),
//                    phrases: ["cobaBuka in \(.applicationName)"]
//                    ,shortTitle: "cobaBuka", systemImageName: "cup.and.saucer.fill") //test456 adalah nama shroctcut
        AppShortcut(
                    intent: ShowProsedurLenganIntent(),
                    phrases: [
                        "Procedure Thumb in Square",
                        "Tampilkan prosedur lengan",
                        "Buka prosedur lengan"
                    ],
                    shortTitle: "Prosedur jari",
                    systemImageName: "hand.raised"
                )
//        AppShortcut(intent: OrderCoffee(),
//                    phrases: ["Order coffee in \(.applicationName)"]
//                    ,shortTitle: "Order Coffee", systemImageName: "cup.and.saucer.fill")
        
//        AppShortcut(intent: OrderCappuccino(),
//                    phrases: ["Order a cappuccino in \(.applicationName)"]
//                    ,shortTitle: "Order Cappuccino", systemImageName: "cup.and.saucer.fill")
//        
//        AppShortcut(intent: YourOwnAction(),
//                    phrases: ["My Own Action in \(.applicationName)"]
//                    ,shortTitle: "Own Action", systemImageName: "heart.fill")
        
    }
    
}


// MARK: -- Step 1: Create Your App Intent Here
//widget supaya bisa melakukan fungsi didalam app tanpa membuka app
struct OrderCoffee: AppIntent {
    
//    @Parameter(title: "Coffee Type") var coffeeType: CoffeeType //pertanyaan pertama
    @Parameter(title: "Quantity") var quantity: Int //pertanyaan kedua
    @Parameter(title: "Your Name") var name: String //pertanyaan ketiga
    
    static var title: LocalizedStringResource = LocalizedStringResource("Order Coffee")//nama widget di homescreen
    
    func perform() async throws -> some IntentResult {
//        print("Selected Coffee Type: \(coffeeType)")
//        OrderViewModel.shared.addOrder(name: name, coffeeType: coffeeType.rawValue.capitalized, quantity: quantity)
//        print(OrderViewModel.shared.orderList)
        return .result()
    }
}

//struct ProcedureFractures_Intent: AppIntent {
//    
////    @Parameter(title: "Step Ke") var stepTo: UInt8
//    
////    static var title: LocalizedStringResource = LocalizedStringResource("Len")//nama widget di homescree
//    
//    var title: LocalizedStringResource// = LocalizedStringResource("Len")//nama widget di homescree
//    
//    init(_ locationFractures:LocationFractures) {
//        self.title = LocalizedStringResource("Prosedur \(locationFractures.name())")
//    }
//    
//    func perform() async throws -> some IntentResult {
////        print("Selected Coffee Type: \(stepTo)")
////        OrderViewModel.shared.addOrder(name: name, coffeeType: coffeeType.rawValue.capitalized, quantity: quantity)
////        print(OrderViewModel.shared.orderList)
//        return .result()
//    }
//}
