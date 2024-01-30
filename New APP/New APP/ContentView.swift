import SwiftUI

struct CategoryModel: Identifiable {
    var id = UUID()
    var category: Category
    var title: String
    var emoji: String
}

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

struct Reminder: Identifiable {
    let id = UUID()
    var title: String
}

struct CategoryEditView: View {
    @Binding var categories: [CategoryModel]
    @Binding var reminders: [Category: [Reminder]]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                ForEach(categories.indices, id: \.self) { index in
                    HStack {
                        TextField("Category Name", text: $categories[index].title)
                        Spacer()
                        TextField("Emoji", text: $categories[index].emoji)
                    }
                }
            }
            .navigationTitle("Edit Categories")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ContentView: View {
    @State private var selection: Category = .school
    @State private var reminders: [Category: [Reminder]] = [
        .school: [],
        .work: [],
        .home: [],
        .misc: []
    ]
    @State private var newReminderTitle: String = ""
    @State private var isCategoryEditSheetPresented = false

    @State private var categories: [CategoryModel] = [
        CategoryModel(category: .school, title: "School", emoji: "🏫"),
        CategoryModel(category: .work, title: "Work", emoji: "💼"),
        CategoryModel(category: .home, title: "Home", emoji: "🏠"),
        CategoryModel(category: .misc, title: "Miscellaneous", emoji: "🔍")
    ]

    var body: some View {
        NavigationView {
            VStack {
               
                Text(getEmoji(for: selection))
                    .font(.system(size: 150))

                Picker("Select Category", selection: $selection) {
                    ForEach(categories, id: \.id) { category in
                        Text(category.title).tag(category.category)
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
            .navigationBarItems(trailing: Button("Edit Categories") {
                isCategoryEditSheetPresented.toggle()
            })
            .sheet(isPresented: $isCategoryEditSheetPresented) {
                CategoryEditView(categories: $categories, reminders: $reminders)
            }
            .padding()
        }
    }

    private func addReminder() {
        guard !newReminderTitle.isEmpty else { return }
        let newReminder = Reminder(title: newReminderTitle)
        reminders[selection, default: []].append(newReminder)
    }

    private func deleteReminder(at offsets: IndexSet) {
        reminders[selection]?.remove(atOffsets: offsets)
    }

    
    private func getEmoji(for category: Category) -> String {
        categories.first { $0.category == category }?.emoji ?? ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
