//
//  GameCollectorClass.swift
//  Kingpin
//
//  Created by Javier Friedman on 8/18/24.
//

import SwiftUI

class seriesCollector: ObservableObject {
    @Published var arrayOfGames: [Game] = []
    
    func addGame(game: Game){
        arrayOfGames.append(game)
    }
    
    func deleteItem(index: IndexSet) {
        arrayOfGames.remove(atOffsets: index)
    }
    
}
