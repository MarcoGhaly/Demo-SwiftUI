import SwiftUI

struct CommentRowView: View {
    var comment: Comment
    
    var body: some View {
        let info = [("Name:", comment.name),
                    ("Email:", comment.email)]
        
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

#Preview {
    CommentRowView(comment: TestData.testComment)
        .previewLayout(.sizeThatFits)
}
