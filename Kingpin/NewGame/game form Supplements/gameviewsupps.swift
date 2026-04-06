import SwiftUI

struct statViewForm: View {
    var player: Player
    @Binding var date: Date
    @ObservedObject var gameModel: Series
    @State var buyIn = ""
    @State var buyOut = ""
    @Binding var hitFinished: Bool

    
    private func floatValue(from text: String) -> Float {
        return Float(text) ?? 0
    }
    
    private func getEarning(statOne: Float, statTwo: Float) -> Float {
        return statTwo - statOne
    }
    
    var body: some View {
        playerInfo(buyIn: $buyIn, buyOut: $buyOut)
            .onChange(of: hitFinished) { newValue, oldValue in
                
                
                if buyIn != "" && buyOut != "" {
                    let buyin = floatValue(from: buyIn)
                    let buyout = floatValue(from: buyOut)
                    let earning = getEarning(statOne: buyin, statTwo: buyout)
                    
                    let currPlayerEarning: Float
                    
                    if !player.gameStatsArray.isEmpty {
                        currPlayerEarning = player.getNetReturn() + earning
                    } else {
                        currPlayerEarning = earning
                    }

                    let stat = gameStat(buyIn: buyin, buyOut: buyout, earning: earning, date: date, currPlayerEarning: currPlayerEarning)
                    player.addGameStat(stat: stat)
                }
            }
    }
}

struct playerInfo: View {
    @Binding var buyIn: String
    @Binding var buyOut: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Buy In: $")
                TextField("Enter", text: $buyIn)
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Buy Out: $")
                TextField("Enter", text: $buyOut)
                    .keyboardType(.decimalPad)
            }
        }
    }
}
