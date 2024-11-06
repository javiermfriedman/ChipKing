import SwiftUI

struct newgameView: View {
    @ObservedObject var gameModel: Series
    @State private var showForm = false
    @State private var showArrow = false
    @State var showDeleteGameView = false
    @State var currPastGame: pastGame?
    var body: some View {
        ZStack {
            Image("background-cloth")
                .resizable()
                .ignoresSafeArea()
            
            if gameModel.playerArray.isEmpty {
                ZStack {
                    Button {
                        showArrow = true
                    } label: {
                        Text("Add players to series in order to add a new game")
                            .foregroundStyle(.black)
                    }
                    
                    if showArrow {
                        VStack {
                            Spacer()
                            Image(systemName: "arrow.down")
                                .resizable()
                                .foregroundStyle(.black)
                                .frame(width: 70, height: 100)
                                .padding()
                        }
                    }
                }
            } else {
                ScrollView {
                    ZStack {
                        VStack(alignment: .center) {
                            Image("RedFabric")
                                .resizable()
                                .frame(height: 160)
                                .ignoresSafeArea()
                            
                            Rectangle()
                                .fill(Color.black) // Line color
                                .frame(height: 6)
                                .padding(.top, -8)
                            
                            Spacer()
                        }
                        
                        Text(gameModel.name)
                            .font(.largeTitle)
                            .bold()
                            .textCase(.uppercase)
                            .multilineTextAlignment(.center)  // Center-aligns the text
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    VStack {
                        Button {
                            showForm.toggle()
                        } label: {
                            ZStack {
                                Image("ferdaBackground")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 300, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                Text("ADD NEW GAME")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.black)
                                    .background(Color.brown)
                            }
                        }
                    }
                    
                    ForEach(gameModel.pastGamesArray.sorted { $0.date > $1.date }) { game in
                        PastGameCard(gameInfo: game, deleteIsShown: $showDeleteGameView)
                            .padding()
                            .simultaneousGesture(
                                        LongPressGesture().onEnded { _ in
                                            print("long press tapped")
                                            currPastGame = game
                                            showDeleteGameView = true
                                        }
                                    )
                         
                            
                    }
                }
                .ignoresSafeArea()
                .padding(.bottom, 40)

            }
            
            if gameModel.isSavingGames {
                VStack {
                    HStack {
                        Text("Saving game, don't exit app ")
                        ProgressView()
                            .foregroundStyle(.black)
                            
                    }
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Spacer()
                }
                .padding(.top, 50)
            }
            
            if showDeleteGameView {
                deleteGameView(gameModel: gameModel, showView: $showDeleteGameView, gameInfo: currPastGame!)
            }
        }
        .fullScreenCover(isPresented: $showForm) {
            newGameForm(showView: $showForm, gameModel: gameModel)
                .interactiveDismissDisabled()
        }
        .onAppear(perform: {
            showArrow = false
        })
    }
}

#Preview {
    newgameView(gameModel: Series(input: "dad"))
}
