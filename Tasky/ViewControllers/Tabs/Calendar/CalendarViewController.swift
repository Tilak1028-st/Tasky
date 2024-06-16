//
//  CalendarViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 16/06/24.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var noTaskLabel: UILabel!
    @IBOutlet weak var noDataView: UIView!
    
    var taskItems: [TaskItem] = []
    var tasksForSelectedDate: [TaskItem] = []
    var completedTasksForSelectedDate: [TaskItem] = []
    var upcomingTasksForSelectedDate: [TaskItem] = []
    var inProgressTasksForSelectedDate: [TaskItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        fetchTaskItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        fetchTaskItems()
    }

    private func setUpUI() {
        taskTableView.register(UINib(nibName: AppStringConstant.taskTableViewCell, bundle: nil), forCellReuseIdentifier: AppStringConstant.taskTableViewCell)
        taskTableView.separatorColor = UIColor.clear
        taskTableView.delegate = self
        taskTableView.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
        calendar.applyBorder(color: UIColor.gray, width: 1)
        calendar.applyCornerRadius(20)

        noTaskLabel.isHidden = true
        noDataView.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }

    private func fetchTaskItems() {
        taskItems = CoreDataManager.shared.fetchTaskItems()
        updateTasksForSelectedDate(calendar.selectedDate ?? Date())
        DispatchQueue.main.async {
            self.calendar.reloadData()
            self.taskTableView.reloadData()
        }
    }

    private func categorizeTasksForSelectedDate(_ date: Date) {
        tasksForSelectedDate = taskItems.filter { Calendar.current.isDate($0.dueDate!, inSameDayAs: date) }
        completedTasksForSelectedDate = tasksForSelectedDate.filter { $0.isCompleted }
        inProgressTasksForSelectedDate = tasksForSelectedDate.filter { $0.isInProgess }
        upcomingTasksForSelectedDate = tasksForSelectedDate.filter { !$0.isCompleted && !$0.isInProgess }
    }

    private func updateTasksForSelectedDate(_ date: Date) {
        categorizeTasksForSelectedDate(date)
        noTaskLabel.isHidden = !tasksForSelectedDate.isEmpty
        noDataView.isHidden = !tasksForSelectedDate.isEmpty
        taskTableView.reloadData()
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let tasksForDate = taskItems.filter { Calendar.current.isDate($0.dueDate ?? Date(), inSameDayAs: date) }
        return tasksForDate.isEmpty ? 0 : 1
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
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
        updateTasksForSelectedDate(date)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
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
        taskCell.didTapTaskCompleteButton = { [weak self] in
            self?.handleTaskCompletionToggle(for: task)
        }

        taskCell.backgroundView = UIView()
        taskCell.backgroundView?.backgroundColor = UIColor.clear

        let clearView = UIView()
        clearView.backgroundColor = UIColor.clear
        taskCell.selectedBackgroundView = clearView

        return taskCell
    }

    func handleTaskCompletionToggle(for task: TaskItem) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
