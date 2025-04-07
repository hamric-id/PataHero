import SwiftUI

enum AppScreen {
    case contentView
    case ProcedureFracture_Screen
}

var locationFractures_ProcedureFracture_Screen: LocationFractures? = nil

// Richard
@main
struct PataHeroApp: App {
    @State private var currentScreen: AppScreen = .contentView
    
    var body: some Scene {
        WindowGroup {
            
            switch currentScreen{
                case .contentView: ContentView($currentScreen)
                case .ProcedureFracture_Screen:
                    ProcedureFractureStep_Screen($currentScreen,locationFractures_ProcedureFracture_Screen!)
            }
        }
    }
}
