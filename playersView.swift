import SwiftUI

struct playersView: View {
    @ObservedObject var gameModel: Series
    @State var showNewPlayerView = false
    @State var showProfile = false
    @State var currPlayer: Player?
    
    private let columns = [
        GridItem(.adaptive(minimum: 150)) // Ensure minimum size is appropriate
    ]
    
    var body: some View {
        ZStack {
            //background
            Image("background-wood-cartoon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            //scroll view
            
            if gameModel.isFetchingPlayers {
                HStack{
                    Text("fetching player data ")
                    ProgressView()
                    
                }
            } else {
                
                VStack {
                    
                    if gameModel.isSavingPlayers {
                        HStack{
                            Text("saving players, dont exit app ")
                            ProgressView()
                                .foregroundStyle(.black)
                                .padding()
                        }
                        
                    }
                    
                    
                    Spacer()
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(gameModel.playerArray) { player in
                                playerCard(player: player)
                                    .padding(.bottom, 50)
                                    .onTapGesture {
                                        DispatchQueue.main.async {
                                            
                                            currPlayer = player
                                            showProfile = true
                                        }
                                    }
                            }
                            newPlayerButton(showNewPlayerView: $showNewPlayerView)
                                .padding(.bottom, 50)
                        }
                        .padding()
                    }
                    .padding(.bottom, 30)
                }
                .padding(.top, 100)
            }
            
            
        }
        .sheet(isPresented: $showNewPlayerView, content: {
            newPlayerSheet(game: gameModel, showView: $showNewPlayerView)
                .presentationDetents([.medium])
        })
        .sheet(isPresented: $showProfile) {
            playerProfile(gameModel: gameModel, player: $currPlayer, showView: $showProfile)
        }
    }
}

#Preview {
    playersView(gameModel: Series(input: "hello"))
}
