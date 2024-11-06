import SwiftUI

class Player: ObservableObject, Identifiable, Codable, Hashable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        
        return lhs.id == rhs.id && lhs.name == rhs.name
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    // Public properties
    @Published var name: String
    @Published var playerImage: Data? // Store image as Data
    @Published var gameStatsArray: [gameStat] = []
    
    // STATISTIC STUFF
    func getNetReturn() -> Float {
        return gameStatsArray.reduce(0) { $0 + $1.earning }
    }
    
    func getNetBuyIn() -> Float {
        return gameStatsArray.reduce(0) { $0 + $1.buyIn }
    }
    
    func getRPB() -> Float {
        let netBuyIn = getNetBuyIn()
        let netbuyOut = gameStatsArray.reduce(0) { $0 + $1.buyOut }
        return netBuyIn > 0 ? netbuyOut / netBuyIn : 0
    }
    
    func deletePastGameStat(gameDate: Date) {
        gameStatsArray.removeAll { $0.date == gameDate }
        
        // Save the updated gameStatsArray
        saveGameStats()
    }
    
    func getAvgReturn() -> Float {
        let numGames = Float(gameStatsArray.count)
        let netReturn = getNetReturn()
        return numGames > 0 ? netReturn / numGames : 0
    }
    
    func getNumBusts() -> Int {
        return gameStatsArray.filter { $0.buyOut == 0 }.count
    }
    
    // BACK END STUFF
    func addGameStat(stat: gameStat) {
        gameStatsArray.append(stat)
        saveGameStats()
    }
    
    // MEMORY STUFF
    enum CodingKeys: CodingKey {
        case name, playerImage, gameStatsArray
    }
    
    // Initializer
    init(name: String, image: Data?) {
        self.name = name
        self.playerImage = image
    }
    
    // Required initializer for Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        if let imageData = try container.decodeIfPresent(Data.self, forKey: .playerImage) {
            playerImage = imageData
        }
        gameStatsArray = try container.decode([gameStat].self, forKey: .gameStatsArray)
    }
    
    // Function for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(playerImage, forKey: .playerImage)
        try container.encode(gameStatsArray, forKey: .gameStatsArray)
    }

    private func saveGameStats() {
        let filename = getDocumentsDirectory().appendingPathComponent("\(name)_gameStats.json")
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(self.gameStatsArray)
                try data.write(to: filename, options: [.atomic, .completeFileProtection])
                
            } catch {
                DispatchQueue.main.async {
                    print("Unable to save game stats: \(error.localizedDescription)")
                }
            }
        }
    }

    func loadGameStats() {
        
        let filename = getDocumentsDirectory().appendingPathComponent("\(name)_gameStats.json")
        DispatchQueue.global(qos: .background).async {
            if FileManager.default.fileExists(atPath: filename.path) {
                do {
                    let data = try Data(contentsOf: filename)
                    let stats = try JSONDecoder().decode([gameStat].self, from: data)
                    DispatchQueue.main.async {
                        self.gameStatsArray = stats
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Unable to load game stats: \(error.localizedDescription)")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    print("File does not exist at path: \(filename.path)")
                }
            }
        }
    }
    
    func deletePlayerData() {
        // Clear game stats array
        self.gameStatsArray.removeAll()
        
        // Delete associated game stats file
        let filename = getDocumentsDirectory().appendingPathComponent("\(name)_gameStats.json")
        do {
            if FileManager.default.fileExists(atPath: filename.path) {
                try FileManager.default.removeItem(at: filename)
            } else {
                print("Game stats file does not exist at \(filename)")
            }
        } catch {
            print("Error deleting game stats file at \(filename): \(error)")
        }
    }

    
    // Helper method to get the documents directory
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
