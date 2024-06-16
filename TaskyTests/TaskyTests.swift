//
//  TaskyTests.swift
//  TaskyTests
//
//  Created by Tilak Shakya on 14/06/24.
//

import XCTest
@testable import Tasky

final class TaskyTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataManager = CoreDataManager.shared
        clearTaskItems()
    }
    
    override func tearDownWithError() throws {
        coreDataManager = nil
        try super.tearDownWithError()
    }
    
    
    func testAddTask() throws {
        // Given
        let title = "Test Task"
        let description = "This is a test task."
        let dueDate = Date()
        let priority = "High"
        let isCompleted = false
        let locationReminder: LocationEntity? = nil
        
        // When
        coreDataManager.addTaskItem(title: title, description: description, dueDate: dueDate, priority: priority, isCompleted: isCompleted, locationReminder: locationReminder)
        
        // Then
        let taskItems = coreDataManager.fetchTaskItems()
        XCTAssertEqual(taskItems.count, 1)
        let addedTask = taskItems.first!
        XCTAssertEqual(addedTask.title, title)
        XCTAssertEqual(addedTask.taskDescription, description)
        XCTAssertEqual(addedTask.dueDate, dueDate)
        XCTAssertEqual(addedTask.priority, priority)
        XCTAssertEqual(addedTask.isCompleted, isCompleted)
        XCTAssertNil(addedTask.locationReminder)
    }
    
    func testUpdateTask() throws {
        // Given
        let title = "Test Task"
        let description = "This is a test task."
        let dueDate = Date()
        let priority = "High"
        let isCompleted = false
        let locationReminder: LocationEntity? = nil
        
        let task = TaskItem(context: coreDataManager.context)
        task.title = title
        task.taskDescription = description
        task.dueDate = dueDate
        task.priority = priority
        task.isCompleted = isCompleted
        task.locationReminder = locationReminder
        coreDataManager.saveContext()
        
        // When
        let updatedTitle = "Updated Task"
        let updatedDescription = "This is an updated task."
        let updatedDueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let updatedPriority = "Low"
        let updatedIsCompleted = true
        let updatedLocationReminder: LocationEntity? = nil
        
        coreDataManager.updateTaskItem(taskItem: task, title: updatedTitle, description: updatedDescription, dueDate: updatedDueDate, priority: updatedPriority, isCompleted: updatedIsCompleted, isInProgress: false, locationReminder: updatedLocationReminder)
        
        // Then
        let updatedTask = coreDataManager.fetchTaskItems().first!
        XCTAssertEqual(updatedTask.title, updatedTitle)
        XCTAssertEqual(updatedTask.taskDescription, updatedDescription)
        XCTAssertEqual(updatedTask.dueDate, updatedDueDate)
        XCTAssertEqual(updatedTask.priority, updatedPriority)
        XCTAssertEqual(updatedTask.isCompleted, updatedIsCompleted)
        XCTAssertNil(updatedTask.locationReminder)
    }
    
    func testDeleteTask() throws {
        // Given
        let task = TaskItem(context: coreDataManager.context)
        task.title = "Task to delete"
        coreDataManager.saveContext()
        
        // When
        coreDataManager.deleteTaskItem(taskItem: task)
        
        // Then
        let taskItems = coreDataManager.fetchTaskItems()
        XCTAssertEqual(taskItems.count, 0)
    }
    
    func testFetchTaskItems() throws {
        // Given
        let task1 = TaskItem(context: coreDataManager.context)
        task1.title = "Task 1"
        let task2 = TaskItem(context: coreDataManager.context)
        task2.title = "Task 2"
        coreDataManager.saveContext()
        
        // When
        let taskItems = coreDataManager.fetchTaskItems()
        
        // Then
        XCTAssertEqual(taskItems.count, 2)
        XCTAssertEqual(taskItems[0].title, "Task 1")
        XCTAssertEqual(taskItems[1].title, "Task 2")
    }
    
    func testFetchTaskItemsByStatus() throws {
        // Given
        let completedTask = TaskItem(context: coreDataManager.context)
        completedTask.title = "Completed Task"
        completedTask.isCompleted = true
        
        let inProgressTask = TaskItem(context: coreDataManager.context)
        inProgressTask.title = "In Progress Task"
        inProgressTask.isInProgess = true
        
        let upcomingTask = TaskItem(context: coreDataManager.context)
        upcomingTask.title = "Upcoming Task"
        upcomingTask.dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        coreDataManager.saveContext()
        
        // When
        let completedTasks = coreDataManager.fetchTaskItems().filter { $0.isCompleted }
        let inProgressTasks = coreDataManager.fetchTaskItems().filter { $0.isInProgess }
        let upcomingTasks = coreDataManager.fetchTaskItems().filter { !$0.isCompleted && !$0.isInProgess }
        
        // Then
        XCTAssertEqual(completedTasks.count, 1)
        XCTAssertEqual(inProgressTasks.count, 1)
        XCTAssertEqual(upcomingTasks.count, 1)
    }
    
    func testPerformanceFetchTaskItems() throws {
        // Measure the performance of fetching task items
        measure {
            _ = coreDataManager.fetchTaskItems()
        }
    }
    
    private func clearTaskItems() {
        let taskItems = coreDataManager.fetchTaskItems()
        for task in taskItems {
            coreDataManager.deleteTaskItem(taskItem: task)
        }
    }
}
