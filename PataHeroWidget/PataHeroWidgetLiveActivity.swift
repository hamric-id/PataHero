//
//  PataHeroWidgetLiveActivity.swift
//  PataHeroWidget
//
//  Created by Muhammad Hamzah Robbani on 15/05/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PataHeroWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PataHeroWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PataHeroWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PataHeroWidgetAttributes {
    fileprivate static var preview: PataHeroWidgetAttributes {
        PataHeroWidgetAttributes(name: "World")
    }
}

extension PataHeroWidgetAttributes.ContentState {
    fileprivate static var smiley: PataHeroWidgetAttributes.ContentState {
        PataHeroWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PataHeroWidgetAttributes.ContentState {
         PataHeroWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PataHeroWidgetAttributes.preview) {
   PataHeroWidgetLiveActivity()
} contentStates: {
    PataHeroWidgetAttributes.ContentState.smiley
    PataHeroWidgetAttributes.ContentState.starEyes
}
