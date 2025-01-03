
//
//  Dex3Widget.swift
//  Dex3Widget
//
//  Created by Paul F on 07/11/24.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    
    var randomPokemon :Pokemon {
            let context = PersistenceController.shared.container.viewContext

            let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
            
            var results: [Pokemon] = []
            do {
                results = try context.fetch(fetchRequest)
            } catch {
                print("Couln't fetch: \(error)")
            }
            
            if let randomPokemon = results.randomElement() {
                return randomPokemon
            }
            
            return results.randomElement()!
        }
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀",pokemon: SamplePokemon.samplePokemon)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀",pokemon: randomPokemon)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀",pokemon: randomPokemon)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let pokemon: Pokemon
}

struct Dex3WidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetSize
    var entry: Provider.Entry

    var body: some View {
        switch widgetSize {
        case .systemSmall:
            WidgetPokemon(widgetSize: .small)
                .environmentObject(entry.pokemon)
        case .systemMedium:
            WidgetPokemon(widgetSize: .medium)
                .environmentObject(entry.pokemon)
        case .systemLarge:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)
        default:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)
        }
    }
}

struct Dex3Widget: Widget {
    let kind: String = "Dex3Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Dex3WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Dex3WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

/*#Preview(as: .systemSmall) {
    Dex3Widget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀Juan Pablo", pokemon: <#Pokemon#>)
    SimpleEntry(date: .now, emoji: "🤩")
}*/


