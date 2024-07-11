import SwiftUI

struct SideMenu: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 6) {
                Text("Fazal Quadri")
                    .font((.subheadline))
                    .foregroundColor(.white)
                
                Text("test@gmail.com")
                    .font(.footnote)
                    .tint(.gray)
            }
            
        }
    }
}

#Preview {
    SideMenu()
}
