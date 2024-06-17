//
//  AppStringConstant.swift
//  Tasky
//
//  Created by Tilak Shakya on 14/06/24.
//

import Foundation

struct AppStringConstant {
    static var tasky = "Tasky"
    static var onboardingCellIdentifier = "onboardingCell"
    static var firstOnBoardingTitle = "Welcome to Your Ultimate Productivity Hub: Manage Tasks Seamlessly and Achieve More Every Day"
    static var secondOnBoardingTitle = "Effortlessly Organize Your Life: Categorize, Prioritize, and Track Your Tasks with Ease"
    static var thirdOnBoardingTitle = "Stay Ahead of Your Goals: Set Deadlines, Receive Timely Reminders, and Never Miss a Beat"
    static var firstOnboardingAnimation = "onboarding-1"
    static var secondOnboardingAnimation = "onboarding-2"
    static var thirdOnboardingAnimation = "onboarding-3"
    static var next = "Next"
    static var getStarted = "Get Started"
    static var main = "Main"
    static var createTask = "Create Task"
    static var currentLocation = "Current Location"
    static var locationAccessDenied = "Location access was restricted or denied."
    static var failedToFindUserLocation = "Failed to find user's location:"
    static var search = "Search"
    static var inProgress = "In Progress"
    static var upcoming = "Upcoming"
    static var completed = "Completed"
    static var selectTime = "Select Time"
    static var reminderDeleted = "Reminder deleted successfully"
    static var reminderAdded = "Reminder added successfully"
    static var reminderUpdated = "Reminder updated successfully"
    static var ok = "OK"
    static var calendarManager = "CalendarManager"
    static var low = "Low"
    static var high = "High"
    static var medium = "Medium"
    static var pleaseEnterTaskTitle = "Please enter a task title."
    static var pleaseSelectDueDate = "Please select a due date."
    static var pleaseSelectDueTime = "Please select a due time."
    
    // View Controllers
    static var taskViewController = "TaskViewController"
    static var homeViewController = "HomeViewController"
    static var addNewTaskViewController = "AddNewTaskViewController"
    static var dashboardViewController = "DashboardViewController"
    static var mapSearchViewController = "MapSearchViewController"
    
    // Cells
    static var taskTableViewCell = "TaskTableViewCell"
}

struct ImageConstant {
    static var plusCircleFill = "plus.circle.fill"
    static var xmarkCircleFill = "xmark.circle.fill"
    static var checkmarkCircle = "checkmark.circle"
    static var pencil = "pencil"
    static var trash = "trash"
}

struct AppErrorConstant {
    static var animationLoadingError = "Failed to load animation with asset name"
    static var searchError = "Search error:"
}
