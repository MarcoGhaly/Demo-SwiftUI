import SwiftUI

struct AddPostView: View {
    private let buttonsHeight: CGFloat = 50
    
    @Binding var isPresented: Bool
    var widthRatio: CGFloat = 0.9
    var onConfirm: (Post) -> Void
    
    @State private var title = ""
    @State private var message = ""
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
            }
            
            if isPresented {
                GeometryReader { geometry in
                    VStack(spacing: .zero) {
                        Text("Add New Post")
                            .font(.title)
                        
                        EntryView(title: "Title:", placeHolder: "Title", text: $title)
                            .padding(.vertical, 25)
                        
                        Divider()
                        
                        EntryView(title: "Body:", placeHolder: "Body", text: $message)
                            .padding(.vertical, 25)
                        
                        Divider()
                        
                        Button("Add Post") {
                            let post = Post(title: title, body: message)
                            onConfirm(post)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonsHeight)
                        .disabled(title.isEmpty || message.isEmpty)
                        
                        Divider()
                        
                        Button("Cancel") {
                            withAnimation {
                                isPresented = false
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: buttonsHeight)
                    }
                    .padding()
                    .cardify()
                    .shadow(radius: 1)
                    .frame(width: geometry.size.width * widthRatio)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: isPresented) {
            if $0 { clearFields() }
        }
    }
    
    private func clearFields() {
        title = ""
        message = ""
    }
}

#Preview {
    AddPostView(isPresented: .constant(true), onConfirm: { _ in })
}
