//
//  previousGamesScroll.swift
//  Kingpin
//
//  Created by Javier Friedman on 8/12/24.
//

import SwiftUI

struct gamesScroll: View {
    let player: Player
    
    private func getColor(stat: gameStat) -> Color{
        if stat.buyIn > stat.buyOut {
            return .red
        } else if stat.buyOut > stat.buyIn{
            return .green
        } else {
            return .black
        }
        
        
    }
    
    var body: some View {
        VStack{
            Text("Previous Games")
                .font(.title3)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top, 15)

            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 7) { // Added spacing between items
                    ForEach(player.gameStatsArray.sorted(by: { $0.date > $1.date })) { stat in
                        playerStatCard(myColor: getColor(stat: stat), stat: stat)
                    }
                }
            }
        }
        .background()
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
    }
}

struct playerStatCard: View {
    
    let myColor: Color
    let stat: gameStat
    
    private func formatDate(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d" // Example format: Aug 12
            return formatter.string(from: date)
    }
    
    var body: some View {
        HStack { // Changed to VStack for vertical alignment
            Rectangle()
                .fill(Color.black)
                .frame(width: 2, height: 100) // Specify size for Rectangle
            VStack{
                Text(formatDate(date: stat.date))
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Buy In: $\(String(format: "%.2f", stat.buyIn))")
                    .font(.body)
                
                Text("Buy Out: $\(String(format: "%.2f", stat.buyOut))")
                    .font(.body)
                    .foregroundStyle(myColor)
            }
            Rectangle()
                .fill(Color.black)
                .frame(width: 2, height: 100)
            
        }
        .padding(10)
    }
}


//#Preview {
//    previousGamesScroll()
//}
