import SwiftUI

struct tabbarview: View {
    @ObservedObject var gameModel: Series
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                newgameView(gameModel: gameModel)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .background(Color.clear)

                playersView(gameModel: gameModel)
                    .tabItem {
                        Image(systemName: "figure.mind.and.body")
                        Text("Players")
                    }
                    .background(Color.clear)

                leaderBoardView(gameModel: gameModel)
                    .tabItem {
                        Image(systemName: "medal.fill")
                        Text("Leaderboard")
                    }
                    .background(Color.clear)
            }
            .accentColor(.white)
            .onAppear {
                customizeTabBarAppearance()
                gameModel.getPlayersData()
            }
            
            // Add a thicker line above the tab bar
            Rectangle()
                .fill(Color.black) // Line color
                .frame(height: 6) // Adjust height to make the line thicker
                .edgesIgnoringSafeArea(.horizontal)
                .padding(.bottom, 46) // Adjust as needed to position the line
        }
    }
    
    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        // Create a gradient layer for the background
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.brown.cgColor, UIColor.brown.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        // Set the gradient's frame to match the tab bar's bounds
        let tabBarSize = CGSize(width: UIScreen.main.bounds.width, height: 49) // Standard tab bar height
        gradient.frame = CGRect(origin: .zero, size: tabBarSize)
        
        // Render the gradient to an image
        let gradientImage = UIImage.fromLayer(layer: gradient)
        
        // Set the tab bar background image to the gradient image
        appearance.backgroundImage = gradientImage
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension UIImage {
    static func fromLayer(layer: CAGradientLayer) -> UIImage? {
        UIGraphicsBeginImageContext(layer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

#Preview {
    tabbarview(gameModel: Series(input: "ur mom"))
}
