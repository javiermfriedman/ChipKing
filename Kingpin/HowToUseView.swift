//
//  HowToUseView.swift
//  Kingpin
//
//  Created by Javier Friedman on 8/28/24.
//

import SwiftUI

struct HowToUseView: View {
    @Binding var showView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    showView = false
                } label: {
                    Image(systemName: "x.square")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                }
            }
            
            Text("HOW TO USE CHIPKING")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SectionHeader(title: "Overview")
                    
                    Text("""
                    The inspiration for Chipking struck last year during a heated debate with friends over who was the greatest poker player among us. Without a way to track our games throughout the year, the argument devolved into a baseless squabble. And thus, Chipking was born...

                    Chipking is the definitive app for tracking poker winnings among a group of players. You can manage multiple series, each corresponding to different groups or games you play. For instance, you might have one series for your Friday night games with coworkers and another for your Sunday games with college friends. Chipking allows you to track these series and their stats independently.

                    Within a series, each game is meticulously logged, and every player's individual stats are recorded. Chipking then generates a comprehensive player portfolio, detailing your stats across the series. Additionally, a leaderboard showcases the cumulative stats of all players in the series.
                    """)
                    
                    SectionHeader(title: "How to Set Up")
                    
                    GuideImgView(caption: "To begin, create a new series by tapping 'Make New Series'.", imageName: "TitleKey")
                    
                    GuideImgView(caption: "Within the series, add players by tapping the '+' button in the Players tab. You can always add more players later if someone joins.", imageName: "EmptyPlayers")
                    
                    GuideImgView(caption: "Ensure each player has a unique name. Don’t forget to add a profile picture from your camera roll.", imageName: "ListOfPlayers")
                    
                    GuideImgView(caption: "Navigate to the first tab to log a new game. Tap 'Add New Game' to access the game form.", imageName: "gameViewEmpty")
                    
                    GuideImgView(caption: "Start by setting the general game stats: the date, the player with the most chips, and take a picture of them to capture the moment.", imageName: "NewGameFormTop")
                    
                    GuideImgView(caption: """
                    For each player, enter their buy-in amount and their final cash-out value (the amount at the end of the game). Leave the name blank if a player didn’t participate. If a player busted, set their cash-out to 0. Note: Once you finish the form, you cannot go back. If your series already has a lot of data, it may take a few seconds to save a new game. Ensure it doesn't say 'loading' before exiting the app.
                    """, imageName: "AddNewGameFormBottom")
                    
                    SectionHeader(title: "Chipking resources")
                    
                    
                    GuideImgView(caption: "As you log more games, you’ll be able to track them in the Games tab.", imageName: "GameViewFull")
                    
                    GuideImgView(caption: "How to delete a game: press and hold one the desired game to delete and a delete pop up will show", imageName: "deleteGame")
                    
                    GuideImgView(caption: "In the Players tab, tapping a player's card reveals their cumulative stats over the series.", imageName: "gridOfPlayers")
                    
                    HStack {
                            Spacer()
                            Image("Profile")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            Spacer()
                        }

                    
                    GuideImgView(caption: "At the bottom of the player profile, you’ll find a 'Remove Player' button if you need to delete someone from the series.", imageName: "RemovePlayer")
                    
                    GuideImgView(caption: "Finally, the Leaderboard tab offers three filter options to compare the players in the series.", imageName: "LeaderBoardView")
                }
                .padding()
            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()
            Spacer()
        }
    }
}

struct GuideImgView: View {
    let caption: String
    let imageName: String
    
    var body: some View {
        VStack {
            Text(caption)
                .multilineTextAlignment(.leading)
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

#Preview {
    HowToUseView(showView: .constant(true))
}
