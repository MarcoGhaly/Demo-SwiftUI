import SwiftUI

typealias Entry = (label: String, keyboardType: UIKeyboardType, value: String, keyPath: WritableKeyPath<User, String?>)

struct AddUserView: View {
    @Binding var isPresented: Bool
    var onConfirm: (User) -> Void
    
    @State private var entries: [Entry] = [("Username", UIKeyboardType.default, \User.username),
                                           ("Name", UIKeyboardType.default, \User.name),
                                           ("Email", UIKeyboardType.emailAddress, \User.email),
                                           ("Phone", UIKeyboardType.phonePad, \User.phone),
                                           ("Website", UIKeyboardType.URL, \User.website)]
        .map { Entry(label: $0.0, keyboardType: $0.1, value: "", keyPath: $0.2) }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Add New User")
                    .font(.title)
                
                ForEach(entries.indices) { index in
                    EntryView(title: entries[index].label, placeHolder: entries[index].label, keyboardType: entries[index].keyboardType, text: $entries[index].value)
                    Divider()
                }
                
                Button(action: {
                    var user = User()
                    entries.forEach { entry in
                        user[keyPath: entry.keyPath] = entry.value
                    }
                    onConfirm(user)
                }, label: {
                    Text("Add User")
                        .font(.title)
                })
                .disabled(entries.contains { $0.value.isEmpty })
            }
            .padding(20)
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView(isPresented: .constant(true), onConfirm: { _ in })
            .previewLayout(.sizeThatFits)
    }
}
