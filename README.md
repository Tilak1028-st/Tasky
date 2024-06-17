# Tasky: Smart Task Manager

## Overview
The Smart Task Manager is a comprehensive iOS application designed to help users manage their tasks efficiently. It allows users to create, read, update, and delete tasks, set priority levels, and receive location-based reminders. The app integrates seamlessly with the Apple Calendar and Reminders app, ensuring that tasks created in the Task Manager are reflected in the user's Apple Calendar and triggered as location-based reminders in the Reminders app. Additionally, users receive push notifications from the Task Manager at the selected time for each task. The app also includes a dashboard to visualize task statistics and progress. This README provides an overview of the app's features, design choices, and implementation details.

## Features
- **Task Management:** Create, read, update, and delete tasks.
- **Task Details:** Each task includes a title, description, due date, priority level (High, Medium, Low), and location-based reminders.
- **Apple Calendar Integration:** Tasks created in the Task Manager are automatically added to the user's Apple Calendar, and any updates or deletions made in the Task Manager are reflected in the Calendar.
- **Location-Based Reminders:** Tasks with location-based reminders are triggered through the Apple Reminders app when the user enters the specified location.
- **Push Notifications:** Users receive push notifications from the Task Manager at the selected time for each task, reminding them to complete the task.
- **Dashboard:** Visualize task statistics such as completed tasks, pending tasks, and task priority distribution.
- **Face ID Integration:** Use biometric authentication for enhanced security.

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

<table style="width: 100%;">
  <tr style="text-align: center;">
    <td>
      <p><strong>1 - Home Screen</strong></p>
      <img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/13247522-80df-4b78-84e8-6f505d807c3b" width="225" height="375" alt="Home Screen">
    </td>
    <td>
      <p><strong>2 - Add/Edit Task Screen</strong></p>
<img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/eab4e8cb-6264-4b03-8b9d-d82d530905c0" width="225" height="375" alt="Add/Edit Task Screen">
    </td>
  </tr>
  <tr>
    <td>
      <p><strong>3 - Calendar Screen</strong></p>
      <img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/730992b0-9389-40f2-8b86-b019b9637f1f" width="225" height="375" alt="Calendar Screen">
    </td>
    <td>
      <p><strong>4 - Dashboard Screen</strong></p>
      <img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/cb9b31e3-6e9f-4580-914f-d0a8ff0be026" width="225" height="375" alt="Dashboard Screen">
    </td>
  </tr>
  </tr>
  <tr>
    <td>
      <p><strong>3 - Apple Calendar</strong></p>
      <img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/f7806d83-db6e-4264-a5e5-8299fa0e2519" width="225" height="375" alt="Calendar Screen">
    </td>
    <td>
      <p><strong>4 - Dashboard Screen</strong></p>
      <img src="https://github.com/Tilak1028-st/Tasky/assets/75114840/3dd0bc86-01a9-46e2-b6c7-065f99c36f33" width="225" height="375" alt="Dashboard Screen">
    </td>
  </tr>
</table>

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
- **EventKit:** Used for integrating with the Apple Calendar and Reminders app.
- **UserNotifications:** Used for scheduling and handling push notifications.

### Apple Calendar and Reminders Integration
- **EventKit Framework:** Handles the integration with the Apple Calendar and Reminders app.
- **Calendar Integration:** When a task is created, updated, or deleted in the Task Manager, the corresponding changes are made in the user's Apple Calendar using the EventKit framework.
- **Location-Based Reminders:** Tasks with location-based reminders are added as reminders in the Apple Reminders app using the EventKit framework. The reminders are triggered when the user enters the specified location.

### Push Notifications
- **UserNotifications Framework:** Handles the scheduling and delivery of push notifications.
- **Notification Scheduling:** When a task is created or updated with a due date and time, a push notification is scheduled using the UserNotifications framework to remind the user at the selected time.
- **Notification Handling:** The app handles incoming push notifications and updates the task status accordingly.

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
2. Change directory to Tasky in terminal:
   ```bash
   cd Tasky
   ```
3. Run pod install to install dependencies using CocoaPods:
   ```bash
   pod install
   ```
4. Open the project in Xcode:
   ```bash
   open Tasky.xcworkspace
   ```
5. Build and run the app on your simulator or device.

## Usage
1. **Home Screen:** View and manage tasks.
2. **Add Task:** Tap the FAB to add a new task. The task will be automatically added to the Apple Calendar, and a push notification will be scheduled for the selected time.
3. **Edit Task:** Select a task to view details and edit. Changes will be reflected in the Apple Calendar, and the push notification will be updated accordingly.
4. **Delete Task:** Delete a task from the Task Manager, and it will be removed from the Apple Calendar, and the associated push notification will be canceled.
5. **Calendar:** Navigate to the Calendar screen to view tasks by date.
6. **Dashboard:** Navigate to the Dashboard screen to see task statistics.
7. **Location-Based Reminders:** Tasks with location-based reminders will trigger a reminder in the Apple Reminders app when the user enters the specified location.
8. **Push Notifications:** Users will receive push notifications from the Task Manager at the selected time for each task, reminding them to complete the task.

## Design Choices and Trade-offs
- **UIKit and MVC:** Chosen for their stability and extensive documentation, making the app more maintainable and familiar to many iOS developers.
- **Core Data:** Provides a powerful local storage solution that supports complex queries and relationships.
- **EventKit Framework:** Used for seamless integration with the Apple Calendar and Reminders app, providing a native experience for users.
- **UserNotifications Framework:** Used for scheduling and handling push notifications, ensuring timely reminders for tasks.
- **Third-Party Libraries:** Selected for their reliability and ease of use, enhancing the app's functionality without significant overhead.
- **CI/CD with GitHub Actions:** Ensures efficient development workflows, allowing for continuous integration and delivery.

## Conclusion
The Smart Task Manager app is designed to provide a robust and user-friendly task management solution. With its seamless integration with the Apple Calendar and Reminders app, users can manage their tasks efficiently, receive location-based reminders, and get timely push notifications for their tasks. By leveraging modern iOS development practices and tools, the app ensures a smooth and efficient user experience. For further details and to view the source code, visit the [GitHub repository](https://github.com/yourusername/smart-task-manager).

## Demo Video
Watch the [demo video](https://drive.google.com/file/d/1JCkHnxZJEIkkDVDsVI5bqxLQnt0JNyUl/view?usp=sharing) to see the app in action.

---

Feel free to customize this README file further based on specific details and preferences for your project.
