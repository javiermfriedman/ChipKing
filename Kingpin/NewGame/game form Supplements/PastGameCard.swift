import SwiftUI

struct PastGameCard: View {
    let gameInfo: pastGame
    @Binding var deleteIsShown: Bool
    @State private var showFullView = false
    
    var body: some View {
        Button{
            showFullView.toggle()
        }label: {
            VStack {
                if showFullView && !deleteIsShown{
                    if gameInfo.winner == "" {
                        fullViewNoWiner
                    } else {
                        fullViewWinner
                    }

                } else {
                    collapsedView
                }
            }
        }
    }
    
    private var fullViewWinner: some View {
        ZStack {
            Image("background-plain")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 510)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 2)
                )
            
            VStack {
                Text(formatDate(date: gameInfo.date))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.gray.opacity(0.2))  // Optional: add a background color if needed
                    .cornerRadius(8)
                
                Image(uiImage: UIImage(data: gameInfo.imgPath ?? Data()) ?? UIImage(named: "Pokerchips3")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 230)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                Text("winner was")
                    .font(.caption)
                
                Text("\(gameInfo.winner)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.gray.opacity(0.2))  // Optional: add a background color if needed
                    .cornerRadius(8)
                
                
            }
            .padding()
            .background(Color.black.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(width: 270, height: 450)
        }
    }
    
    private var fullViewNoWiner: some View{
        ZStack {
            Rectangle()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 420)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .foregroundColor(Color("DarkYellow")) // Golden color
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 2)
                )
            
            VStack {
                Text(formatDate(date: gameInfo.date))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Image(uiImage: UIImage(data: gameInfo.imgPath ?? Data()) ?? UIImage(named: "Pokerchips3")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 230)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding()
            .background(Color.green1.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(width: 300, height: 365)
        }
        
    }
    
    private var collapsedView: some View {
        ZStack {
            
            Image(uiImage: UIImage(data: gameInfo.imgPath ?? Data()) ?? UIImage(named: "defaultProfile")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 2)
                )
            
            Text(formatDate(date: gameInfo.date))
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .background(Color.black.opacity(0.5))
        }
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

//#Preview {
//    PastGameCard(gameInfo: pastGame(date: Date(), winner: "Player 1", imgPath: nil))
//}
