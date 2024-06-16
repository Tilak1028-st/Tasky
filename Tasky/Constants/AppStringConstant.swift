//
//  AppStringConstant.swift
//  Tasky
//
//  Created by Tilak Shakya on 14/06/24.
//

import Foundation

struct AppStringConstant {
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
    
    
    // View Controllers
    static var taskViewController = "TaskViewController"
    static var homeViewController = "HomeViewController"
    static var addNewTaskViewController = "AddNewTaskViewController"
    static var dashboardViewController = "DashboardViewController"
    static var mapSearchViewController = "MapSearchViewController"
}

struct ImageConstant {
    static var plusCircleFill = "plus.circle.fill"
    static var xmarkCircleFill = "xmark.circle.fill"
}

struct AppErrorConstant {
    static var animationLoadingError = "Failed to load animation with asset name"
    static var searchError = "Search error:"
}
