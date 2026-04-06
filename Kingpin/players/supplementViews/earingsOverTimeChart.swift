import SwiftUI
import Charts

struct EaringsOverTimeChart: View {
    let player: Player
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy" // Example format: 9/10/24
        return formatter.string(from: date)
    }
    
    // Custom formatter for Y-axis labels
    private func dollarFormatter(value: Double) -> String {
        return String(format: "$%.2f", value)
    }
    
    var body: some View {
        VStack {
            Text("Earnings Over Time")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Chart {
                ForEach(player.gameStatsArray.sorted(by: { $0.date < $1.date })) { stat in
                    LineMark(
                        x: .value("Date", formatDate(date: stat.date)),
                        y: .value("Earning", stat.currPlayerEarning)
                    )
                    .symbol(Circle())
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
//    EaringsOverTimeChart(player: defaultPlayer)
// }
