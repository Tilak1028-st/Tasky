//
//  TaskTableViewCell.swift
//  Tasky
//
//  Created by Tilak Shakya on 16/06/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickButton: UIButton!
    
    var didTapTaskCompleteButton: (() -> Void )?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpMainView()
    }

    private func setUpMainView() {
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.2
        mainView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainView.layer.shadowRadius = 10
        mainView.layer.masksToBounds = false
        
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.clear.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: -1)
        contentView.layer.shadowRadius = 10
        contentView.layer.masksToBounds = false
        contentView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func didTapOnTickButton(_ sender: UIButton) {
        didTapTaskCompleteButton?()
    }
}
