import Foundation
import SwiftUI




// gameStat Struct
import Foundation
import SwiftUI

// gameStat Struct with new variable
struct gameStat: Identifiable, Codable {
    var id = UUID()
    let buyIn: Float
    let buyOut: Float
    let earning: Float
    let date: Date
    let currPlayerEarning: Float
}


// pastGame Struct

struct pastGame: Identifiable, Codable {
    let id: UUID
    let date: Date
    let winner: String
    var imgPath: Data? // Use Data for image storage

    init(id: UUID = UUID(), date: Date, winner: String, imgPath: Data?) {
        self.id = id
        self.date = date
        self.winner = winner
        self.imgPath = imgPath
    }
    
    // Convert Data back to UIImage
    var image: UIImage? {
        guard let imgData = imgPath else { return nil }
        return UIImage(data: imgData)
    }
}

//let defaultPlayer = Player(name: "Default Player", image: UIImage(named: "defaultProfile"))
