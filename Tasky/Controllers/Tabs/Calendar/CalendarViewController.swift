//
//  CalendarViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 16/06/24.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var noTaskLabel: UILabel!
    @IBOutlet weak var noDataView: UIView!
    
    // MARK: Properties
    var taskItems: [TaskItem] = []
    var tasksForSelectedDate: [TaskItem] = []
    var completedTasksForSelectedDate: [TaskItem] = []
    var upcomingTasksForSelectedDate: [TaskItem] = []
    var inProgressTasksForSelectedDate: [TaskItem] = []

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        fetchTaskItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh UI and data when view appears
        setUpUI()
        fetchTaskItems()
    }

    // MARK: - UI Setup
    private func setUpUI() {
        // Configure table view and calendar
        taskTableView.register(UINib(nibName: AppStringConstant.taskTableViewCell, bundle: nil), forCellReuseIdentifier: AppStringConstant.taskTableViewCell)
        taskTableView.separatorColor = UIColor.clear
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.applyBorder(color: UIColor.gray, width: 1)
        calendar.applyCornerRadius(20)

        // Hide no task label and no data view initially
        noTaskLabel.isHidden = true
        noDataView.isHidden = true
        
        // Configure navigation bar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }

    // MARK: - Data Fetching and Handling
    private func fetchTaskItems() {
        // Fetch task items from Core Data
        taskItems = CoreDataManager.shared.fetchTaskItems()
        updateTasksForSelectedDate(calendar.selectedDate ?? Date())
        
        // Reload UI components on the main thread
        DispatchQueue.main.async {
            self.calendar.reloadData()
            self.taskTableView.reloadData()
        }
    }

    private func categorizeTasksForSelectedDate(_ date: Date) {
        // Categorize tasks based on completion status for the selected date
        tasksForSelectedDate = taskItems.filter { Calendar.current.isDate($0.dueDate!, inSameDayAs: date) }
        completedTasksForSelectedDate = tasksForSelectedDate.filter { $0.isCompleted }
        inProgressTasksForSelectedDate = tasksForSelectedDate.filter { $0.isInProgess }
        upcomingTasksForSelectedDate = tasksForSelectedDate.filter { !$0.isCompleted && !$0.isInProgess }
    }

    private func updateTasksForSelectedDate(_ date: Date) {
        // Update categorized tasks for the selected date and update UI accordingly
        categorizeTasksForSelectedDate(date)
        noTaskLabel.isHidden = !tasksForSelectedDate.isEmpty
        noDataView.isHidden = !tasksForSelectedDate.isEmpty
        taskTableView.reloadData()
    }
}

// MARK: - FSCalendar Delegate and DataSource
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // Show a dot under the date if there are tasks for that date
        let tasksForDate = taskItems.filter { Calendar.current.isDate($0.dueDate ?? Date(), inSameDayAs: date) }
        return tasksForDate.isEmpty ? 0 : 1
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        // Customize event dot colors based on task completion status
        var colors: [UIColor] = []
        let tasksForDate = taskItems.filter { Calendar.current.isDate($0.dueDate ?? Date(), inSameDayAs: date) }
        
        if tasksForDate.contains(where: { $0.isCompleted }) {
            colors.append(.red) // Completed task
        }
        if tasksForDate.contains(where: { $0.isInProgess }) {
            colors.append(.green) // In-progress task
        }
        if tasksForDate.contains(where: { !$0.isCompleted && !$0.isInProgess }) {
            colors.append(.gray) // Upcoming task
        }
        
        return colors.isEmpty ? nil : colors
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Handle date selection on calendar
        updateTasksForSelectedDate(date)
    }
}

// MARK: - UITableView Delegate and DataSource
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        // Determine number of sections based on task categories
        var sectionCount = 0
        if !inProgressTasksForSelectedDate.isEmpty {
            sectionCount += 1
        }
        if !upcomingTasksForSelectedDate.isEmpty {
            sectionCount += 1
        }
        if !completedTasksForSelectedDate.isEmpty {
            sectionCount += 1
        }
        return sectionCount
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Provide section header titles based on task categories
        if !inProgressTasksForSelectedDate.isEmpty {
            if section == 0 {
                return "In Progress"
            } else if section == 1 && !upcomingTasksForSelectedDate.isEmpty {
                return "Upcoming"
            } else if section == 1 && upcomingTasksForSelectedDate.isEmpty {
                return "Completed"
            } else if section == 2 {
                return "Completed"
            }
        } else {
            if section == 0 && !upcomingTasksForSelectedDate.isEmpty {
                return "Upcoming"
            } else if section == 0 && upcomingTasksForSelectedDate.isEmpty {
                return "Completed"
            } else if section == 1 && !completedTasksForSelectedDate.isEmpty {
                return "Completed"
            }
        }
        
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Determine number of rows in each section based on task categories
        if !inProgressTasksForSelectedDate.isEmpty {
            if section == 0 {
                return inProgressTasksForSelectedDate.count
            } else if section == 1 && !upcomingTasksForSelectedDate.isEmpty {
                return upcomingTasksForSelectedDate.count
            } else if section == 1 && upcomingTasksForSelectedDate.isEmpty {
                return completedTasksForSelectedDate.count
            } else if section == 2 {
                return completedTasksForSelectedDate.count
            }
        } else {
            if section == 0 && !upcomingTasksForSelectedDate.isEmpty {
                return upcomingTasksForSelectedDate.count
            } else if section == 0 && upcomingTasksForSelectedDate.isEmpty {
                return completedTasksForSelectedDate.count
            } else if section == 1 && !completedTasksForSelectedDate.isEmpty {
                return completedTasksForSelectedDate.count
            }
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure table view cells with task data
        let taskCell = tableView.dequeueReusableCell(withIdentifier: AppStringConstant.taskTableViewCell, for: indexPath) as! TaskTableViewCell
        let task: TaskItem
        
        if !inProgressTasksForSelectedDate.isEmpty {
            if indexPath.section == 0 {
                task = inProgressTasksForSelectedDate[indexPath.row]
            } else if indexPath.section == 1 && !upcomingTasksForSelectedDate.isEmpty {
                task = upcomingTasksForSelectedDate[indexPath.row]
            } else {
                task = completedTasksForSelectedDate[indexPath.row]
            }
        } else {
            if indexPath.section == 0 && !upcomingTasksForSelectedDate.isEmpty {
                task = upcomingTasksForSelectedDate[indexPath.row]
            } else {
                task = completedTasksForSelectedDate[indexPath.row]
            }
        }

        taskCell.titleLabel.text = task.title
        taskCell.tickButton.setImage(UIImage(systemName: task.isCompleted ? "checkmark.circle.fill" : (task.isInProgess ? "clock.fill" : "circle")), for: .normal)
        
        // Handle task completion button tap
        taskCell.didTapTaskCompleteButton = { [weak self] in
            self?.handleTaskCompletionToggle(for: task)
        }

        // Set clear background view for selection
        taskCell.backgroundView = UIView()
        taskCell.backgroundView?.backgroundColor = UIColor.clear

        let clearView = UIView()
        clearView.backgroundColor = UIColor.clear
        taskCell.selectedBackgroundView = clearView

        return taskCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set fixed height for table view rows
        return 60
    }

    func handleTaskCompletionToggle(for task: TaskItem) {
        // Toggle task completion status and save changes
        if task.isCompleted {
            task.isCompleted = false
            task.isInProgess = true
        } else if task.isInProgess {
            task.isCompleted = true
            task.isInProgess = false
        } else {
            task.isInProgess = true
        }

        CoreDataManager.shared.saveContext()
        fetchTaskItems()
        updateTasksForSelectedDate(calendar.selectedDate ?? Date())
    }
}
