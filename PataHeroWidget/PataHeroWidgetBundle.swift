//
//  PataHeroWidgetBundle.swift
//  PataHeroWidget
//
//  Created by Muhammad Hamzah Robbani on 15/05/25.
//

import WidgetKit
import SwiftUI

@main
struct PataHeroWidgetBundle: WidgetBundle {
    var body: some Widget {
        PataHeroWidget()
        PataHeroWidgetControl()
        PataHeroWidgetLiveActivity()
    }
}
