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
    @IBOutlet weak var titlePostDate: UILabel!
    
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureApperance()
    }
    
    private func configureApperance() {
        selectionStyle = .none
        titlePostText.font = .systemFont(ofSize: 16)
        titlePostDate.font = .systemFont(ofSize: 10)
        titlePostDate.textColor = ColorsStorage.lightGray
    }
    
}
