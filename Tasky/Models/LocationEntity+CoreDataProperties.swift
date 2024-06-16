//
//  LocationEntity+CoreDataProperties.swift
//  Tasky
//
//  Created by Tilak Shakya on 16/06/24.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: String?
    @NSManaged public var reminderText: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension LocationEntity {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskItem)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskItem)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension LocationEntity : Identifiable {

}
