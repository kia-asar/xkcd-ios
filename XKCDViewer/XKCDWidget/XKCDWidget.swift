//
//  XKCDWidget.swift
//  XKCDWidget
//
//  Created by Kiarash Asar on 6/2/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), randomNumber: 1234)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), randomNumber: Int.random(in: 1...3000))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of 5 entries starting from now, with random numbers
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let randomNumber = Int.random(in: 1...3000)
            let entry = SimpleEntry(date: entryDate, randomNumber: randomNumber)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let randomNumber: Int
}

struct XKCDWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 12) {
                Image(systemName: "number.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                Text("Random XKCD")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("#\(entry.randomNumber)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                
                Text("Tap to refresh")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct XKCDWidget: Widget {
    let kind: String = "XKCDWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                XKCDWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                XKCDWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Random XKCD")
        .description("Shows a random XKCD comic number between 1 and 3000.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    XKCDWidget()
} timeline: {
    SimpleEntry(date: .now, randomNumber: 1542)
    SimpleEntry(date: .now, randomNumber: 2897)
}
