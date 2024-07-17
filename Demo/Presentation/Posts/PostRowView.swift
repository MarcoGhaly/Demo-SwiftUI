import SwiftUI

struct PostRowView: View {
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

struct PostRowView_Previews: PreviewProvider {
    static var previews: some View {
        return PostRowView(post: testPost)
            .previewLayout(.sizeThatFits)
    }
}
