import SwiftUI

struct PostItemView: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            post.title.map {
                Text($0)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer().frame(height: 10)
            
            post.body.map {
                Text($0)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .foregroundColor(.black)
        .padding()
    }
}

#Preview {
    PostItemView(post: TestData.testPost)
        .previewLayout(.sizeThatFits)
}
