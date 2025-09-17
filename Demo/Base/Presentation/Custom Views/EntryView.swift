import SwiftUI

struct EntryView: View {
    var title: String
    var placeHolder: String
    var keyboardType: UIKeyboardType = .default
    var autoCapitalization: TextInputAutocapitalization = .never
    var autoCorrectEnabled = false
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.body)
            
            TextField(placeHolder, text: _text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autoCapitalization)
                .autocorrectionDisabled(!autoCorrectEnabled)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}

#Preview {
    let entries = ["Name", "Email", "Phone", "Address"]
    ForEach(entries, id: \.self) { entry in
        EntryView(title: "\(entry):", placeHolder: entry, text: .constant(""))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
