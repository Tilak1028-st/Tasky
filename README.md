# Smart Task Manager iOS App

## Overview
The **Smart Task Manager** is a comprehensive iOS application designed to help users manage their tasks efficiently. This app allows users to create, read, update, and delete tasks with various attributes like title, description, due date, priority level, and location-based reminders. It also includes a dashboard for visualizing task statistics and progress.

## Features
- **CRUD Operations:** Users can create, read, update, and delete tasks.
- **Task Attributes:** Each task includes a title, description, due date, priority level (High, Medium, Low), and location-based reminders.
- **Dashboard:** Visual representation of task statistics including completed tasks, pending tasks, and task priority distribution.
- **Facial Recognition:** Utilizes Apple's Face ID for unlocking the app or specific features.
- **Push Notifications:** Reminders for upcoming tasks.
- **Local Storage:** Uses Core Data for storing tasks locally.
- **Third-Party Libraries:** Integrates libraries such as Alamofire for network requests, SDWebImage for image handling, and MapKit for location features.

## UI Design
The app follows a clean and intuitive UI design as per the provided mockups.

### Home Screen
- Displays a list of tasks categorized into "In Progress", "Upcoming", and "Completed".
- Floating Action Button (FAB) for adding new tasks.
- Bottom navigation bar with icons for Task Manager, Calendar, and Dashboard.

### Calendar Screen
- Displays a calendar view for date selection.
- List of tasks categorized as in progress, upcoming, and completed.

### Dashboard Screen
- Displays a donut chart and bar graph for task statistics.

## Requirements
- **Language:** Swift
- **Frameworks:** SwiftUI or UIKit
- **Storage:** Core Data
- **Third-Party Libraries:** Alamofire, SDWebImage, MapKit
- **Architecture:** MVC or MVVM
- **CI/CD:** GitHub Actions
- **Testing:** Basic unit tests and UI tests
- **Facial Recognition:** Face ID API
- **Push Notifications:** For task reminders

## Bonus Features
- **Cloud Sync:** Sync tasks with Firebase or iCloud.
- **Animations and Custom UI Components:** Enhance user experience.
- **Localization Support:** Include support for an additional language.
- **Machine Learning:** Provide task suggestions or reminders based on user behavior.

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/Tilak1028-st/Tasky.git
   ```
2. Navigate to the project directory:
   ```sh
   cd Tasky
   ```
3. Install dependencies using CocoaPods:
   ```sh
   pod install
   ```
4. Open the project in Xcode:
   ```sh
   open Tasky.xcworkspace
   ```
5. Build and run the app on a simulator or physical device.

## Design Choices
- **SwiftUI for UI Design:** SwiftUI was chosen for its declarative syntax and efficient UI updates.
- **Core Data for Storage:** Core Data provides robust local storage with support for complex queries and relationships.
- **Face ID Integration:** Enhances security by allowing biometric authentication.
- **Third-Party Libraries:** Alamofire simplifies network requests, SDWebImage efficiently handles image caching, and MapKit provides comprehensive location services.
- **CI/CD with GitHub Actions:** Ensures continuous integration and delivery, allowing automated testing and deployment.

## Trade-offs
- **SwiftUI vs. UIKit:** SwiftUI offers modern declarative syntax but lacks some advanced features present in UIKit.
- **Core Data vs. Realm:** Core Data is integrated with the Apple ecosystem, but Realm offers simpler syntax and better performance for some use cases.

## Future Improvements
- **Advanced Machine Learning:** Implement more sophisticated algorithms for task suggestions.
- **Cross-Platform Support:** Expand the app to support other platforms like Android.
- **Enhanced Notifications:** Include more granular control over notifications and reminders.

## Video Demonstration
[A short video demonstrating the app's functionality](https://link-to-your-video.com)

## License
This project is licensed under the MIT License - see the LICENSE file for details.

---

For any queries or issues, please contact [your.email@example.com](mailto:your.email@example.com).
