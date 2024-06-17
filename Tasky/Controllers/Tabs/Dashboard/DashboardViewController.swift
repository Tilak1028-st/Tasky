//
//  DashboardViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit
import DGCharts
import CoreData
import Lottie

class DashboardViewController: UIViewController {

    // MARK: - Properties
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var pieChartView: PieChartView!
    var stackedBarChartView: BarChartView!
    var lineChartView: LineChartView!
    var noTaskView: LottieAnimationView!
    var noTaskLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupScrollView()
        setupPieChart()
        setupStackedBarChart()
        setupLineChart()
        setupNoTaskView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataAndUpdateUI()
    }
    
    // MARK: - UI Setup
    
    private func setUpUI() {
        self.title = "Dashboard"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupNoTaskView() {
        noTaskView = LottieAnimationView(name: "noTask")
        noTaskView.translatesAutoresizingMaskIntoConstraints = false
        noTaskView.loopMode = .loop
        noTaskView.isHidden = true
        view.addSubview(noTaskView)
        
        noTaskLabel = UILabel()
        noTaskLabel.text = "No data available"
        noTaskLabel.font = UIFont(name: "Avenir Next Heavy", size: 22.0)
        noTaskLabel.textAlignment = .center
        noTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noTaskLabel)
        
        NSLayoutConstraint.activate([
            noTaskView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTaskView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
           // noTaskView.widthAnchor.constraint(equalToConstant: 300),
            noTaskView.heightAnchor.constraint(equalToConstant: 325),
            
            noTaskLabel.topAnchor.constraint(equalTo: noTaskView.bottomAnchor, constant: 0),
            noTaskLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Chart Setup
    
    func setupPieChart() {
        pieChartView = PieChartView()
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pieChartView)
        
        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            pieChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pieChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Configure PieChartView
        pieChartView.drawHoleEnabled = false
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.usePercentValuesEnabled = false
        pieChartView.legend.enabled = false
    }
    
    func setupStackedBarChart() {
        stackedBarChartView = BarChartView()
        stackedBarChartView.dragYEnabled = false
        stackedBarChartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackedBarChartView)
        
        NSLayoutConstraint.activate([
            stackedBarChartView.topAnchor.constraint(equalTo: pieChartView.bottomAnchor, constant: 20),
            stackedBarChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackedBarChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackedBarChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Configure BarChartView
        stackedBarChartView.drawGridBackgroundEnabled = false
        stackedBarChartView.drawBordersEnabled = false
        stackedBarChartView.setScaleEnabled(false)
    }
    
    func setupLineChart() {
        lineChartView = LineChartView()
        lineChartView.dragYEnabled = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lineChartView)
        
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: stackedBarChartView.bottomAnchor, constant: 20),
            lineChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineChartView.heightAnchor.constraint(equalToConstant: 300),
            lineChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Configure LineChartView
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.drawBordersEnabled = false
        lineChartView.setScaleEnabled(false)
    }
    
    // MARK: - Data Fetch and Update
    
    func fetchDataAndUpdateUI() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let taskItems = CoreDataManager.shared.fetchTaskItems()
            
            var completedTasksCount = 0
            var upcomingTasksCount = 0
            var inProgressTasksCount = 0
            
            for task in taskItems {
                if task.isCompleted {
                    completedTasksCount += 1
                } else if task.isInProgess {
                    inProgressTasksCount += 1
                } else if !task.isInProgess && !task.isCompleted {
                    upcomingTasksCount += 1
                }
            }
            
            DispatchQueue.main.async {
                if completedTasksCount == 0 && upcomingTasksCount == 0 && inProgressTasksCount == 0 {
                    self.showNoTaskAnimation()
                } else {
                    self.hideNoTaskAnimation()
                    self.updatePieChart(completed: completedTasksCount, upcoming: upcomingTasksCount, inProgress: inProgressTasksCount)
                    self.updateStackedBarChart(completed: completedTasksCount, upcoming: upcomingTasksCount, inProgress: inProgressTasksCount)
                    self.updateLineChart(completed: completedTasksCount, upcoming: upcomingTasksCount, inProgress: inProgressTasksCount)
                }
            }
        }
    }
    
    // MARK: - Chart Data Update
    
    func updatePieChart(completed: Int, upcoming: Int, inProgress: Int) {
        // Create chart data entries
        let completedEntry = PieChartDataEntry(value: Double(completed), label: nil)
        let upcomingEntry = PieChartDataEntry(value: Double(upcoming), label: nil)
        let inProgressEntry = PieChartDataEntry(value: Double(inProgress), label: nil)
        
        // Update the colors to match the second image
        let dataSet = PieChartDataSet(entries: [completedEntry, inProgressEntry, upcomingEntry], label: "") // Label set to nil
        dataSet.colors = [UIColor.systemGreen, UIColor.systemOrange, UIColor.systemBlue] // Adjust order to match
        
        // Create pie chart data
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.drawHoleEnabled = true
        
        // Format the center text
        let centerText = """
        Completed: \(completed)
        Upcoming: \(upcoming)
        In Progress: \(inProgress)
        """
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedCenterText = NSAttributedString(
            string: centerText,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
        pieChartView.centerAttributedText = attributedCenterText
        
        // Adjust pie chart styling
        pieChartView.holeRadiusPercent = 0.55 // Larger hole
        pieChartView.transparentCircleRadiusPercent = 0.6 // Adjust transparency circle
        
        // Optional: Customize the chart description if needed
        pieChartView.chartDescription.text = nil // Hide description for cleaner look
        
        // Optional: Hide the legend if you want to match the second image style
        pieChartView.legend.enabled = false
        
        // Animate the chart
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    func updateStackedBarChart(completed: Int, upcoming: Int, inProgress: Int) {
        let completedEntry = BarChartDataEntry(x: 0, yValues: [Double(completed)])
        let upcomingEntry = BarChartDataEntry(x: 1, yValues: [Double(upcoming)])
        let inProgressEntry = BarChartDataEntry(x: 2, yValues: [Double(inProgress)])
        
        let dataSet = BarChartDataSet(entries: [completedEntry, upcomingEntry, inProgressEntry], label: "Task Status")
        dataSet.colors = [UIColor.systemGreen, UIColor.systemBlue, UIColor.systemOrange]
        dataSet.stackLabels = ["Completed", "Upcoming", "In Progress"]
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.5
        
        stackedBarChartView.data = data
        stackedBarChartView.animate(yAxisDuration: 1.4, easingOption: .easeOutBack)
        
        let xAxis = stackedBarChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 3
        xAxis.axisMinimum = -0.5
        xAxis.axisMaximum = 2.5
        xAxis.granularity = 1
        xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Completed", "Upcoming", "In Progress"])
        
        let leftAxis = stackedBarChartView.leftAxis
        leftAxis.axisMinimum = 0
        
        let rightAxis = stackedBarChartView.rightAxis
        rightAxis.enabled = false
    }
    
    func updateLineChart(completed: Int, upcoming: Int, inProgress: Int) {
        let dataPoints = [
            ChartDataEntry(x: 0, y: Double(completed)),
            ChartDataEntry(x: 1, y: Double(upcoming)),
            ChartDataEntry(x: 2, y: Double(inProgress))
        ]
        
        let dataSet = LineChartDataSet(entries: dataPoints, label: "Tasks Over Time")
        dataSet.colors = [UIColor.systemTeal]
        dataSet.circleColors = [UIColor.systemTeal]
        dataSet.fillColor = UIColor.systemTeal
        dataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.axisMinimum = 0
        
        let rightAxis = lineChartView.rightAxis
        rightAxis.enabled = false
    }
    
    // MARK: - No Task Animation
    
    func showNoTaskAnimation() {
        noTaskView.isHidden = false
        noTaskLabel.isHidden = false
        noTaskView.play()
        
        pieChartView.isHidden = true
        stackedBarChartView.isHidden = true
        lineChartView.isHidden = true
    }
    
    func hideNoTaskAnimation() {
        noTaskView.isHidden = true
        noTaskLabel.isHidden = true
        noTaskView.stop()
        
        pieChartView.isHidden = false
        stackedBarChartView.isHidden = false
        lineChartView.isHidden = false
    }
}
