import SwiftUI

struct leaderBoardView: View {
    @ObservedObject var gameModel: Series
    @State private var selectedSortOption = SortOption.earningsPerGame // Default sorting option

    enum SortOption: String, CaseIterable, Identifiable {
        case earningsPerGame = "Total Earnings"
        case averageProfitPerGame = "Average Return per Game"
        case returnPerDollar = "Average Return per Dollar"

        var id: String { self.rawValue }
    }
    
    private func getDollar(amount: Float) -> String {
        let formattedAmount = String(format: "%.2f", abs(amount))
        
        if formattedAmount == "nan" {
            return "$0.00"
        }
        
        if amount < 0 {
            return "-$\(formattedAmount)"
        } else {
            return "$\(formattedAmount)"
        }
    }

    var sortedPlayers: [Player] {
        switch selectedSortOption {
        case .earningsPerGame:
            return gameModel.playerArray.sorted {
                $0.getNetReturn() > $1.getNetReturn()
            }
        case .averageProfitPerGame:
            return gameModel.playerArray.sorted {
                $0.getAvgReturn() > $1.getAvgReturn()
            }
        case .returnPerDollar:
            return gameModel.playerArray.sorted {
                $0.getRPB() > $1.getRPB()
            }
        }
    }

    var body: some View {
        ZStack {
            Image("background-wood-grain")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Leaderboard")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding()

                Picker("Sort by", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .background(Color.brown.opacity(0.3))
                .padding()

                List {
                    ForEach(Array(sortedPlayers.enumerated()), id: \.element.id) { index, player in
                        boardIndexView(index: index, player: player, selectedSortOption: selectedSortOption, getDollar: getDollar)
                    }
                }
            }
        }
    }
}

struct boardIndexView: View {
    let index: Int
    let player: Player
    let selectedSortOption: leaderBoardView.SortOption
    let getDollar: (Float) -> String
    
    var body: some View {
        HStack {
            Text("\(index + 1).")
                .fontWeight(.bold)
                .padding(.trailing, 15)
            
            Image(uiImage: UIImage(data: player.playerImage ?? Data()) ?? UIImage(named: "defaultProfile")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
            
            Text(player.name)
            Spacer()
            Text(getStatForPlayer())
        }
    }
    
    private func getStatForPlayer() -> String {
        switch selectedSortOption {
        case .earningsPerGame:
            return getDollar(player.getNetReturn())
        case .averageProfitPerGame:
            return getDollar(player.getAvgReturn())
        case .returnPerDollar:
            return getDollar(player.getRPB())
        }
    }
}

#Preview {
    leaderBoardView(gameModel: Series(input: "bruh"))
}
