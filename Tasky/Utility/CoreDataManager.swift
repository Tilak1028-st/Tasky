//
//  CoreDataManager.swift
//  Tasky
//
//  Created by Tilak Shakya on 16/06/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    // Reference to the Managed Object Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Add Task Item
    func addTaskItem(title: String, description: String, dueDate: Date, priority: String, isCompleted: Bool, locationReminder: LocationEntity?) {
        let taskItem = TaskItem(context: context)
        taskItem.title = title
        taskItem.taskDescription = description
        taskItem.dueDate = dueDate
        taskItem.priority = priority
        taskItem.isCompleted = isCompleted
        taskItem.isInProgess = false
        taskItem.locationReminder = locationReminder
        
        saveContext()
    }
    
    // MARK: - Fetch Task Items
    func fetchTaskItems() -> [TaskItem] {
        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        
        do {
            let taskItems = try context.fetch(fetchRequest)
            return taskItems
        } catch {
            print("Failed to fetch task items: \(error)")
            return []
        }
    }
    
    // MARK: - Update Task Item
    func updateTaskItem(taskItem: TaskItem, title: String, description: String, dueDate: Date, priority: String, isCompleted: Bool, isInProgress: Bool, locationReminder: LocationEntity?) {
        taskItem.title = title
        taskItem.taskDescription = description
        taskItem.dueDate = dueDate
        taskItem.priority = priority
        taskItem.isCompleted = isCompleted
        taskItem.locationReminder = locationReminder
        
        saveContext()
    }
    
    // MARK: - Delete Task Item
    func deleteTaskItem(taskItem: TaskItem) {
        context.delete(taskItem)
        saveContext()
    }
    
    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
