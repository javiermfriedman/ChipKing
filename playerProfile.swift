import SwiftUI

struct playerProfile: View {
    @ObservedObject var gameModel: Series
    @Binding var player: Player?
    @State var widthOfGraph: CGFloat = 300
    @State var showAlert = false
    @Binding var showView: Bool
    @State var showEditPage = false
    
    private func getDollar(amount: Float) -> String {
        let formattedAmount = String(format: "%.2f", abs(amount))
        
        if amount < 0 {
            return "-$\(formattedAmount)"
        } else {
            return "$\(formattedAmount)"
        }
    }
    
    var body: some View {
        ZStack {
            Image("background-plain")
                .resizable()
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    // Convert Data to UIImage
                    HStack{
                        Spacer()
                        Button{
                            showEditPage = true
                        }label: {
                            Text("edit")
                                .foregroundStyle(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .background(Color.black.opacity(0.6))
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 4)))
                        }
                    }
                    .padding()
                    Image(uiImage: UIImage(data: player?.playerImage ?? Data()) ?? UIImage(named: "defaultProfile")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 210, height: 210)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 4))
                    
                    Text(player?.name ?? "Unknown Player")
                        .font(.largeTitle)
                        .bold()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        statLine(caption: "GAMES PLAYED", stat: String(player?.gameStatsArray.count ?? 0))
                        statLine(caption: "NUMBER OF BUSTS", stat: String(player?.getNumBusts() ?? 0))
                        statLine(caption: "NET RETURN", stat: getDollar(amount: player?.getNetReturn() ?? 0))
                        statLine(caption: "NET BUY IN", stat: getDollar(amount: player?.getNetBuyIn() ?? 0))
                        
                        let RPG = getDollar(amount: player?.getAvgReturn() ?? 0)
                        statLine(caption: "AVERAGE RETURN PER GAME", stat: RPG == "$nan" ? "$0.00" : RPG)
                        
                        let RPD = getDollar(amount: player?.getRPB() ?? 0)
                        statLine(caption: "AVERAGE RETURN PER DOLLAR", stat: RPD == "$nan" ? "$0.00" : RPD)
                    }
                    .padding()
                    
                    if !(player?.gameStatsArray.isEmpty ?? true) {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            BLOCKCHART(player: player!)
                                .frame(width: widthOfGraph, height: 300) // Adjust width as needed
                                .padding()
                        }
                        
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
//                            Rectangle()
//                                .fill(.black)
//                                .frame(height: 2)
//                                .frame(width: widthOfGraph)
                            
                            EaringsOverTimeChart(player: player!)
                                .frame(width: widthOfGraph, height: 300)
                                .padding()
                        }
                                        
                        
 
                        
                        Rectangle()
                            .fill(.black)
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                        gamesScroll(player: player!)
                            .padding()
                    }
                    
                    Button {
                        showAlert = true
                    } label: {
                        HStack(spacing: 10){
                            Text("Remove Player")
                            Image(systemName: "trash.fill")
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    }
                }
            }
            .onAppear(perform: {
                getWidth()
            })
            .alert("Remove Player", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Remove", role: .destructive) {
                    if let player = player {
                        if let index = gameModel.playerArray.firstIndex(where: { $0.id == player.id }) {
                            gameModel.playerArray.remove(at: index)
                        }
                        showView = false
                    }
                }
            } message: {
                Text("Are you sure you want to remove this player?")
            }
            
            if showEditPage {
                EditPage(player: $player, showView: $showEditPage, game: gameModel)
                    .onDisappear(perform: {
                        
                        refreshPlayerData()
                        
                        
                    })
            }
        }
    }
    
    private func getWidth(){
        let numDates = player?.gameStatsArray.count ?? 1
        let width = 50 * numDates + 100
        widthOfGraph = CGFloat(width)
    }
    
    // Function to refresh player data
    private func refreshPlayerData() {
        DispatchQueue.main.async {
            // Force a refresh by reassigning the player
            if let updatedPlayer = gameModel.playerArray.first(where: { $0.id == player?.id }) {
                player = updatedPlayer
            }
        }
    }
}

struct statLine: View {
    let caption: String
    var stat: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(caption)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Text(stat)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            Rectangle()
                .fill(.black)
                .frame(height: 2)
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 5)
    }
}
