import SwiftUI

// Updated enum for categories
enum Category: String, CaseIterable {
    case school = "🏫"
    case work = "💼"
    case home = "🏠"
    case misc = "🔍"

    var title: String {
        switch self {
        case .school:
            return "School"
        case .work:
            return "Work"
        case .home:
            return "Home"
        case .misc:
            return "Miscellaneous"
        }
    }
}

// Reminder struct
struct Reminder: Identifiable {
    let id = UUID()
    var title: String
}

// Main ContentView
struct ContentView: View {
    @State private var selection: Category = .school
    @State private var reminders: [Category: [Reminder]] = [
        .school: [],
        .work: [],
        .home: [],
        .misc: []
    ]
    @State private var newReminderTitle: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text(selection.rawValue)
                    .font(.system(size: 150))

                Picker("Select Category", selection: $selection) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.title).tag(category)
                    }
                }
                .pickerStyle(.segmented)

                TextField("New Reminder", text: $newReminderTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Add Reminder") {
                    addReminder()
                    newReminderTitle = "" // Clear the text field
                }
                .padding()

                List {
                    ForEach(reminders[selection] ?? [], id: \.id) { reminder in
                        Text(reminder.title)
                    }
                    .onDelete(perform: deleteReminder)
                }
            }
            // .navigationTitle("Emoji Reminders") // Removed this line
            .padding()
        }
    }

    private func addReminder() {
        guard !newReminderTitle.isEmpty else { return }
        let newReminder = Reminder(title: newReminderTitle)
        reminders[selection]?.append(newReminder)
    }

    private func deleteReminder(at offsets: IndexSet) {
        reminders[selection]?.remove(atOffsets: offsets)
    }
}

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
