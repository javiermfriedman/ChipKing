import SwiftUI
import Charts

struct BLOCKCHART: View {
    let player: Player
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy" // Example format: Aug 12
        return formatter.string(from: date)
    }
    
    // Custom formatter for Y-axis labels
    private func dollarFormatter(value: Double) -> String {
        return String(format: "$%.2f", value)
    }
    
    var body: some View {
        VStack {
            Text("Profit/Loss per Game")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Chart {
                ForEach(player.gameStatsArray.sorted(by: { $0.date < $1.date })) { stat in
                    BarMark(
                        x: .value("Date", formatDate(date: stat.date)),
                        y: .value("Earnings", stat.earning)
                    )
                }
            }
            .padding()
            .cornerRadius(10)
            .shadow(radius: 5)
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text("Date")
            }
            .chartYAxisLabel(position: .leading, alignment: .center) {
                Text("Return")
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        Text(dollarFormatter(value: value.as(Double.self)!))
                    }
                }
            }
        }
        .background() // Set background color if needed
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
    }
}

// #Preview {
//    BLOCKCHART(player: defaultPlayer)
// }
