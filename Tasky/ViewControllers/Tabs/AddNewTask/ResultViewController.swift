//
//  ResultViewController.swift
//  Tasky
//
//  Created by Tilak Shakya on 15/06/24.
//

import UIKit
import MapKit

protocol ResultViewControllerDelegate: AnyObject {
    func didSelectMapItem(_ mapItem: MKMapItem)
}

protocol MapSearchDelegate: AnyObject {
    func didPerformSearch(with mapItems: [MKMapItem])
}


class ResultViewController: UIViewController {
    
    // MARK: - Properties
    var tableView: UITableView!
    var searchResults: [MKMapItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: ResultViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource
extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let mapItem = searchResults[indexPath.row]
        cell.textLabel?.text = mapItem.name
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMapItem = searchResults[indexPath.row]
        delegate?.didSelectMapItem(selectedMapItem)
    }
}
