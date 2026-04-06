//
//  KingpinUITests.swift
//  KingpinUITests
//
//  Created by Javier Friedman on 8/11/24.
//

import XCTest

final class KingpinUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunchesAndIsForeground() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-testing")
        app.launch()

        XCTAssertEqual(app.state, .runningForeground, "App should be running in the foreground after launch.")
    }

    func testBasicTabBarElementsOrInitialScreenExists() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--ui-testing")
        app.launch()

        let tabBar = app.tabBars.firstMatch
        let hasTabBar = tabBar.waitForExistence(timeout: 3)
        let hasInitialStaticText = app.staticTexts.firstMatch.exists

        XCTAssertTrue(hasTabBar || hasInitialStaticText, "Expected either the tab bar or an initial screen element to exist after launch.")
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
