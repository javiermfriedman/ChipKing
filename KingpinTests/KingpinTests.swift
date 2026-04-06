//
//  KingpinTests.swift
//  KingpinTests
//
//  Created by Javier Friedman on 8/11/24.
//

import XCTest
@testable import Kingpin

final class KingpinTests: XCTestCase {
    func testSeriesStoresGivenName() {
        let series = Series(input: "Friday Game")
        XCTAssertEqual(series.name, "Friday Game")
    }

    func testAddPlayerIncreasesSeriesPlayerCount() {
        let series = Series(input: "Weekly")
        let player = Player(name: "Javier", image: nil)

        series.addPlayer(player: player)

        XCTAssertEqual(series.playerArray.count, 1)
        XCTAssertEqual(series.playerArray.first?.name, "Javier")
    }

    func testPlayerStatsMath() {
        let player = Player(name: "Sam", image: nil)
        player.gameStatsArray = [
            gameStat(buyIn: 100, buyOut: 140, earning: 40, date: Date(), currPlayerEarning: 40),
            gameStat(buyIn: 50, buyOut: 0, earning: -50, date: Date().addingTimeInterval(-3600), currPlayerEarning: -50)
        ]

        XCTAssertEqual(player.getNetBuyIn(), 150, accuracy: 0.001)
        XCTAssertEqual(player.getNetReturn(), -10, accuracy: 0.001)
        XCTAssertEqual(player.getAvgReturn(), -5, accuracy: 0.001)
        XCTAssertEqual(player.getRPB(), 140 / 150, accuracy: 0.001)
        XCTAssertEqual(player.getNumBusts(), 1)
    }

    func testPlayerCodableRoundTripPreservesData() throws {
        let original = Player(name: "Alex", image: nil)
        original.gameStatsArray = [
            gameStat(buyIn: 80, buyOut: 110, earning: 30, date: Date(), currPlayerEarning: 30)
        ]

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Player.self, from: data)

        XCTAssertEqual(decoded.name, "Alex")
        XCTAssertEqual(decoded.gameStatsArray.count, 1)
        XCTAssertEqual(decoded.gameStatsArray[0].earning, 30, accuracy: 0.001)
    }

    func testPerformancePlayerSortingByNetReturn() {
        let players = (0..<500).map { idx -> Player in
            let player = Player(name: "P\(idx)", image: nil)
            player.gameStatsArray = [
                gameStat(buyIn: 100, buyOut: Float(idx), earning: Float(idx - 100), date: Date(), currPlayerEarning: Float(idx - 100))
            ]
            return player
        }

        measure {
            _ = players.sorted { $0.getNetReturn() > $1.getNetReturn() }
        }
    }

}
