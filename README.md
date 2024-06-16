# Tasky: Smart Task Manager

## Overview
The Smart Task Manager is a comprehensive iOS application designed to help users manage their tasks efficiently. It allows users to create, read, update, and delete tasks, set priority levels, and receive location-based reminders. The app also includes a dashboard to visualize task statistics and progress. This README provides an overview of the app's features, design choices, and implementation details.

## Features
- **Task Management:** Create, read, update, and delete tasks.
- **Task Details:** Each task includes a title, description, due date, priority level (High, Medium, Low), and location-based reminders.
- **Dashboard:** Visualize task statistics such as completed tasks, pending tasks, and task priority distribution.
- **Face ID Integration:** Use biometric authentication for enhanced security.
- **Push Notifications:** Receive task reminders via push notifications.

## UI Design
The app's user interface follows a clean and modern design using UIKit, ensuring a smooth and intuitive user experience.

### Screens
1. **Home Screen:** Displays a list of tasks with options to add, edit, or delete tasks. Includes a floating action button (FAB) for adding new tasks and a navigation bar for Home, Calendar, and Dashboard.
2. **Task Detail Screen:** Shows task details with options to edit or delete the task.
3. **Add/Edit Task Screen:** A form to enter task details including title, description, due date, priority level, and location-based reminder.
4. **Calendar Screen:** Uses FSCalendar to display tasks on a monthly calendar.
5. **Dashboard Screen:** Displays task statistics using DGCharts for visual representations such as bar charts and pie charts.

### Screenshots

Here are some screenshots of the Smart Task Manager app:

- **Home Screen:**
  <img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/13247522-80df-4b78-84e8-6f505d807c3b" width=230 height=470>
  
- **Task Detail Screen:**
-  <img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/eab4e8cb-6264-4b03-8b9d-d82d530905c0" width=230 height=470>


- **Add/Edit Task Screen:**
  ![Add/Edit Task Screen](screenshots/add_edit_task_screen.png)

- **Calendar Screen:**
- <img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/730992b0-9389-40f2-8b86-b019b9637f1f" width=230 height=470>

- **Dashboard Screen:**
- <img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/cb9b31e3-6e9f-4580-914f-d0a8ff0be026" width=230 height=470>

## Implementation Details

### Programming Language
- **Swift:** The primary programming language used for the app.

### Architecture
- **MVC (Model-View-Controller):** Ensures a clear separation of concerns, making the app more modular and maintainable.

### Storage
- **Core Data:** Used for local storage, providing robust support for complex queries and relationships.

### Libraries and Frameworks
- **Lottie:** Used for animations to enhance the user experience.
- **FSCalendar:** Provides a highly customizable calendar component.
- **DGCharts:** Used for creating charts and graphs in the dashboard.
- **MapKit:** Provides comprehensive location services for setting location-based reminders.

### Continuous Integration and Delivery
- **CI/CD with GitHub Actions:** Ensures continuous integration and delivery, allowing automated testing and deployment. 

### Testing
- **Unit Tests and UI Tests:** Basic unit tests and UI tests are implemented to ensure the app's functionality and reliability.

### Security
- **Face ID Integration:** Uses Apple's Face ID API for biometric authentication, enhancing security for unlocking the app or specific features.

## Bonus Features
- **Animations and Custom UI Components:** Lottie animations are used to enhance the user experience.

## Installation
1. Clone the repository from GitHub:
   ```bash
   git clone https://github.com/Tilak1028-st/Tasky.git
   ```
2. Open the project in Xcode:
   ```bash
   cd tasky
   open tasky.xcodeproj
   ```
3. Install dependencies using CocoaPods:
   ```bash
   pod install
   ```
4. Build and run the app on your simulator or device.

## Usage
1. **Home Screen:** View and manage tasks.
2. **Add Task:** Tap the FAB to add a new task.
3. **Edit Task:** Select a task to view details and edit.
4. **Calendar:** Navigate to the Calendar screen to view tasks by date.
5. **Dashboard:** Navigate to the Dashboard screen to see task statistics.

## Design Choices and Trade-offs
- **UIKit and MVC:** Chosen for their stability and extensive documentation, making the app more maintainable and familiar to many iOS developers.
- **Core Data:** Provides a powerful local storage solution that supports complex queries and relationships.
- **Third-Party Libraries:** Selected for their reliability and ease of use, enhancing the app's functionality without significant overhead.
- **CI/CD with GitHub Actions:** Ensures efficient development workflows, allowing for continuous integration and delivery.

## Conclusion
The Smart Task Manager app is designed to provide a robust and user-friendly task management solution. By leveraging modern iOS development practices and tools, the app ensures a smooth and efficient user experience. For further details and to view the source code, visit the [GitHub repository](https://github.com/yourusername/smart-task-manager).

## Demo Video
Watch the [demo video](https://drive.google.com/file/d/1AuyUgUYXG71--WRxM2diidDDgIpv1-tW/view?usp=sharing) to see the app in action.

---

Feel free to customize this README file further based on specific details and preferences for your project.
