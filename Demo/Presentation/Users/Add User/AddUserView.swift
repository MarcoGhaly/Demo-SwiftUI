import SwiftUI

typealias Entry = (
    label: String,
    keyboardType: UIKeyboardType,
    autoCapitalization: TextInputAutocapitalization,
    value: String,
    keyPath: WritableKeyPath<User, String?>
)

struct AddUserView: View {
    @Binding var isPresented: Bool
    var onConfirm: (User) -> Void
    
    @State private var entries: [Entry] = [
        ("Username", UIKeyboardType.default, TextInputAutocapitalization.never, \User.username),
        ("Name", UIKeyboardType.default, TextInputAutocapitalization.words, \User.name),
        ("Email", UIKeyboardType.emailAddress, TextInputAutocapitalization.never, \User.email),
        ("Phone", UIKeyboardType.phonePad, TextInputAutocapitalization.never, \User.phone),
        ("Website", UIKeyboardType.URL, TextInputAutocapitalization.never, \User.website)
    ].map {
        Entry(label: $0.0, keyboardType: $0.1, autoCapitalization: $0.2, value: "", keyPath: $0.3)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Add New User")
                    .font(.title)
                
                ForEach(entries.indices, id: \.self) { index in
                    EntryView(
                        title: entries[index].label,
                        placeHolder: entries[index].label,
                        keyboardType: entries[index].keyboardType,
                        autoCapitalization: entries[index].autoCapitalization,
                        text: $entries[index].value
                    )
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

#Preview {
    AddUserView(isPresented: .constant(true), onConfirm: { _ in })
        .previewLayout(.sizeThatFits)
}
