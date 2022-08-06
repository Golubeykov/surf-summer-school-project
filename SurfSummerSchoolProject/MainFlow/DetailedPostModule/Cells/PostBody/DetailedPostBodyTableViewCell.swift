//
//  DetailedPostBodyTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 06.08.2022.
//

import UIKit

class DetailedPostBodyTableViewCell: UITableViewCell {
    //MARK: - Views
    @IBOutlet weak var postBodyText: UILabel!
    
    //MARK: - Properties
    var bodyText: String = "" {
        didSet {
            postBodyText.text = bodyText
        }
    }
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureApperance()
    }
    
    private func configureApperance() {
        selectionStyle = .none
        postBodyText.font = .systemFont(ofSize: 12, weight: .light)
        postBodyText.textColor = .black
    }
    
}
