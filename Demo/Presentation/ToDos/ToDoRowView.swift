import SwiftUI

struct ToDoRowView: View {
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
    ToDoRowView(toDo: TestData.testToDo)
        .previewLayout(.sizeThatFits)
}
