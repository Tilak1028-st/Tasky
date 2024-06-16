//
//  TaskViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit

import UIKit

class TaskViewController: UITabBarController {

    @IBOutlet weak var customTabBar: UITabBar!

    let addNewTaskButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("", for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 30
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.tintColor = .appGreen
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.setBackgroundImage(UIImage(systemName: ImageConstant.plusCircleFill), for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let buttonSize: CGFloat = 60
        let buttonYOffset: CGFloat = 80
        let buttonXPosition = view.bounds.width - buttonSize - 20
        let buttonYPosition = customTabBar.frame.origin.y - buttonSize / 2 - buttonYOffset
        addNewTaskButton.frame = CGRect(x: buttonXPosition, y: buttonYPosition, width: buttonSize, height: buttonSize)
        addNewTaskButton.addTarget(self, action: #selector(addNewTaskTapped), for: .touchUpInside)
        
        // Shadow
        addNewTaskButton.layer.cornerRadius = 10
        addNewTaskButton.layer.shadowColor = UIColor.black.cgColor
        addNewTaskButton.layer.shadowOpacity = 0.2
        addNewTaskButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        addNewTaskButton.layer.shadowRadius = 10
        addNewTaskButton.layer.masksToBounds = false
        
        view.addSubview(addNewTaskButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: view)
        
        // Check if the touch point is within the addNewTaskButton's frame
        if addNewTaskButton.frame.contains(touchPoint) {
            addNewTaskButton.sendActions(for: .touchUpInside)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reset navigation bar appearance to default for TaskViewController
        self.navigationController?.navigationBar.tintColor = nil // Reset to default
        self.navigationController?.navigationBar.barTintColor = nil // Reset to default
        self.navigationController?.navigationBar.titleTextAttributes = nil // Reset to default
    }

    override func loadView() {
        super.loadView()
        view.addSubview(addNewTaskButton)
        setupCustomTabBar()
    }

    func setupCustomTabBar() {
        customTabBar.itemPositioning = .centered
        customTabBar.tintColor = .gray
        customTabBar.itemWidth = 190
        customTabBar.tintColor = .appGreen
        
        // Apply the shadow to the tab bar's layer
        customTabBar.layer.shadowColor = UIColor.black.cgColor
        customTabBar.layer.shadowOpacity = 0.3
        customTabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        customTabBar.layer.shadowRadius = 10
        customTabBar.layer.masksToBounds = false
    }

    @objc func addNewTaskTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addNewTaskVc = storyboard.instantiateViewController(withIdentifier: "AddNewTaskViewController") as? AddNewTaskViewController else {
            return
        }

        // Customize the navigation bar appearance for AddNewTaskViewController
        let navController = UINavigationController(rootViewController: addNewTaskVc)
        navController.navigationBar.tintColor = .white
        navController.navigationBar.barTintColor = .black
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        // Push AddNewTaskViewController onto the navigation stack
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}
