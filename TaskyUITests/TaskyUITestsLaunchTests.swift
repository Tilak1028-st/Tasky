//
//  TaskyUITestsLaunchTests.swift
//  TaskyUITests
//
//  Created by Tilak Shakya on 16/06/24.
//

import XCTest

final class TaskyUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()


        // Verify the main screen elements are present
        XCTAssertTrue(app.navigationBars["Dashboard"].exists, "Dashboard navigation bar should be present")
        XCTAssertTrue(app.buttons["Add Task"].exists, "Add Task button should be present")

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testInitialDataLoad() throws {
        let app = XCUIApplication()
        app.launch()

        // Assuming there is a table that shows tasks
        let tasksTable = app.tables["TasksTable"]
        XCTAssertTrue(tasksTable.exists, "Tasks table should be present")
        
        // Check for at least one cell (if there's supposed to be initial data)
        let firstTaskCell = tasksTable.cells.element(boundBy: 0)
        XCTAssertTrue(firstTaskCell.exists, "At least one task should be present")
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Initial Data Load"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
