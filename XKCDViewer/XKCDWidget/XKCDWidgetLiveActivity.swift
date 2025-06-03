//
//  XKCDWidgetLiveActivity.swift
//  XKCDWidget
//
//  Created by Kiarash Asar on 6/2/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct XKCDWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct XKCDWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: XKCDWidgetAttributes.self) { context in
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

extension XKCDWidgetAttributes {
    fileprivate static var preview: XKCDWidgetAttributes {
        XKCDWidgetAttributes(name: "World")
    }
}

extension XKCDWidgetAttributes.ContentState {
    fileprivate static var smiley: XKCDWidgetAttributes.ContentState {
        XKCDWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: XKCDWidgetAttributes.ContentState {
         XKCDWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: XKCDWidgetAttributes.preview) {
   XKCDWidgetLiveActivity()
} contentStates: {
    XKCDWidgetAttributes.ContentState.smiley
    XKCDWidgetAttributes.ContentState.starEyes
}
