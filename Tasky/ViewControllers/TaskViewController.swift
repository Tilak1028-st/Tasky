//
//  TaskViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit

class TaskViewController: UITabBarController {
    
    
    @IBOutlet weak var customTabBar: UITabBar!
    
    
    let addNewTaskButton : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        btn.setTitle("", for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 30
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.setBackgroundImage(UIImage(systemName: ImageConstant.plusCircleFill), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calculate the button size and position relative to the customTabBar
        let buttonSize: CGFloat = 60
        let buttonYOffset: CGFloat = 10 // Adjust this value to move the button up or down
        let buttonXPosition = customTabBar.bounds.width / 2 - buttonSize / 2
        let buttonYPosition = customTabBar.bounds.height - buttonSize - buttonYOffset
        addNewTaskButton.frame = CGRect(x: buttonXPosition, y: buttonYPosition, width: buttonSize, height: buttonSize)
        
        // Add target action for button tap
        addNewTaskButton.addTarget(self, action: #selector(addNewTaskTapped), for: .touchUpInside)
        
        // Add btnMiddle to customTabBar
        customTabBar.addSubview(addNewTaskButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: customTabBar)
        
        // Check if the touch point is within the btnMiddle's frame
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
        customTabBar.addSubview(addNewTaskButton)
        setupCustomTabBar()
    }
    
    func setupCustomTabBar() {
        let path : UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.white.cgColor
        customTabBar.layer.insertSublayer(shape, at: 0)
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
    
    
    private func getPathForTabBar() -> UIBezierPath {
        let frameWidth = self.tabBar.bounds.width
        let frameHeight = self.tabBar.bounds.height + 20
        let holeWidth = 160
        let holeHeight = 85
        let leftXUntilHole = Int(frameWidth/2) - Int(holeWidth/2)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: leftXUntilHole, y: 0)) // 1.Line
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2),
                      controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*4, y: 0),
                      controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6, y: holeHeight/2 - 10)) // part I
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2),
                      controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2/4, y: (holeHeight/2)*5/4),
                      controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 - (holeWidth/3)/3*2/4, y: (holeHeight/2)*5/4)) // part II
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0),
                      controlPoint1: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + ((holeWidth/3)/8)*2, y: holeHeight/2 - 10),
                      controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + ((holeWidth/3)/8)*4, y: 0)) // part III
        
        path.addLine(to: CGPoint(x: frameWidth, y: 0)) // 2. Line
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight)) // 3. Line
        path.addLine(to: CGPoint(x: 0, y: frameHeight)) // 4. Line
        path.addLine(to: CGPoint(x: 0, y: 0)) // 5. Line
        path.close()
        return path
    }
    
    
    
    @objc func addNewTaskTapped() {
        let addNewTaskVc = self.storyboard?.instantiateViewController(identifier: AppStringConstant.addNewTaskViewController) as! AddNewTaskViewController
        
        // Customize the navigation controller's navigation bar appearance
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Customize the transition style for AddNewTaskViewController
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .moveIn
        transition.subtype = .fromTop
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        // Push the AddNewTaskViewController onto the navigation stack
        self.navigationController?.pushViewController(addNewTaskVc, animated: false) // Set animated to false if using custom transition
    }
}
