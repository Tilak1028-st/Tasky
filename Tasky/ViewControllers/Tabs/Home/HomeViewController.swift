//
//  HomeViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var noTaskView: LottieAnimationView!
    
    var taskItems: [TaskItem] = []
    var completedTasks: [TaskItem] = []
    var upcomingTasks: [TaskItem] = []
    var inProgressTasks: [TaskItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        fetchTaskItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetch task items from Core Data
        fetchTaskItems()
        
        // Categorize tasks and reload table view
        categorizeAndReloadTasks()
        
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
    
    private func setUpUI() {
        self.title = "Task Manager"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        taskTableView.register(UINib(nibName: AppStringConstant.taskTableViewCell, bundle: nil), forCellReuseIdentifier: AppStringConstant.taskTableViewCell)
        taskTableView.separatorColor = UIColor.clear
    }
    
    
    private func setupNoTaskViewIfNeeded() {
        // Check if there are any task items
        if taskItems.isEmpty {
            taskTableView.isHidden = true
            noTaskView.isHidden = false
            
            // Load animation if it's not already loaded
            if noTaskView.animation == nil {
                guard let animation = LottieAnimation.named("noTask") else {
                    print("\(AppErrorConstant.animationLoadingError) \(AppStringConstant.secondOnboardingAnimation)")
                    return
                }
                noTaskView.animation = animation
                noTaskView.loopMode = .loop
                noTaskView.play()
            }
        } else {
            taskTableView.isHidden = false
            noTaskView.isHidden = true
        }
    }
    
    private func fetchTaskItems() {
        taskItems = CoreDataManager.shared.fetchTaskItems()
        // Trigger the fault for each TaskItem object by accessing a property
        for taskItem in taskItems {
            _ = taskItem.title
        }
        setupNoTaskViewIfNeeded()
    }
    
    private func categorizeAndReloadTasks() {
        // Check noTaskView
        setupNoTaskViewIfNeeded()
        completedTasks = taskItems.filter { $0.isCompleted }
        inProgressTasks = taskItems.filter { $0.isInProgess }
        upcomingTasks = taskItems.filter { !$0.isCompleted && !$0.isInProgess }
    }
    
    
    private func customizeSwipeActionButton(_ button: UIButton) {
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
    }
    
    private func updateTaskLists() {
        // Refetch and update task items from Core Data
        taskItems = CoreDataManager.shared.fetchTaskItems()
        
        // Categorize tasks
        categorizeAndReloadTasks()
        
        // Reload table view on the main thread
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
    
    func handleTaskCompletionToggle(for task: TaskItem) {
        if task.isCompleted {
            // Move from completed to in-progress
            task.isCompleted = false
            task.isInProgess = true
        } else if task.isInProgess {
            // Move from in-progress to completed
            task.isCompleted = true
            task.isInProgess = false
        } else {
            // Move from upcoming to in-progress
            task.isInProgess = true
        }
        
        CoreDataManager.shared.saveContext()
        updateTaskLists()
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 0
        if !inProgressTasks.isEmpty {
            sectionCount += 1
        }
        if !upcomingTasks.isEmpty {
            sectionCount += 1
        }
        if !completedTasks.isEmpty {
            sectionCount += 1
        }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !inProgressTasks.isEmpty {
            if section == 0 {
                return "In Progress"
            } else if section == 1  && !upcomingTasks.isEmpty {
                return "Upcoming"
            } else if section == 1  && upcomingTasks.isEmpty {
                return "Completed"
            } else if section == 2 {
                return "Completed"
            }
        } else {
            if section == 0 && !upcomingTasks.isEmpty {
                return "Upcoming"
            } else if section == 0 && upcomingTasks.isEmpty {
                return "Completed"
            } else if section == 1 && !completedTasks.isEmpty {
                return "Completed"
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !inProgressTasks.isEmpty {
            if section == 0 {
                return inProgressTasks.count
            } else if section == 1  && !upcomingTasks.isEmpty {
                return upcomingTasks.count
            } else if section == 1  && upcomingTasks.isEmpty {
                return completedTasks.count
            } else if section == 2 {
                return completedTasks.count
            }
        } else {
            if section == 0 && !upcomingTasks.isEmpty {
                return upcomingTasks.count
            } else if section == 0 && upcomingTasks.isEmpty {
                return completedTasks.count
            } else if section == 1 && !completedTasks.isEmpty {
                return completedTasks.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = taskTableView.dequeueReusableCell(withIdentifier: AppStringConstant.taskTableViewCell, for: indexPath) as! TaskTableViewCell
        
        let task: TaskItem
        
        if !inProgressTasks.isEmpty {
            if indexPath.section == 0 {
                task = inProgressTasks[indexPath.row]
            } else if indexPath.section == 1 && !upcomingTasks.isEmpty {
                task = upcomingTasks[indexPath.row]
            } else {
                task = completedTasks[indexPath.row]
            }
        } else {
            if indexPath.section == 0 && !upcomingTasks.isEmpty {
                task = upcomingTasks[indexPath.row]
            } else {
                task = completedTasks[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addNewTaskVc = storyboard.instantiateViewController(withIdentifier: "AddNewTaskViewController") as? AddNewTaskViewController else {
            return
        }
        let taskItem = taskItems[indexPath.row]
        addNewTaskVc.isEditingTask = true
        addNewTaskVc.taskItem = taskItem
        
        
        // Customize the navigation bar appearance for AddNewTaskViewController
        let navController = UINavigationController(rootViewController: addNewTaskVc)
        navController.navigationBar.tintColor = .white
        navController.navigationBar.barTintColor = .black
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Push AddNewTaskViewController onto the navigation stack
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskItem: TaskItem
        
        if !inProgressTasks.isEmpty {
            if indexPath.section == 0 {
                taskItem = inProgressTasks[indexPath.row]
            } else if indexPath.section == 1 && !upcomingTasks.isEmpty {
                taskItem = upcomingTasks[indexPath.row]
            } else {
                taskItem = completedTasks[indexPath.row]
            }
        } else {
            if indexPath.section == 0 && !upcomingTasks.isEmpty {
                taskItem = upcomingTasks[indexPath.row]
            } else {
                taskItem = completedTasks[indexPath.row]
            }
        }
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, handler) in
            CoreDataManager.shared.deleteTaskItem(taskItem: taskItem)
            self.updateTaskLists()
            handler(true)
        }
        deleteAction.image = UIImage(systemName: ImageConstant.trash)
        deleteAction.backgroundColor = UIColor(red: 255/255, green: 181/255, blue: 45/255, alpha: 1)
        
        
        // Mark as completed action
        let completeAction = UIContextualAction(style: .normal, title: nil) { (action, view, handler) in
            self.handleTaskCompletionToggle(for: taskItem)
            handler(true)
        }
        completeAction.image = UIImage(systemName: ImageConstant.checkmarkCircle)
        completeAction.backgroundColor = .systemGreen
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, completeAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        for subview in tableView.subviews where NSStringFromClass(type(of: subview)) == "_UITableViewCellSwipeContainerView" {
            for swipeContainerSubview in subview.subviews where NSStringFromClass(type(of: swipeContainerSubview)) == "UISwipeActionPullView" {
                for actionView in swipeContainerSubview.subviews where actionView is UIButton {
                    customizeSwipeActionButton(actionView as! UIButton)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
