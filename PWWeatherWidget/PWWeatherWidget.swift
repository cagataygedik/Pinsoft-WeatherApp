//
//  PWWeatherWidget.swift
//  PWWeatherWidget
//
//  Created by Celil Çağatay Gedik on 17.07.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct PWWeatherWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack(alignment: .top) {
            WeatherDescriptionStackView()
            Spacer()
            LocationStackView()
            Spacer()
            NumbersStackView()
        }
        .padding()
    }
}

struct PWWeatherWidget: Widget {
    let kind: String = "PWWeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PWWeatherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PWWeatherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemMedium) {
    PWWeatherWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

struct WeatherDescriptionStackView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("☀️").font(Font.system(size: 50))
            Spacer()
            Text("Sunny")
        }
    }
}

struct LocationStackView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Istanbul").font(Font.system(size: 25))
            Text("Turkiye").font(Font.system(size: 13))
        }
    }
}

struct NumbersStackView: View {
    var body: some View {
        VStack(alignment: .trailing) {
            Text("17°C").font(Font.system(size: 40))
            Spacer()
            HStack {
                Text("50%")
                Text("180 KM/H")
            }.font(Font.system(size: 14))
        }
    }
}
