//
//  DetailedPostTitleTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 06.08.2022.
//

import UIKit

class DetailedPostTitleTableViewCell: UITableViewCell {
    //MARK: - Views
    
    
    @IBOutlet weak var titlePostText: UILabel!
    @IBOutlet private weak var titlePostDate: UILabel!
    
    //MARK: - Properties
    var titleText: String = "" {
        didSet {
            titlePostText.text = titleText
        }
    }
    var titleDate: String = "" {
        didSet {
            titlePostDate.text = titleDate
        }
    }
    
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureApperance()
    }
    
    private func configureApperance() {
        selectionStyle = .none
        titlePostText.font = .systemFont(ofSize: 16)
        titlePostDate.font = .systemFont(ofSize: 10)
        titlePostDate.textColor = UIColor(displayP3Red: 0xB3 / 255, green: 0xB3 / 255, blue: 0xB3 / 255, alpha: 1)
    }
    
}
