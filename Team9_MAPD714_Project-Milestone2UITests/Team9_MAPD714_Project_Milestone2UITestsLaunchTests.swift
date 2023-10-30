//
//  Team9_MAPD714_Project_Milestone2UITestsLaunchTests.swift
//  Team9_MAPD714_Project-Milestone2UITests
//
//  Created by Shubham Patel on 2023-10-30.
//

import XCTest

final class Team9_MAPD714_Project_Milestone2UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
