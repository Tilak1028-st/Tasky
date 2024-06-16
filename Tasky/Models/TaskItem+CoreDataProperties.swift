//
//  TaskItem+CoreDataProperties.swift
//  Tasky
//
//  Created by Tilak Shakya on 16/06/24.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isInProgess: Bool
    @NSManaged public var priority: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var locationReminder: LocationEntity?

}

extension TaskItem : Identifiable {

}
