import SwiftUI
import PhotosUI

struct EditPage: View {
    @Binding var player: Player?
    @Binding var showView: Bool
    @ObservedObject var game: Series
    @State private var playerName = ""
    @State private var avatarImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var showButton = false
    @State private var isSavingPlayer = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // Background dimming effect with a tap to dismiss the view
            Button(action: {
                showView = false
            }) {
                Color.black.opacity(0.85)
                    .edgesIgnoringSafeArea(.all)
            }
            .buttonStyle(PlainButtonStyle()) // Remove button styling so it doesn't interfere with the appearance

            // Edit page content
            VStack(alignment: .center, spacing: 20) {
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    Image(uiImage: avatarImage ?? UIImage(data: player?.playerImage ?? Data()) ?? UIImage(named: "defaultProfile")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                }
                .padding()

                TextField("Enter name", text: $playerName)
                    .font(.title)
                    .padding()
                    .foregroundStyle(.black)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .onChange(of: playerName) { _, _ in
                        errorMessage = nil
                    }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .bold()
                }

                Button(action: savePlayer) {
                    if isSavingPlayer {
                        ProgressView()
                    } else {
                        Text("Save Changes")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .disabled(isSavingPlayer)
                .opacity(isSavingPlayer ? 0.5 : 1.0)

                Spacer()
            }
            .padding(30)
            .frame(width: 300, height: 400)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .onAppear {
                playerName = player?.name ?? "Enter New Name"
                avatarImage = UIImage(data: player?.playerImage ?? Data())
            }
            .onChange(of: photoPickerItem) { _, _ in
                Task {
                    if let photoPickerItem,
                       let data = try? await photoPickerItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        avatarImage = image
                    }
                    photoPickerItem = nil
                }
            }
        }
    }

    private func savePlayer() {
        isSavingPlayer = true
        errorMessage = nil

        if game.playerArray.contains(where: { $0.name.lowercased() == playerName.lowercased() && $0.id != player?.id }) {
            errorMessage = "Player with this name already exists."
            isSavingPlayer = false
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let compressedImageData: Data?

            if let selectedImage = avatarImage {
                compressedImageData = selectedImage.jpegData(compressionQuality: 0.01)
            } else {
                compressedImageData = player?.playerImage
            }

            DispatchQueue.main.async {
                player?.playerImage = compressedImageData
                player?.name = playerName
                showView.toggle()
                game.savePlayers()
                isSavingPlayer = false
            }
        }
    }
}
