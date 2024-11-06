import SwiftUI

class Series: ObservableObject, Codable, Identifiable {
    @Published var isSavingGames = false
    @Published var isSavingPlayers = false
    @Published var isFetchingPlayers = false
    @Published var pastGamesArray: [pastGame] = []
    @Published var playerArray: [Player] = []
    var name: String

    enum CodingKeys: String, CodingKey {
        case pastGamesArray
        case playerArray
        case name
    }
    
    init(input: String) {
        self.name = input
    }
    
    func getPlayersData() {
        let group = DispatchGroup()

        group.enter()
        loadPlayers { group.leave() }
        
        group.enter()
        loadPastGames { group.leave() }
        
        group.notify(queue: .main) {
            self.loadData()
        }
    }
    
    func startSavingGamesProcess() {
            self.isSavingGames = true
        
    }
    
    func endSavingGamesProcess() {
            self.isSavingGames = false
        
    }
    
    func startSavingPlayersProcess() {
       
            self.isSavingPlayers = true
        
    }
    
    func endSavingPlayersProcess() {
            
            self.isSavingPlayers = false
        
    }
    
    func startFetchingPlayersProcess() {
       
            self.isFetchingPlayers = true
        
    }
    
    
    func endFetchingPlayersProcess() {
            
            self.isFetchingPlayers = false
        
    }

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        playerArray = try container.decode([Player].self, forKey: .playerArray)
        pastGamesArray = try container.decode([pastGame].self, forKey: .pastGamesArray)
        name = try container.decode(String.self, forKey: .name)
    }
    

    
    func loadData() {
        DispatchQueue.main.async {
            for player in self.playerArray {
                player.loadGameStats()  // Ensure game stats are loaded
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(playerArray, forKey: .playerArray)
        try container.encode(pastGamesArray, forKey: .pastGamesArray)
        try container.encode(name, forKey: .name)
    }
    
    func addPlayer(player: Player) {
        self.startSavingPlayersProcess()
        playerArray.append(player)
        DispatchQueue.main.async {
            self.savePlayers()  // Save players asynchronously on the main thread
        }
    }
    
    func addPastGame(game: pastGame) {
        self.startSavingGamesProcess()
        pastGamesArray.append(game)
        DispatchQueue.main.async {
            self.savePastGames()  // Save past games asynchronously on the main thread
            
        }
    }
    
    func deletePastGame(game: pastGame) {
        
        if let index = pastGamesArray.firstIndex(where: { $0.id == game.id }) {
                   pastGamesArray.remove(at: index)
                   
                   // Optionally, remove associated data for players who played this game
                   for player in playerArray {
                       player.deletePastGameStat(gameDate: game.date)
                   }
                   
                   // Save the updated pastGamesArray
                   self.startSavingGamesProcess()
                   DispatchQueue.main.async {
                       self.savePastGames()
                   }
               }
    }
    
    func savePlayers() {
        let encoder = JSONEncoder()
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try encoder.encode(self.playerArray)
                let fileURL = self.getPlayersFileURL()
                try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
                DispatchQueue.main.async {
                    self.endSavingPlayersProcess()
                    
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error saving players: \(error)")
                }
            }
        }
    }
    

    
    func loadPlayers(completion: @escaping () -> Void) {
        self.startFetchingPlayersProcess()
        let decoder = JSONDecoder()
        let fileURL = getPlayersFileURL()

        if FileManager.default.fileExists(atPath: fileURL.path) {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let players = try decoder.decode([Player].self, from: data)
                    DispatchQueue.main.async {
                        self.playerArray = players
                        self.endFetchingPlayersProcess()
                        completion()  // Call completion handler
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error loading players: \(error)")
                        self.endFetchingPlayersProcess()
                        completion()  // Call completion handler even on error
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                print("File does not exist, creating new file")
                self.savePlayers()
                self.endFetchingPlayersProcess()
                completion()  // Call completion handler after saving
            }
        }
    }
    
    func savePastGames() {
        let encoder = JSONEncoder()
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try encoder.encode(self.pastGamesArray)
                let fileURL = self.getPastGamesFileURL()
                try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
                DispatchQueue.main.async {
                    self.endSavingGamesProcess()
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error saving past games: \(error)")
                }
            }
        }

    }
    
    
    
    func loadPastGames(completion: @escaping () -> Void) {
        let decoder = JSONDecoder()
        let fileURL = getPastGamesFileURL()

        if FileManager.default.fileExists(atPath: fileURL.path) {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let games = try decoder.decode([pastGame].self, from: data)
                    DispatchQueue.main.async {
                        self.pastGamesArray = games
                        completion()  // Call completion handler
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error loading past games: \(error)")
                        completion()  // Call completion handler even on error
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                print("File does not exist, creating new file")
                self.savePastGames()
                completion()  // Call completion handler after saving
            }
        }
    }
    
    func deleteData() {
        // Clear arrays
        self.pastGamesArray.removeAll()
        self.playerArray.removeAll()
        
        // Delete associated files
        deleteFile(at: getPlayersFileURL())
        deleteFile(at: getPastGamesFileURL())
        
        // Optionally, you can also reset the state of saving and fetching flags
        self.isSavingGames = false
        self.isSavingPlayers = false
        self.isFetchingPlayers = false
        
        // Delete data for each player
        for player in playerArray {
            player.deletePlayerData()
        }

        print("All data cleared and files deleted.")
    }

    private func deleteFile(at url: URL) {
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            } else {
                print("File does not exist at \(url)")
            }
        } catch {
            print("Error deleting file at \(url): \(error)")
        }
    }


    
    func getPlayersFileURL() -> URL {
        let fileName = "players_\(name).json" // Unique file name based on series name
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }

    func getPastGamesFileURL() -> URL {
        let fileName = "past_games_\(name).json" // Unique file name based on series name
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
