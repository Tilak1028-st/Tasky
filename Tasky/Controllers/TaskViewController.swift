//
//  TaskViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit

class TaskViewController: UITabBarController {

    // MARK: - Outlets
    @IBOutlet weak var customTabBar: UITabBar!

    // MARK: - Properties
    private let addNewTaskButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 30
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.tintColor = .appGreen
        btn.setBackgroundImage(UIImage(systemName: ImageConstant.plusCircleFill), for: .normal)
        return btn
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAddNewTaskButton()
        setupCustomTabBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBarAppearance()
    }

    override func loadView() {
        super.loadView()
        view.addSubview(addNewTaskButton)
    }

    // MARK: - Private Methods
    private func setupAddNewTaskButton() {
        let buttonSize: CGFloat = 60
        let buttonYOffset: CGFloat = 80
        let buttonXPosition = view.bounds.width - buttonSize - 20
        let buttonYPosition = customTabBar.frame.origin.y - buttonSize / 2 - buttonYOffset
        addNewTaskButton.frame = CGRect(x: buttonXPosition, y: buttonYPosition, width: buttonSize, height: buttonSize)

        // Configure button properties
        addNewTaskButton.layer.cornerRadius = 10
        addNewTaskButton.layer.shadowColor = UIColor.black.cgColor
        addNewTaskButton.layer.shadowOpacity = 0.2
        addNewTaskButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        addNewTaskButton.layer.shadowRadius = 10
        addNewTaskButton.layer.masksToBounds = false

        // Add target for button tap
        addNewTaskButton.addTarget(self, action: #selector(addNewTaskTapped), for: .touchUpInside)

        // Add button to the view hierarchy
        view.addSubview(addNewTaskButton)
    }

    private func setupCustomTabBar() {
        // Configure custom tab bar appearance
        customTabBar.itemPositioning = .centered
        customTabBar.tintColor = .gray
        customTabBar.itemWidth = 190
        customTabBar.tintColor = .appGreen
        
        // Apply shadow to the tab bar's layer
        customTabBar.layer.shadowColor = UIColor.black.cgColor
        customTabBar.layer.shadowOpacity = 0.3
        customTabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        customTabBar.layer.shadowRadius = 10
        customTabBar.layer.masksToBounds = false
    }

    private func setupNavigationBarAppearance() {
        // Reset navigation bar appearance if needed
        navigationController?.navigationBar.tintColor = nil
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.titleTextAttributes = nil
    }

    // MARK: - Action Methods
    @objc private func addNewTaskTapped() {
        // Handle tap on the add new task button
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addNewTaskVc = storyboard.instantiateViewController(withIdentifier: "AddNewTaskViewController") as? AddNewTaskViewController else {
            return
        }

        let navController = UINavigationController(rootViewController: addNewTaskVc)
        navController.navigationBar.tintColor = .white
        navController.navigationBar.barTintColor = .black
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
