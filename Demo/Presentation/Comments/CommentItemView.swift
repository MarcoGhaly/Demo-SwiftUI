import SwiftUI

struct CommentItemView: View {
    var comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            InfoView(info: info)
            
            comment.body.map {
                Text($0)
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

private extension CommentItemView {
    var info: [(label: String, value: String?)] {
        [
            ("Name:", comment.name),
            ("Email:", comment.email)
        ]
    }
}

#Preview {
    CommentItemView(comment: TestData.testComment)
}
