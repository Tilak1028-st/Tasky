//
//  TaskyUITests.swift
//  TaskyUITests
//
//  Created by Tilak Shakya on 16/06/24.
//

import XCTest

final class TaskyUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Initialize the app and set it to stop immediately when a failure occurs
        app = XCUIApplication()
        continueAfterFailure = false
        
        // Launch the app
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }


   func testAddTask() throws {
       // Given
       let taskTitle = "UI Test Task"
       let taskDescription = "This is a UI test task."

       // When
       app.buttons["Add Task"].tap()
       
       let titleTextField = app.textFields["Task Title"]
       XCTAssertTrue(titleTextField.exists)
       titleTextField.tap()
       titleTextField.typeText(taskTitle)

       let descriptionTextView = app.textViews["Task Description"]
       XCTAssertTrue(descriptionTextView.exists)
       descriptionTextView.tap()
       descriptionTextView.typeText(taskDescription)

       let dueDatePicker = app.datePickers["Due Date"]
       XCTAssertTrue(dueDatePicker.exists)
       dueDatePicker.adjust(toPickerWheelValue: "Tomorrow at 12:00 PM")

       app.buttons["Save Task"].tap()

       // Then
       let taskCell = app.tables.cells.staticTexts[taskTitle]
       XCTAssertTrue(taskCell.exists)
   }

    func testUpdateTask() throws {
        // Given
        let originalTaskTitle = "UI Test Task"
        let updatedTaskTitle = "Updated UI Test Task"

        // Ensure the task exists
        try testAddTask()

        // When
        let taskCell = app.tables.cells.staticTexts[originalTaskTitle]
        XCTAssertTrue(taskCell.exists)
        taskCell.tap()

        let titleTextField = app.textFields["Task Title"]
        XCTAssertTrue(titleTextField.exists)
        titleTextField.tap()
        titleTextField.clearText()
        titleTextField.typeText(updatedTaskTitle)

        app.buttons["Save Task"].tap()

        // Then
        let updatedTaskCell = app.tables.cells.staticTexts[updatedTaskTitle]
        XCTAssertTrue(updatedTaskCell.exists)
    }

    func testDeleteTask() throws {
        // Given
        let taskTitle = "UI Test Task"

        // Ensure the task exists
        try testAddTask()

        // When
        let taskCell = app.tables.cells.staticTexts[taskTitle]
        XCTAssertTrue(taskCell.exists)
        taskCell.swipeLeft()
        app.buttons["Delete"].tap()

        // Then
        XCTAssertFalse(taskCell.exists)
    }


   func testViewTaskDetails() throws {
       // Given
       let taskTitle = "UI Test Task"
       let taskDescription = "This is a UI test task."

       // Ensure the task exists
       try testAddTask()

       // When
       let taskCell = app.tables.cells.staticTexts[taskTitle]
       XCTAssertTrue(taskCell.exists)
       taskCell.tap()

       // Then
       let titleTextField = app.textFields["Task Title"]
       XCTAssertTrue(titleTextField.exists)
       XCTAssertEqual(titleTextField.value as? String, taskTitle)

       let descriptionTextView = app.textViews["Task Description"]
       XCTAssertTrue(descriptionTextView.exists)
       XCTAssertEqual(descriptionTextView.value as? String, taskDescription)
   }

   func testPerformanceExample() throws {
       measure {
           // Measure the time it takes to perform an operation
           app.launch()
       }
   }
}

extension XCUIElement {
   func clearText() {
       guard let stringValue = self.value as? String else {
           return
       }

       self.tap()
       
       let deleteString = stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined(separator: "")
       self.typeText(deleteString)
   }
}
