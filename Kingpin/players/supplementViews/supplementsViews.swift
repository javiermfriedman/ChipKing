import SwiftUI

import SwiftUI

struct playerCard: View {
    @ObservedObject var player: Player
    
    var body: some View {
        VStack {
            // Display the player's image
            if let imageData = player.playerImage, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill() // Ensure image fills the frame
                    .clipShape(Circle()) // Optional: for circular images
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2)) // Optional: for border
                    .frame(width: 150, height: 150) // Ensure consistent size
            } else {
                // Placeholder image if playerImage is nil
                Color.gray
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .frame(width: 150, height: 150) // Ensure consistent size
            }
            
            // Display the player's name
            Text(player.name)
                .font(.headline)
                .padding(.top, 8)
        }
        .padding() //
        .background(Color.brown)
        .frame(width: 150, height: 200)
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

struct newPlayerButton: View {
    @Binding var showNewPlayerView: Bool
    
    var body: some View {
        VStack{
            Button {
                showNewPlayerView = true
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .frame(width: 150, height: 150)
            }
            .background(Color.clear)
            
            Text("New Player")
                .font(.headline)
                .padding(.top, 8)
            
        }
        .padding() // Optional: Adjust or remove if needed
        .background(Color.brown)
        .frame(width: 150, height: 200) // Ensure card has consistent size
        .cornerRadius(8)
        .shadow(radius: 5)
    
    }
}

