import SwiftUI

struct ContentWrappingTextEditor: View {
    @Binding var text: String
    var isEditable = true
    
    var body: some View {
        ZStack(alignment: .top) {
            if isEditable {
                TextEditor(text: $text)
                    .frame(minHeight: 25)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1))
                
                Text(text)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .opacity(0)
                    .layoutPriority(1)
            } else {
                Text(text)
            }
        }
    }
}

#Preview {
    let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lectus vestibulum mattis ullamcorper velit. Nisl condimentum id venenatis a condimentum vitae. Pretium lectus quam id leo in vitae turpis. Dignissim cras tincidunt lobortis feugiat. Est ultricies integer quis auctor elit sed. Vestibulum lorem sed risus ultricies tristique nulla aliquet enim tortor. Ullamcorper eget nulla facilisi etiam dignissim diam quis. Sollicitudin nibh sit amet commodo nulla facilisi. Tincidunt ornare massa eget egestas purus viverra accumsan in. Ac turpis egestas sed tempus urna et pharetra pharetra massa. In vitae turpis massa sed elementum tempus egestas. Augue mauris augue neque gravida. Eget nullam non nisi est. Adipiscing elit duis tristique sollicitudin nibh sit."
    ContentWrappingTextEditor(text: .constant(text))
}
