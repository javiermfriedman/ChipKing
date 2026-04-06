import SwiftUI

struct newGameForm: View {
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @Binding var showView: Bool
    @ObservedObject var gameModel: Series
    @State private var date = Date()
    @State var winner: Player?
    @State var hitFinished = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    Picker("Select Chip Leader", selection: $winner) {
                        Text("No Leader").tag(nil as Player?)
                        ForEach(gameModel.playerArray) { player in
                            Text(player.name).tag(player as Player?)
                        }
                    }
                    
                    HStack {
                        Text("Picture Of Game")
                        Spacer()
                        Button {
                            self.showCamera.toggle()
                        } label: {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                    }
                } header: {
                    Text("info")
                }

                
                    ForEach(gameModel.playerArray) { player in
                        Section {
                            statViewForm(player: player, date: $date, gameModel: gameModel, hitFinished: $hitFinished)
                        } header: {
                            Text(player.name)
                        }
                    }

                
                
                Section {
                    HStack {
                        Spacer()
                        Button {
                            DispatchQueue.main.async {
                                hitFinished = true
                                showView = false
                            }
                            

                            
                            
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                let compressedImageData: Data?
                                
                                if let selectedImage = self.selectedImage {
                                    // Compress the image with very low quality
                                    compressedImageData = selectedImage.jpegData(compressionQuality: 0.001) // Very low quality
                                } else {
                                    // Provide a default image if no image is selected
                                    let defaultImage = UIImage(named: "backgroundDefaultGameView")
                                    
                                    compressedImageData = defaultImage?.jpegData(compressionQuality: 0.001) // Very low quality
                                    
                                }
                                
                                
                                
                                // Use the compressed image data directly
                                let tempPastGame = pastGame(date: date, winner: winner?.name ?? "", imgPath: compressedImageData)
                                
                                DispatchQueue.main.async {
                                    self.gameModel.addPastGame(game: tempPastGame)
                                }
                            }

                        } label: {
                            Text("FINISHED")
                        }
                        Spacer()
                    }
                } header: {
                    Text("if a player didn't play, leave their stats blank")
                }
            }
            .navigationTitle("STATS")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        showView = false
                    }
                }
            }
            .fullScreenCover(isPresented: self.$showCamera, content: {
                AccessCameraView(selectedImage: self.$selectedImage)
                    .ignoresSafeArea()
            })
        }
    }
}
