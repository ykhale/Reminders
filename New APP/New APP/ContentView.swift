import SwiftUI

// CategoryModel and Category enum remain unchanged
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
                        TextField("List Name", text: $categories[index].title)
                        Spacer()
                        TextField("Emoji", text: $categories[index].emoji)
                    }
                }
            }
            .navigationTitle("Edit Lists")
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
    @State private var newTaskTitle: String = ""
    @State private var isCategoryEditSheetPresented = false
    @State private var backgroundColor: Color = .white
    @State private var showingColorOptions = false

    @State private var categories: [CategoryModel] = [
        CategoryModel(category: .school, title: "School", emoji: "🏫"),
        CategoryModel(category: .work, title: "Work", emoji: "💼"),
        CategoryModel(category: .home, title: "Home", emoji: "🏠"),
        CategoryModel(category: .misc, title: "Miscellaneous", emoji: "🔍")
    ]

    let colorOptions: [(name: String, color: Color)] = [
        ("White", .white),
        ("Red", .red),
        ("Blue", .blue),
        ("Green", .green),
        ("Yellow", .yellow),
        ("Orange", .orange),
        ("Pink", .pink),
        ("Gray", .gray)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all) // Fill entire screen with background color

                VStack {
                    Text(getEmoji(for: selection))
                        .font(.system(size: 150))

                    Picker("Select List", selection: $selection) {
                        ForEach(categories, id: \.id) { category in
                            Text(category.title).tag(category.category)
                        }
                    }
                    .pickerStyle(.segmented)

                    TextField("New Task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Add Task") {
                        addTask()
                        newTaskTitle = "" // Clear the text field
                    }
                    .padding()

                    List {
                        ForEach(reminders[selection] ?? [], id: \.id) { reminder in
                            Text(reminder.title)
                        }
                        .onDelete(perform: deleteTask)
                    }
                }
                // .padding() // Consider removing this if you want content to extend to edges
            }
            .navigationBarItems(leading: Button(action: {
                showingColorOptions = true // Show color options
            }) {
                Image(systemName: "circle.grid.3x3.fill") // Color wheel icon
            }, trailing: Button("Edit Lists") {
                isCategoryEditSheetPresented.toggle()
            })
            .actionSheet(isPresented: $showingColorOptions) {
                actionSheet()
            }
            .sheet(isPresented: $isCategoryEditSheetPresented) {
                CategoryEditView(categories: $categories, reminders: $reminders)
            }
        }
    }

    private func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        let newTask = Reminder(title: newTaskTitle)
        reminders[selection, default: []].append(newTask)
    }

    private func deleteTask(at offsets: IndexSet) {
        reminders[selection]?.remove(atOffsets: offsets)
    }

    private func getEmoji(for category: Category) -> String {
        categories.first { $0.category == category }?.emoji ?? ""
    }

    func actionSheet() -> ActionSheet {
        ActionSheet(title: Text("Choose Background Color"), buttons: colorOptions.map { option in
            .default(Text(option.name)) {
                backgroundColor = option.color
            }
        } + [.cancel()])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
