import SwiftUI

struct ToDoItemView: View {
    var toDo: ToDo
    
    var body: some View {
        HStack {
            toDo.title.map {
                Text($0)
                    .font(.headline)
            }
            
            Spacer()
            
            if toDo.completed ?? false {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

#Preview {
    ToDoItemView(toDo: TestData.testToDo)
        .previewLayout(.sizeThatFits)
}
