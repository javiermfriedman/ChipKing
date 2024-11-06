//
//  deleteGameView.swift
//  Kingpin
//
//  Created by Javier Friedman on 9/1/24.
//

import SwiftUI

import SwiftUI

struct deleteGameView: View {
    
    @ObservedObject var gameModel: Series
    @Binding var showView: Bool
    let gameInfo: pastGame


    var body: some View {
        ZStack{
            
            Color.black.opacity(0.92)
                .edgesIgnoringSafeArea(.all)
            
            
            VStack(spacing: 20) {
                Text("Delete this Game?")
                    .font(.title)
                    .foregroundStyle(.black)
                    .padding()
                
                collapsedView
                
                HStack(spacing: 30) {
 
                    Button(action: {
                        showView = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        gameModel.deletePastGame(game: gameInfo)
                        showView = false
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                }
                .padding()
            }
            .frame(width: 310, height: 300)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
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
    
    private func deleteGame(){
        
    }
}



//#Preview {
//    deleteGameView(date: <#Date#>)
//}
