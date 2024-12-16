import SwiftUI
import shared

struct ContentView: View {
    private let viewModel = TodoViewModel(repository: InMemoryTodoRepository())
    @StateObject private var tasksObserver: FlowObserver<[TodoTask]>
    @State private var newTaskTitle: String = ""
    
    init() {
        _tasksObserver = StateObject(wrappedValue: FlowObserver(flow: viewModel.tasks))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Add task input field
                HStack {
                    TextField("Enter new task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                // Tasks list
                List {
                    ForEach(tasksObserver.value ?? [], id: \.id) { task in
                        TodoItemView(
                            task: task,
                            onToggle: { viewModel.toggleTask(id: task.id) },
                            onDelete: { viewModel.deleteTask(id: task.id) }
                        )
                    }
                }
            }
            .navigationTitle("Todo List")
        }
    }
}

struct TodoItemView: View {
    let task: TodoTask
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            Text(task.title)
                .strikethrough(task.isCompleted)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
