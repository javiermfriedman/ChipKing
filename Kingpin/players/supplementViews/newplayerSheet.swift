import SwiftUI
import PhotosUI

struct newPlayerSheet: View {
    @ObservedObject var game: Series
    @Binding var showView: Bool
    @State private var playerName = ""
    @State private var avatarImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var showButton = false
    @State private var isAddingPlayer = false // Track whether the player is being added
    @State private var errorMessage: String? // State for managing error messages
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            Text("Add profile picutre and name")
                .font(.caption)
            
            
            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                Image(uiImage: avatarImage ?? UIImage(named: "defaultProfile")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }
            
            
            
            TextField("Name", text: $playerName)
                .font(.title)
                .padding()
                .onSubmit {
                    showButton = !playerName.isEmpty
                }
            
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .bold()
            }
            
            if showButton {
                Button {
                    // Reset error and loading states
                    errorMessage = nil
                    isAddingPlayer = true
                    
                    // Check if a player with the same name already exists
                    if game.playerArray.contains(where: { $0.name.lowercased() == playerName.lowercased() }) {
                        errorMessage = "Player with this name already exists."
                        isAddingPlayer = false
                        return
                    }
                    
                    // Perform image compression and player addition in a background thread
                    DispatchQueue.global(qos: .userInitiated).async {
                        let compressedImageData: Data?
                        
                        if let selectedImage = avatarImage {
                            // Compress the image with very low quality
                            compressedImageData = selectedImage.jpegData(compressionQuality: 0.01) // Very low quality
                        } else {
                            // Provide a default image if no image is selected
                            let defaultImage = UIImage(named: "defaultProfile")
                            compressedImageData = defaultImage?.jpegData(compressionQuality: 0.01) // Very low quality
                        }
                        
                        // Convert compressed image data back to UIImage
                        
                        

                        let newPlayer = Player(name: playerName, image: compressedImageData)
                        
                        DispatchQueue.main.async {
                            game.addPlayer(player: newPlayer)
                            showView.toggle()
                            isAddingPlayer = false
                        }
                    }
                } label: {
                    if isAddingPlayer {
                        ProgressView() // Show a loading indicator
                    } else {
                        Text("Add Player")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .disabled(isAddingPlayer) // Disable button while adding player
                .opacity(isAddingPlayer ? 0.5 : 1.0) // Make button look disabled
            }
            
            Spacer()
        }
        .padding(30)
        .onChange(of: photoPickerItem) { _, _ in
            Task {
                if let photoPickerItem,
                   let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        avatarImage = image
                    }
                }
                photoPickerItem = nil
            }
        }
    }
}
